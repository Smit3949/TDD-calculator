
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
        expect { Calculator.add("12-34") }.to raise_error("Unexpected - at position 2")
    end

    it 'handles numbers with multiple hyphens (invalid syntax)' do
        expect { Calculator.add("--5") }.to raise_error("Unexpected - at position 1")
    end

    it 'rejects a standalone hyphen as an invalid number' do
        expect { Calculator.add("-") }.to raise_error("Unexpected - at position 0")
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
  end
end