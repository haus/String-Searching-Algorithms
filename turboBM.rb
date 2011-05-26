require 'set'

class TurboBoyerMoore
  def initialize
    @text = String.new
    @pattern = Array.new
    @suff = Array.new
    @debug = false
    @m
    @n
  end
  
  def setup(sourceText, sourcePattern)
    @text = sourceText
    @pattern = sourcePattern
  
    @n = @text.length
    @m = @pattern.length
    
    suffix
    gPrefix
    bPrefix
    if @debug
      @suff.each_with_index do |suffix, i|
        puts "Suffix #{i} is #{suffix}"
      end
      @good.each_with_index do |gd, i|
        puts "Good #{i} is #{gd}"
      end
      @bad.each do |key, val|
        puts "Bad #{key} is #{val}"
      end
    end
  end
  
  def suffix
    @suff[@m - 1] = @m
    g = @m - 1
    f = 0
    
    (@m - 2).downto(0) do |i|
      if (i > g and @suff[i + @m - 1 - f] < (i - g))
        @suff[i] = @suff[i + @m - 1 - f]
      else
        if (i < g)
          g = i
        end
        
        f = i
        
        while (g >= 0 and @pattern[g] == @pattern[g + @m - 1 - f])
          g -= 1
        end
        
        @suff[i] = f - g
      end
    end
  end
  
  def gPrefix
    @good = Array.new
    
    0.upto(@m - 1) do |i|
      @good[i] = @m
    end
    
    k = 0
    
    (@m - 1).downto(0) do |i|
      if (@suff[i] == (i + 1))
        k.upto(@m - 2 - i) do |j|
          if @good[j] == @m
            @good[j] = @m - 1 - i
          end
        end
      end
    end
      
    0.upto(@m - 2) do |i|
      @good[@m - 1 - @suff[i]] = @m - 1 - i
    end
  end
    
  def bPrefix
    @bad = Hash.new
    @alpha = Set.new
    
    0.upto(@n - 1) do |i|
      @alpha.add(@text[i].chr)
    end
    
    if @debug
      @alpha.each_with_index do |a, i|
        puts "Element #{i} is #{a}"
      end
    end
    
    @alpha.each_with_index do |a, i|
      @bad[a] = @m
    end
    
    0.upto(@m - 1) do |i|
      @bad[@pattern[i].chr] = @m - i - 1
    end
  end

  def search
    comparisons = 0
    found = false
    j = 0
    u = 0
    
    shift = @m
    
    while j <= (@n - @m)
      i = @m - 1
      
      while (i >= 0 and (comparisons += 1) and @pattern[i] == @text[i + j])
        i -= 1
        
        if (u != 0 and i == (@m - 1 - shift))
          i -= u
        end
      end
      
      if (i < 0)
        found = true
        puts "match found at #{j}"
        shift = @good[0]
        u = @m - shift
      else
        v = @m - 1 - i
        turboShift = u - v
        bcShift = @bad[@text[i + j].chr] - @m + 1 + i
        shift = [turboShift, bcShift, @good[i]].max
        
        if (shift == @good[i])
          u = [@m - shift, v].min
        else
          if (turboShift < bcShift)
            shift = [shift, u + 1].max
          end
          u = 0
        end
      end
      
      j += shift
      
    end
    
    if !found
      puts "search string not found"
    end
    
    puts "#{comparisons} comparisons were used in this search"
    
    return comparisons
  end
end