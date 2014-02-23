module ImpurityMeasurer
  ENTROPY = 0
  GINI = 1
  CLASSIFICATION_ERROR =2

  def self.calculate_classification_error(data, possible_oracles)
    oracles = {}

    possible_oracles.each do |value|
      oracles[value.downcase.to_sym] = data.select { |r| r.oracle.eql?(value) }
    end

    set_of_p = []
    oracles.each do |(key, records)|
      p = records.size.to_f / data.size
      set_of_p << (p.nan? ? 0 : p)
    end

    
    return 1 - set_of_p.max
  end

  def self.calculate_gini(data, possible_oracles)
    oracles = {}

    possible_oracles.each do |value|
      oracles[value.downcase.to_sym] = data.select { |r| r.oracle.eql?(value) }
    end

    gini = oracles.reduce(1) do |gini, (key, records)|
      p = records.size.to_f / data.size
      gini - p ** 2
    end
    gini.nan? ? 0 : gini
  end

  def self.calculate_entropy(data, possible_oracles)
    oracles = {}

    possible_oracles.each do |value|
      oracles[value.downcase.to_sym] = data.select { |r| r.oracle.eql?(value) }
    end

    entropy = oracles.reduce(0) do |entropy, (key, records)|
      p = records.size.to_f / data.size
      amount = (p == 0) ? 0 : p * Math.log(p,2)
      entropy - amount
    end

    entropy.nan? ? 0 : entropy
  end
end