require 'set'
require 'ostruct'
require 'debugger'

module FileUtility

  def FileUtility.read(path)
    vocabulary = Set.new
    classes = []
    records = []

    File.open(path, "r").each_line do |line|
      line_array = line.split(' ')
      record = OpenStruct.new
      record.category = line_array.first
      record.words = line_array.drop(1)

      records << record
      record.words.each do |w|
          vocabulary.add(w)
      end

      unless classes.include? line.split(' ').shift
        classes << line.split(' ').shift
      end
    end

    return classes, vocabulary.to_a, records
  end

end