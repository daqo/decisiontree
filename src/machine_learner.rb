require 'decision_tree'
require 'ostruct'
require 'yaml'

class MachineLearner
  attr_accessor :root

  def initialize(data, attributes, possible_oracles)
    tree = DecisionTree::ID3Tree.new(possible_oracles)
    @root = tree.train(data, attributes)
  end

  def leaf?(node)
    node.class == String
  end

  def predict(hash_record)
    record = OpenStruct.new(hash_record)
    node = @root
    while !leaf?(node)
      node = node[node.keys[0]][record.send(node.keys[0]).downcase]
    end

    node
  end

  def show_tree
    puts @root.to_yaml
  end
end