class KnuthMorrisPratt
  def initialize
    @text = String.new
    @pattern = String.new
    @sourceText
    @sourcePattern
    @pi = []
    @debug = true
    @m
  end
  
  def setup(sourceText, sourcePattern)
    # Check that the files exist
    if (sourceText and sourcePattern and File.file?(sourceText) and File.file?(sourcePattern))
      # First load the text into a string
      data = File.open(sourceText, "r") do |file|
        while curLine = file.gets
          @text << curLine
        end
      end
    
      # Now load the pattern
      data = File.open(sourcePattern, "r") do |file|
        while curLine = file.gets
          @pattern << curLine
        end
      end
  
      @n = @text.length
      @m = @pattern.length
      prefix
    else
      puts "First argument should be the data file, second argument should be the search pattern."
    end
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
  
  end

  def prefix
    # Initialization of @pi
    @pi = [-1, 0]
    pos = 2
    cnd = 0
  
    while (pos < @m) #and @pattern[k + 1] != @pattern[q])
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

kmp = KnuthMorrisPratt.new
kmp.setup(ARGV[0], ARGV[1])
#kmp.printPi
kmp.search