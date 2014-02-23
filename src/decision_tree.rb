require 'impurity'
require 'debugger'
module DecisionTree
  class ID3Tree
    attr_accessor :possible_oracles, :splitting_function

    def initialize(oracle_set, splitting_function)
      self.possible_oracles = oracle_set
      self.splitting_function = splitting_function
    end

    def key_with_max_value?(hash)
      hash.max_by{|k,v| v}[0]
    end

    def calculate_impurity(data)
      case self.splitting_function
      when Impurity::ENTROPY
        Impurity.calculate_entropy(data, @possible_oracles)
      when Impurity::GINI
        Impurity.calculate_gini(data, @possible_oracles)
      when Impurity::CLASSIFICATION_ERROR
        Impurity.calculate_classification_error(data, @possible_oracles)
      end
    end

    def gain(data, label, attributes, impurity, impurity_S)
      possible_values = attributes[label]

      gain = possible_values.reduce(impurity_S) do |gain, value|
        count = (data.select { |r| r.send(label) == value }).size.to_f
        gain - count / data.size * impurity[label][value.downcase.to_sym]
      end
    end

    def calculate_impurity_for_all_labels(data, attributes)
      impurity = {}
      attributes.keys.each do |label|
        impurity[label] = {}
        attributes[label].each do |v|
          impurity[label][v.downcase.to_sym] =
            calculate_impurity( data.select { |r| r.send(label).eql?(v) })
        end
      end
      return impurity
    end

    def total_gain_for_all_labels(data, attributes, impurity, impurity_S)
      total_gain = {}
      attributes.keys.each do |label|
        total_gain[label] = gain(data, label, attributes, impurity, impurity_S)
      end

      return total_gain
    end

    def find_root(data, attributes)
      impurity_S = calculate_impurity(data)
      impurity = calculate_impurity_for_all_labels(data, attributes)
      total_gain = total_gain_for_all_labels(data, attributes, impurity, impurity_S)
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
