$LOAD_PATH << '.'
require 'file_utility'
require 'bigdecimal'
require 'ostruct'
require_relative 'bayesian_learn/lib/bayesian_learn/bayesian_learn'

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
  product = {}

  # classes.each do |c|
  #   product[c] = 1.0
  #   product[c] *= class_probablity[c]
  # end

  # words.each do |w|
  #   debugger
  #   wp = word_probability[w]
  #   begin
  #     word_probability[w].keys.each do |c|
  #       product[c] = product[c] * wp[c]
  #     end
  #   rescue Exception => e
  #   end
  # end

  classes.each do |c|
    product = 1.0
    product *= class_probablity[c]
    words.each do |word|
      product = product.rationalize * word_probability[c][word]
    end
    products[c.to_sym] = product
  end
  key = products.max_by{|k,v| v}[0]
end

classes, vocabulary, records = FileUtility.read('../data/forumTest.data')

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
File.open('../data/forumTraining.data', "r").each_line do |line|
  count += 1
  data = line.split(" ")
  test_record.real_category = data[0]
  test_record.content = data.drop(0).join(' ')
  oracle = classify(classes, vocabulary, probability, word_probability, test_record.content)
  #puts "oracle: #{oracle}, real: #{test_record.real_category}"
  if oracle == test_record.real_category.to_sym
    accurate_prediction_count += 1 
  else
    false_prediction_count += 1
  end
end

puts "Total number of records: #{count}"
puts "Number of correct predictions: #{accurate_prediction_count}"
puts "Number of false predictions: #{false_prediction_count}"

# puts classify(classes, vocabulary, probability, word_probability, "alt atheism faq atheist resources archive name atheism resources alt atheism archive name resources last modified december version atheist resources addresses of atheist organizations usa freedom from religion foundation darwin fish bumper stickers and assorted other atheist paraphernalia are available from the freedom from religion foundation in the us write to ffrf p o box madison wi telephone evolution designs evolution designs sell the darwin fish it s a fish symbol like the ones christians stick on their cars but with feet and the word darwin written inside the deluxe moulded d plastic fish is postpaid in the us write to evolution designs laurel canyon north hollywood ca people in the san francisco bay area can get darwin fish from lynn gold try mailing figmo netcom com for net people who go to lynn directly the price is per fish american atheist press aap publish various atheist books critiques of the bible lists of biblical contradictions and so on one such book is the bible handbook by w p ball and g w foote american atheist press pp isbn nd edition bible contradictions absurdities atrocities immoralities contains ball foote the bible contradicts itself aap based on the king james version of the bible write to american atheist press p o box austin tx or cameron road austin tx telephone fax prometheus books sell books including haught s holy horrors see below write to east amherst street buffalo new york telephone an alternate address which may be newer or older is prometheus books glenn drive buffalo ny african americans for humanism an organization promoting black secular humanism and uncovering the history of black freethought they publish a quarterly newsletter aah examiner write to norm r allen jr african americans for humanism p o box buffalo ny united kingdom rationalist press association national secular society islington high street holloway road london n ew london n nl british humanist association south place ethical society lamb s conduit passage conway hall london wc r rh red lion square london wc r rl fax the national secular society publish the freethinker a monthly magazine founded in germany ibka e v internationaler bund der konfessionslosen und atheisten postfach d berlin germany ibka publish a journal miz materialien und informationen zur zeit politisches journal der konfessionslosesn und atheisten hrsg ibka e v miz vertrieb postfach d berlin germany for atheist books write to ibdk internationaler b ucherdienst der konfessionslosen postfach d hannover germany telephone books fiction thomas m disch the santa claus compromise short story the ultimate proof that santa exists all characters and events are fictitious any similarity to living or dead gods uh well walter m miller jr a canticle for leibowitz one gem in this post atomic doomsday novel is the monks who spent their lives copying blueprints from saint leibowitz filling the sheets of paper with ink and leaving white lines and letters edgar pangborn davy post atomic doomsday novel set in clerical states the church for example forbids that anyone produce describe or use any substance containing atoms philip k dick philip k dick dick wrote many philosophical and thought provoking short stories and novels his stories are bizarre at times but very approachable he wrote mainly sf but he wrote about people truth and religion rather than technology although he often believed that he had met some sort of god he remained sceptical amongst his novels the following are of some relevance galactic pot healer a fallible alien deity summons a group of earth craftsmen and women to a remote planet to raise a giant cathedral from beneath the oceans when the deity begins to demand faith from the earthers pot healer joe fernwright is unable to comply a polished ironic and amusing novel a maze of death noteworthy for its description of a technology based religion valis the schizophrenic hero searches for the hidden mysteries of gnostic christianity after reality is fired into his brain by a pink laser beam of unknown but possibly divine origin he is accompanied by his dogmatic and dismissively atheist friend and assorted other odd characters the divine invasion god invades earth by making a young woman pregnant as she returns from another star system unfortunately she is terminally ill and must be assisted by a dead man whose brain is wired to hour easy listening music margaret atwood the handmaid s tale a story based on the premise that the us congress is mysteriously assassinated and fundamentalists quickly take charge of the nation to set it right again the book is the diary of a woman s life as she tries to live under the new christian theocracy women s right to own property is revoked and their bank accounts are closed sinful luxuries are outlawed and the radio is only used for readings from the bible crimes are punished retroactively doctors who performed legal abortions in the old world are hunted down and hanged atwood s writing style is difficult to get used to at first but the tale grows more and more chilling as it goes on various authors the bible this somewhat dull and rambling work has often been criticized however it is probably worth reading if only so that you ll know what all the fuss is about it exists in many different versions so make sure you get the one true version books non fiction peter de rosa vicars of christ bantam press although de rosa seems to be christian or even catholic this is a very enlighting history of papal immoralities adulteries fallacies etc german translation gottes erste diener die dunkle seite des papsttums droemer knaur michael martin atheism a philosophical justification temple university press philadelphia usa a detailed and scholarly justification of atheism contains an outstanding appendix defining terminology and usage in this necessarily tendentious area argues both for negative atheism i e the non belief in the existence of god s and also for positive atheism the belief in the non existence of god s includes great refutations of the most challenging arguments for god particular attention is paid to refuting contempory theists such as platinga and swinburne pages isbn hardcover paperback also available the case against christianity temple university press a comprehensive critique of christianity in which he considers the best contemporary defences of christianity and ultimately demonstrates that they are unsupportable and or incoherent pages isbn james turner without god without creed the johns hopkins university press baltimore md usa subtitled the origins of unbelief in america examines the way in which unbelief whether agnostic or atheistic became a mainstream alternative world view focusses on the period and while considering france and britain the emphasis is on american and particularly new england developments neither a religious history of secularization or atheism without god without creed is rather the intellectual history of the fate of a single idea the belief that god exists pages isbn hardcover x paper george seldes editor the great thoughts ballantine books new york usa a dictionary of quotations of a different kind concentrating on statements and writings which explicitly or implicitly present the person s philosophy and world view includes obscure and often suppressed opinions from many people for some popular observations traces the way in which various people expressed and twisted the idea over the centuries quite a number of the quotations are derived from cardiff s what great men think of religion and noyes views of religion pages isbn paper x richard swinburne the existence of god revised edition clarendon paperbacks oxford this book is the second volume in a trilogy that began with the coherence of theism and was concluded with faith and reason in this work swinburne attempts to construct a series of inductive arguments for the existence of god his arguments which are somewhat tendentious and rely upon the imputation of late th century western christian values and aesthetics to a god which is supposedly as simple as can be conceived were decisively rejected in mackie s the miracle of theism in the revised edition of the existence of god swinburne includes an appendix in which he makes a somewhat incoherent attempt to rebut mackie j l mackie the miracle of theism oxford this posthumous volume contains a comprehensive review of the principal arguments for and against the existence of god it ranges from the classical philosophical positions of descartes anselm berkeley hume et al through the moral arguments of newman kant and sidgwick to the recent restatements of the classical theses by plantinga and swinburne it also addresses those positions which push the concept of god beyond the realm of the rational such as those of kierkegaard kung and philips as well as replacements for god such as lelie s axiarchism the book is a delight to read less formalistic and better written than martin s works and refreshingly direct when compared with the hand waving of swinburne james a haught holy horrors an illustrated history of religious murder and madness prometheus books looks at religious persecution from ancient times to the present day and not only by christians library of congress catalog card number norm r allen jr african american humanism an anthology see the listing for african americans for humanism above gordon stein an anthology of atheism and rationalism prometheus books an anthology covering a wide range of subjects including the devil evil and morality and the history of freethought comprehensive bibliography edmund d cohen the mind of the bible believer prometheus books a study of why people become christian fundamentalists and what effect it has on them net resources there s a small mail based archive server at mantis co uk which carries archives of old alt atheism moderated articles and assorted other files for more information send mail to archive server mantis co uk saying help send atheism index and it will mail back a reply mathew")
# puts classify(classes, vocabulary, probability, word_probability, "re real time graphics in article c va r kk taurus cs nps navy mil stockel oahu oc nps navy mil jim stockel writes hi i will be writing a data acquisition program to collect data from a variety of sources including rs and external a d s and i would like to be able to display the data in near realtime i ve done this type of thing on pc s and other machines but i am unaware of any graphics package that could help me with this on a unix machine does anyone have any ideas on commercial or free packages that might suit my needs i would really appreciate any input i m sure this has been done many times before for a commerical package try wave from precision visuals for a free package try khoros from university of new mexico ftp from ptrg eece unm edu login in anonyomus or ftp with a valid email address as the password cd pub khoros release that will get you to the right place david")
#puts classify(classes, vocabulary, probability, word_probability, 'atheism e gorgi')
#puts classify(classes, vocabulary, probability, word_probability,  "re can i change licensed to data in windows write over the licensed to but you can t change the name underneth it i think if you wish to change this you would have to be a pirate and we re not going to promote that here not so my computer was supplied with my name in an interesting mix of upper and lower case and my workplace mis typed i m getting fed up with being cmyearsley at keel unversity it took me phone calls to the supplier to get the computer working at all i really can t face tackling them again chris")