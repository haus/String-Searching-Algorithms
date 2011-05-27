require 'turboBM'
require 'kmp'

basedir = "./Test Files"

Dir.new(basedir).entries.each do |file|
  textFile = String.new
  patternFile = String.new
  
  if file =~ /s[0-9]\.txt/
    textFile = "#{basedir}/#{file}"
    index = file[1].chr
    patternFile = "#{basedir}/p#{index}.txt"
    puts "Running test set ##{index}\n"

    text = String.new
    pattern = Array.new
    line = 0

    # First load the text into a string
    File.open(textFile, "r").each_line do |curLine|
      if (curLine and curLine.chomp)
        text << curLine.chomp
      end
    end

    # Now load the pattern
    File.open(patternFile, "r").each_line do |curLine|
      if (curLine and curLine.chomp and curLine.chomp.length > 0)
        pattern[line] = curLine.chomp
        line += 1
      end
    end

    totalKMP = 0
    totalTBM = 0

    pattern.each_with_index do |patt, i|
      puts "Search ##{i+1}: searching text for #{patt}"
      kmp = KnuthMorrisPratt.new
      kmp.setup(text, patt)
      totalKMP += kmp.search
      puts "\n"
    end

    puts "\nKnuthMorrisPratt used #{totalKMP} total comparisons (#{totalKMP/pattern.size} average)\n\n"
  
    pattern.each_with_index do |patt, i|
      puts "Search ##{i+1}: searching text for #{patt}"
      tbm = TurboBoyerMoore.new
      tbm.setup(text, patt)
      totalTBM += tbm.search
      puts "\n"
    end

    puts "Turbo Boyer-Moore used #{totalTBM} total comparisons (#{totalTBM/pattern.size} average)"
    
    puts "\n\n\n"
  end

end