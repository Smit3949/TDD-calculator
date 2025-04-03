class Calculator
  def self.add(numbers)
    return 0 if numbers.strip.empty?
    sum = 0
    numbers.split(/[,\n]/).map do |number|
        number.strip!
        if number.match?(/[^0-9\-]/)
            invalid_char = number[/[^0-9\-]/]
            error_position = numbers.index(invalid_char)
            raise "Unexpected #{invalid_char} at position #{error_position}"
        end
        begin
            int_number = number == "" ? 0 : Integer(number)
        rescue ArgumentError
            raise "Cannot convert #{number} to Integer"
        end
        raise "Negative numbers not allowed: #{int_number}" if int_number < 0
        sum += int_number
    end
    sum
  end
end

RSpec.describe ::Calculator, type: :helper do
  describe '.add' do
    it 'returns 0 for an empty string' do
      expect(Calculator.add("")).to eq(0)
    end

    it 'returns the number itself when a single number is provided' do
      expect(Calculator.add("1")).to eq(1)
      expect(Calculator.add("10")).to eq(10)
    end

    it 'returns the sum of two numbers with one digit' do
      expect(Calculator.add("1,5")).to eq(6)
    end

    it 'returns the sum of multiple numbers with multiple digits' do
      expect(Calculator.add("10,20,30,40")).to eq(100)
    end

    it 'handles spaces around numbers' do
      expect(Calculator.add(" 1 , 2 , 3 ")).to eq(6)
    end

    it 'handles unexpected characters within numbers' do
      expect { Calculator.add("1;2,3") }.to raise_error("Unexpected ; at position 1")
    end

    it 'raises an error for negative numbers' do
      expect { Calculator.add("1,-2,3") }.to raise_error("Negative numbers not allowed: -2")
    end

    it 'handles multiple negative numbers and reports the first negative' do
        expect { Calculator.add("-1,-2,3") }.to raise_error("Negative numbers not allowed: -1")
    end

    it 'raises an error for a single negative number' do
        expect { Calculator.add("-5") }.to raise_error("Negative numbers not allowed: -5")
    end

    it 'allows hyphens only at the start of numbers (invalid hyphen placement)' do
        expect { Calculator.add("12-34") }.to raise_error("Cannot convert 12-34 to Integer")
    end

    it 'handles numbers with multiple hyphens (invalid syntax)' do
        expect { Calculator.add("--5") }.to raise_error("Cannot convert --5 to Integer")
    end

    it 'rejects a standalone hyphen as an invalid number' do
        expect { Calculator.add("-") }.to raise_error("Cannot convert - to Integer")
    end

    it 'processes numbers with leading zeros correctly' do
        expect(Calculator.add("0005,03")).to eq(8)
    end

    it 'handles very large numbers' do
        expect(Calculator.add("9999999999999999999,1")).to eq(10000000000000000000)
    end

    it 'reports the first invalid character in mixed valid/invalid input' do
        expect { Calculator.add("1,a,3") }.to raise_error("Unexpected a at position 2")
    end

    it 'handles empty entries between commas as zero' do
        expect(Calculator.add("1,,3")).to eq(4)
    end

    it 'processes whitespace-only input as zero' do
        expect(Calculator.add("   ")).to eq(0)
    end

    it 'handles newline characters within numbers' do
      expect(Calculator.add("1\n2,3")).to eq(6)
    end

    it 'returns 0 for an empty string with only \n in string' do
      expect(Calculator.add("\n\n\n")).to eq(0)
    end

    describe 'with newline characters' do
        it 'returns the number itself when a single number is provided' do
            expect(Calculator.add("\n1")).to eq(1)
            expect(Calculator.add("\n10")).to eq(10)
        end

        it 'returns the sum of multiple numbers with multiple digits' do
            expect(Calculator.add("10\n20\n30,40")).to eq(100)
        end

        it 'handles spaces around numbers' do
            expect(Calculator.add(" 1 \n 2 , 3 ")).to eq(6)
        end

        it 'handles unexpected characters within numbers' do
            expect { Calculator.add("1;2,3\n4") }.to raise_error("Unexpected ; at position 1")
        end

        it 'raises an error for negative numbers' do
            expect { Calculator.add("1\n-2,3") }.to raise_error("Negative numbers not allowed: -2")
        end

        it 'handles multiple negative numbers and reports the first negative' do
            expect { Calculator.add("-1\n-2\n3") }.to raise_error("Negative numbers not allowed: -1")
        end

        it 'processes numbers with leading zeros correctly' do
            expect(Calculator.add("0005\n03")).to eq(8)
        end

        it 'handles very large numbers' do
            expect(Calculator.add("9999999999999999999\n1")).to eq(10000000000000000000)
        end

        it 'reports the first invalid character in mixed valid/invalid input' do
            expect { Calculator.add("1\na,3") }.to raise_error("Unexpected a at position 2")
        end

        it 'handles empty entries between commas as zero' do
            expect(Calculator.add("1\n \n3")).to eq(4)
        end
    end
  end
end