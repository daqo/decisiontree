module DecisionTree
  class ID3Tree
    attr_accessor :possible_oracles

    def initialize(oracle_set)
      self.possible_oracles = oracle_set
    end

    def key_with_max_value?(hash)
      hash.max_by{|k,v| v}[0]
    end

    def calculate_entropy(data)
      oracles = {}

      @possible_oracles.each do |value|
        oracles[value.downcase.to_sym] = data.select { |r| r.oracle.eql?(value) }
      end

      entropy = oracles.reduce(0) do |entropy, (key, records)|
        p = records.size.to_f / data.size
        amount = (p == 0) ? 0 : p * Math.log(p,2)
        entropy - amount
      end

      entropy.nan? ? 0 : entropy
    end

    def gain(data, label, attributes, entropy, entropy_S)
      possible_values = attributes[label]

      gain = possible_values.reduce(entropy_S) do |gain, value|
        count = (data.select { |r| r.send(label) == value }).size.to_f
        gain - count / data.size * entropy[label][value.downcase.to_sym]
      end
    end

    def calculate_entropy_for_all_labels(data, attributes)
      entropy = {}
      attributes.keys.each do |label|
        entropy[label] = {}
        attributes[label].each do |v|
          entropy[label][v.downcase.to_sym] =
            calculate_entropy( data.select { |r| r.send(label).eql?(v) })
        end
      end
      return entropy
    end

    def total_gain_for_all_labels(data, attributes, entropy, entropy_S)
      total_gain = {}
      attributes.keys.each do |label|
        total_gain[label] = gain(data, label, attributes, entropy, entropy_S)
      end

      return total_gain
    end

    def find_root(data, attributes)
      entropy_S = calculate_entropy(data)
      entropy = calculate_entropy_for_all_labels(data, attributes)
      total_gain = total_gain_for_all_labels(data, attributes, entropy, entropy_S)
      max_label = key_with_max_value?(total_gain)

      max_label
    end

    def train(data, attributes)
      node = Hash.new
      if (data.collect { |r| r.oracle }).uniq.size <= 1
        return data.first.oracle
      else
        max_label = find_root(data, attributes)
        attributes[max_label].each do |value|
          node[max_label.to_s] ||= Hash.new
          node[max_label.to_s][value.downcase] = train(data.select { |r| r.send(max_label) == value }, 
                                                       attributes.reject { |k,v| k == max_label })
        end
        return node
      end
    end
  end
end
