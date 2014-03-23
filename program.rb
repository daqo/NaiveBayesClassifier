$LOAD_PATH << '.'
require 'file_utility'
require 'ostruct'
require 'bigdecimal'

def classify_documents_in_categories(classes, records)
  document = {}

  classes.each do |c|
    document[c] = []
  end

  records.each do |r|
    document[r.category] << r.words
  end

  document
end

def classify(classes, vocabulary, class_probablity, word_probability, document)
  words = document.split(' ').select {|w| vocabulary.include? w }
  products = {}

  classes.each do |c|
    product = BigDecimal(1)
    product *= class_probablity[c]
    words.each do |word|
      product = product * word_probability[c][word]
    end
    products[c.to_sym] = product
  end
  key = products.max_by{|k,v| v}[0]
end

classes, vocabulary, records = FileUtility.read('../data/forumTraining-stemmed.data')

document = {}
probability = {}
text = {}
occurance_time = {}
word_probability = {}
count = {}
all_records_num = records.size

document = classify_documents_in_categories(classes, records)

classes.each do |current_class|
  probability[current_class] = document[current_class].size.to_f / all_records_num
  text[current_class] = document[current_class].join(' ')

  count[current_class] = {}
  vocabulary.each do |v|
    count[current_class][v] = 0
  end

  text[current_class].split(' ').each do |w|
    count[current_class][w] += 1 unless count[current_class][w].nil?
  end

  vocabulary.each do |word|
    word_probability[current_class] ||= {}
    word_probability[current_class][word] = (1 + count[current_class][word]).to_f / (text[current_class].size + vocabulary.size)
  end
end



test_record = OpenStruct.new
accurate_prediction_count = 0
count = 0
false_prediction_count = 0
File.open('../data/forumTest-stemmed.data', "r").each_line do |line|
  count += 1
  data = line.split(" ")
  test_record.real_category = data[0]
  test_record.content = data.drop(1).join(' ')
  oracle = classify(classes, vocabulary, probability, word_probability, test_record.content)
  puts "oracle: #{oracle}, real: #{test_record.real_category}"
  if oracle == test_record.real_category.to_sym
    accurate_prediction_count += 1 
  else
    false_prediction_count += 1
  end
end

puts "Total number of records: #{count}"
puts "Number of correct predictions: #{accurate_prediction_count}"
puts "Number of false predictions: #{false_prediction_count}"