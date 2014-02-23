$LOAD_PATH << '.'

require 'file_utility'
require 'machine_learner'
require 'impurity_measurer'

possible_oracles, attributes, test_data = FileUtility.read("../DataSets/contact-lenses.data")

learner = MachineLearner.new(test_data, attributes, possible_oracles, ImpurityMeasurer::GINI)
#learner = MachineLearner.new(test_data, attributes, possible_oracles, ImpurityMeasurer::CLASSIFICATION_ERROR)
#learner = MachineLearner.new(test_data, attributes, possible_oracles, ImpurityMeasurer::ENTROPY)
learner.show_tree

while true
  puts "\nEnter a new record in hash format, I will predict the result for you:"
  record = eval gets.chomp
  puts "Oracle is #{learner.predict(record)}."
end

# Sample data for input
#{ wind: "Strong", water: "Moderate", air: "Warm", forecast: "Rainy" }
#{ age: "young", prescription: "myope", astigmatism: "no", tearrate: "normal" }