class KnuthMorrisPratt
  def initialize
    @text = String.new
    @pattern = String.new
    @pi = Array.new
    @m
    @n
  end
  
  def setup(sourceText, sourcePattern)
    line = 0
    @text = sourceText
    @pattern = sourcePattern
    @m = @pattern.length
    @n = @text.length
    prefix
  end

  def search
    textPos = 0
    patternPos = 0
    comparisons = 0
    found = false
  
    while (textPos + patternPos) < @n
      #puts @pattern[patternPos].chr << " vs " << @text[textPos + patternPos].chr
    
      if ((comparisons = comparisons + 1) and @pattern[patternPos] == @text[textPos + patternPos])
        if patternPos == (@m - 1)
          found = true
          puts "word found at " << textPos.to_s
          patternPos = 0
          textPos = textPos + @m
        end
        patternPos = patternPos + 1
      else
        textPos = textPos + patternPos - @pi[patternPos]
        if @pi[patternPos] > -1
          patternPos = @pi[patternPos]
        else
          patternPos = 0
        end
      end
    end
    
    if (!found)
      puts "word not found"
    end
  
    puts "number of comparisons: " << comparisons.to_s
    
    return comparisons
  end

  def prefix
    # Initialization of @pi
    @pi = [-1, 0]
    pos = 2
    cnd = 0

    while (pos < @m)
      if @pattern[pos - 1] == @pattern[cnd]
        cnd = cnd + 1
        @pi[pos] = cnd
        pos = pos + 1
      elsif cnd > 0
        cnd = @pi[cnd]
      else
        @pi[pos] = 0
        pos = pos + 1
      end
    end
  end
  
  def printPi
    for i in (0..@pi.length - 1)
      puts i.to_s << " in pi is " << @pi[i].to_s
    end
  end
  
end

text = String.new
pattern = Array.new
line = 0

# Check that the files exist
if (ARGV[0] and ARGV[1] and File.file?(ARGV[0]) and File.file?(ARGV[1]))
  # First load the text into a string
  File.open(ARGV[0], "r").each_line do |curLine|
    if (curLine and curLine.chomp)
      text << curLine.chomp
    end
  end

  # Now load the pattern
  File.open(ARGV[1], "r").each_line do |curLine|
    if (curLine and curLine.chomp and curLine.chomp.length > 0)
      pattern[line] = curLine.chomp
      line += 1
    end
  end
else
  puts "First argument should be the data file, second argument should be the search pattern."
end

total = 0

pattern.each_with_index do |patt, i|
  kmp = KnuthMorrisPratt.new
  kmp.setup(text, patt)
  #kmp.printPi
  total += kmp.search
end

puts "total number of comparisons: " << total.to_s