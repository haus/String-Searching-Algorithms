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
      if ((comparisons = comparisons + 1) and @pattern[patternPos] == @text[textPos + patternPos])
        if patternPos == (@m - 1)
          found = true
          puts "match found at #{textPos}"
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
      puts "search string not found"
    end
  
    puts "#{comparisons} comparisons were used in this search"
    
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
end