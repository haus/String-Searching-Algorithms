class KnuthMorrisPratt
  def initialize
    @text = String.new
    @pattern = Array.new
    @sourceText
    @sourcePattern
    @pi = Array.new
    @debug = true
    @m = Array.new
    @n
  end
  
  def setup(sourceText, sourcePattern)
    line = 0
    
    # Check that the files exist
    if (sourceText and sourcePattern and File.file?(sourceText) and File.file?(sourcePattern))
      # First load the text into a string
      File.open(sourceText, "r").each_line do |curLine|
        if (curLine and curLine.chomp)
          @text << curLine.chomp
        end
      end
    
      # Now load the pattern
      File.open(sourcePattern, "r").each_line do |curLine|
        if (curLine and curLine.chomp and curLine.chomp.length > 0)
          @pattern[line] = curLine.chomp
          @m[line] = @pattern[line].length
          line = line + 1
        end
      end
  
      @n = @text.length
      prefix
    else
      puts "First argument should be the data file, second argument should be the search pattern."
    end
  end

  def search
    totalComps = 0
    
    for i in (0..@pattern.length - 1)
      puts "seaching for pattern ##{i+1} (#{@pattern[i]})"

      textPos = 0
      patternPos = 0
      comparisons = 0
      found = false
    
      while (textPos + patternPos) < @n
        #puts @pattern[patternPos].chr << " vs " << @text[textPos + patternPos].chr
      
        if ((comparisons = comparisons + 1) and @pattern[i][patternPos] == @text[textPos + patternPos])
        
          if patternPos == (@m[i] - 1)
            found = true
            puts "word found at " << textPos.to_s
            patternPos = 0
            textPos = textPos + @m[i]
          end
        
          patternPos = patternPos + 1
      
        else
      
          textPos = textPos + patternPos - @pi[i][patternPos]
      
          if @pi[i][patternPos] > -1
            patternPos = @pi[i][patternPos]
          else
            patternPos = 0
          end
      
        end
    
      end
    
      if (!found)
        puts "word not found"
      end
    
      puts "number of comparisons: " << comparisons.to_s
      totalComps = totalComps + comparisons
    end
    
    puts "total number of comparisons: " << totalComps.to_s
    
  end

  def prefix
    for i in (0..@pattern.length - 1)
      # Initialization of @pi
      @pi[i] = [-1, 0]
      pos = 2
      cnd = 0
  
      while (pos < @m[i])
        if @pattern[i][pos - 1] == @pattern[i][cnd]
          cnd = cnd + 1
          @pi[i][pos] = cnd
          pos = pos + 1
        elsif cnd > 0
          cnd = @pi[i][cnd]
        else
          @pi[i][pos] = 0
          pos = pos + 1
        end
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