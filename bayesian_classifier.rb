$LOAD_PATH << '.'
require 'file_utility'
require 'ostruct'
require 'bigdecimal'

private
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

def train(path)
  classes, vocabulary, records = FileUtility.read(path)

  probability = {}
  text = {}
  word_probability = {}
  count = {}

  document = classify_documents_in_categories(classes, records)


  classes.each do |current_class|
    probability[current_class] = document[current_class].size.to_f / records.size
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

  return classes, vocabulary, probability, word_probability
end

def classify_whole_file(path, classes, vocabulary, probability, word_probability)
  test_record = OpenStruct.new
  accurate_prediction_count = 0
  count = 0
  false_prediction_count = 0
  File.open(path, "r").each_line do |line|
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
end



##### Execution begins here #######

classes, vocabulary, probability, word_probability = train('data/forumTraining-stemmed.data')
# To classify a whole datafile use this (datafile is a file containing a full document in per line) 
classify_whole_file('data/forumTest-stemmed.data', classes, vocabulary, probability, word_probability)


# To classify only a document use classify method directly
# puts classify(classes, vocabulary, probability, word_probability, "contract for comput law modul ask write comput contract for suppli comput softwar busi softwar written for compani per chanc happen copi comput contract system mail comput contract contain sensit materi can assur that will remain confidenti and will not pass view hbl graham wilson lsg cck coventri law iii coventri univers")
# puts classify classes, vocabulary, probability, word_probability, "space surveil meant peopl answer and email question countri engag space surveil appar didn make mean messag clear sinc repli address satellit reconnaiss space surveil meant not countri us satellit earth satellit reconnaiss countri program detect and track determin orbit element satellit pass overhead space surveil missil defens radar supplement fascin quasi radar oper navi thi for satellit leo and electroopt system for object altitud fee understand thing amateur satellit observ us eyebal binocular stopwatch and pc for object enabl track satellit for offici element set aren fascin book desmond king hele for detail file molczan directori kilroi jpl nasa gov materi post previou messag suggest that japan engag optic and radar space surveil modest degre and that countri question meant and allen thomson saic mclean don speak for saic"
# puts classify classes, vocabulary, probability, word_probability, "waco survivor april articl segz mwr dscomsa desi hallam dscomsa desi phill hallam baker articl apm apr hpopdlau pwd apm hpopdlau pwd andrew merritt write path dscomsa dxcern mcsun uknet pipex uunet sdd hpscit apm apm hpopdlau pwd andrew merritt articl apr vm ocom okstat edu chorlei vm ocom okstat edu write stuff british cult member delet exactli you and fire engin mile compound gun looni fire vehicl amunit that rang meter calib ammunit not ammo shell thi size larger lot cannon shell sniper screen peopl put fire ranch hous not fort apocalyps hous despit fbi and atf fire gun looni couldn shoot fire men hous engulf flame fbi and atf don excus for not fire engin put blaze bastard wait fire call fire depart waco didn even fire depart standbi sincer hope that fbi atf attornei gener janet reno and involv thi fiasco punish that richli deserv pai for thi needless tragic wast human life sadli evil sob will never face justic media and govern will whitewash thi incid and chalk sole david koresh fault sadder american peopl will question problem law that bunch rave nutter collect huge stack arm place thi not problem problem that govern that tyrann dai peopl decid gun and live place togeth that prerog hand bd posess explos and illeg gun govern search compound alleg that bd posess illeg weapon hasn proven not conclud that bd broke law david koresh accus abus children thi crime presenc atf can justifi atf suppos deal firearm tobacco and alcohol violat atf agent basic cigarett cop stai kind law enforc action that jurisdict tcan imo sequenc event meant that option attempt sort breakthrough intervent fbi had had stomach for mount commando type raid and attempt save children shoot adult sound human life children and adult alik treat respect even heavili arm religi wacko david koresh lawyer that come peacefulli sooner fbi and atf had noth time hand escal situat and thi senseless tragedi job protect public and save live not kill peopl for cry loud win situat koresh had plenti opportun give and stand trial for murder atf offic order murder children don that read newspap todai that cult member that tank wall that knock lantern caus ranch hous caught fire thi cult member that david koresh had intent commit mass suicid david koresh lawyer confirm thi thi true thi mean that fbi and atf murder that hous even thi not true fbi and atf don hook wait damn long time call waco fire depart perhap want peopl die order reject word fbi and batf neccessari beleiv word man murder children and order suicid murder follow account batf attempt serv warrant koresh ranch and met gunfir deliber attempt murder koresh gun support claim that batf start shoot simpli not stand aft had start shoot heavier grade weaponri standard issu handgun for practic purpos unarm follow had automat weapon you wrong account atf agent adequ arm had and shotgun agent arm automat pistol not atf initi claim retract that agent underarm simpli ludicr seig not allow indefinit quit capabl commit mass suicid and murder children time commando assault like action that achiev that object that riski order magintud harder antebb iranian embassi seig airplan and embassi not design for defens attack ranch apocalyps terrorist easier dislog casualti allow sieg not option risk that koresh proclaim armageddon moment question difficulti keep emmerg team standbi prolong period longer sieg mental prepar koresh and follow for prolong sieg prematur mistak can you get children peopl not want gun control discount entir govern stori thi simpli rationalis not for simpli dismiss govern incompet that requir come solut come govern conspiraci theori govern decid set murder peopl set sort scare alow gun control legisl gun control isn issu sick monkei washington us waco incid reason ban gun will demonstr concern gun control legisl that govern waco and callou peopl right and law thi greatli disturb and disturb you thi conspiraci theori assum that batf deliber agent kill and that fbi etc enjoi sit middl texa shot religi nutter conspiraci theori comfort pretend that waco prove noth incompet govern resolv hostag crisi govt world face compar situat quit manner peacefulli resolv blame not rest fbi rest fact that koresh allow person tip advanc murder atf agent and children conscienc larg number peopl predict end societi preach salvat arm secur fact that peopl pose threat societi place waco not religi nutter polit movement splinter group klu klux klan take schoolhous black area for exampl and hold hundr children hostag solut such situat that can work prevent aris govern world face such situat thi govern carelessli allow high power weaponri becom avali hitler messiah set dictat empir phill hallam baker scott kennedi brewer and patriot david koresh cheap thug interpret bibl barrel gun atf spokesman atf cheap thug interpret constitut barrel gun"
