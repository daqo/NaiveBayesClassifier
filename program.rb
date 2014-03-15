$LOAD_PATH << '.'
require 'file_utility'
require 'debugger'


def find_documents_related_to_class(c, records)
  records_for_class_c = records.select { |r| r.split(' ')[0] == c }
end

def find_probability_of_a_class(number_of_documents_in_the_class, records)
  number_of_documents_in_the_class.to_f / records.size
end

def create_single_document_for_class(c, records)
  text = []
  records.each do |line|
    record = line.split(' ')
    if record.first == c
      text << record.drop(1)
    end
  end
  text
end

def number_of_times_word_occurs_in_current_class_text(text, vocab_word)
  count = 0
  text.each do |w|
    count += 1 if w == vocab_word
  end
  count
end

classes, vocabulary, records = FileUtility.read('../data/forumTestSmall.data')


document = {}
probability = {}
text = {}
occurance_time = {}
word_probability = {}

classes.each do |c|
  current_class = c.to_sym
  document[current_class] = find_documents_related_to_class(c, records)
  probability[current_class] = find_probability_of_a_class(document[current_class].size, records)
  text[current_class] = create_single_document_for_class(c, records).flatten

  vocabulary.each do |word|
    occurance_time[current_class] ||= {}
    occurance_time[current_class][word] =
        number_of_times_word_occurs_in_current_class_text(text[current_class], word)
    word_probability[current_class] ||= {}
    word_probability[current_class][word] =
          (1 + occurance_time[current_class][word]).to_f / (text[current_class].size + vocabulary.size)

  end
end

debugger
puts 'debug'
