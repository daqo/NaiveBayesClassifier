require 'set'
require 'ostruct'

module FileUtility

  def FileUtility.read(path)
    vocabulary = Set.new
    classes = Set.new
    records = []

    File.open(path, "r").each_line do |line|
      line_array = line.split(' ')
      record = OpenStruct.new
      record.category = line_array[0]
      record.words = line_array.drop(1)

      records << record
      
      record.words.each { |w| vocabulary.add(w) }
      classes.add(record.category)
    end

    return classes.to_a, vocabulary.to_a, records
  end

end