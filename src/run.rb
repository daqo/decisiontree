$LOAD_PATH << '.'

require 'file_utility'
require 'machine_learner'


possible_oracles, attributes, test_data = FileUtility.read("../DataSets/contact-lenses.data")
learner = MachineLearner.new(test_data, attributes, possible_oracles)
learner.show_tree

while true
  puts "\nEnter a new record in hash format, I will predict the result for you:"
  record = eval gets.chomp
  puts "Oracle is #{learner.predict(record)}."
end

# Sample data for input
#{ wind: "Weak", water: "Moderate", air: "Warm", forecast: "Rainy" }
#{ age: "young", prescription: "myope", astigmatism: "no", tearrate: "normal" }