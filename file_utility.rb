require 'set'

module FileUtility

  def FileUtility.read(path)
    vocabulary = Set.new
    classes = []
    records = []

    File.open(path, "r").each_line do |line|
      
      records << line
      words_per_line = line.split(' ').drop(1)
      words_per_line.each do |w|
        #unless vocabulary.include? w
          #vocabulary << w
          vocabulary.add(w)
        #end
      end

      unless classes.include? line.split(' ').shift
        classes << line.split(' ').shift
      end
    end

    return classes, vocabulary.to_a, records
  end

end