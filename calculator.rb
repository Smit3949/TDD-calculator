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
      expect(Calculator.add("1\n2,3")).to eq("Unexpected '\\n' at position 1")
    end

    it 'raises an error for negative numbers' do
      expect { Calculator.add("1,-2,3") }.to raise_error("Negative numbers not allowed: -2")
    end
  end
end