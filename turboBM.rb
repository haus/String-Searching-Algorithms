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
  
=begin
    void suffixes(char *x, int m, int *suff) {
       int f, g, i;

       suff[m - 1] = m;
       g = m - 1;
       for (i = m - 2; i >= 0; --i) {
          if (i > g && suff[i + m - 1 - f] < i - g)
             suff[i] = suff[i + m - 1 - f];
          else {
             if (i < g)
                g = i;
             f = i;
             while (g >= 0 && x[g] == x[g + m - 1 - f])
                --g;
             suff[i] = f - g;
          }
       }
    }
=end
  def suffix
    @suff[@m - 1] = @m
    g = @m - 1
    f = 0#2**(32)-1
    
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
  
=begin
  void preBmGs(char *x, int m, int bmGs[]) {
     int i, j, suff[XSIZE];

     suffixes(x, m, suff);

     for (i = 0; i < m; ++i)
        bmGs[i] = m;
     j = 0;
     for (i = m - 1; i >= 0; --i)
        if (suff[i] == i + 1)
           for (; j < m - 1 - i; ++j)
              if (bmGs[j] == m)
                 bmGs[j] = m - 1 - i;
     for (i = 0; i <= m - 2; ++i)
        bmGs[m - 1 - suff[i]] = m - 1 - i;
  }
=end
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
    
=begin
    void preBmBc(char *x, int m, int bmBc[]) {
       int i;

       for (i = 0; i < ASIZE; ++i)
          bmBc[i] = m;
       for (i = 0; i < m - 1; ++i)
          bmBc[x[i]] = m - i - 1;
    }
=end
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

=begin
  void TBM(char *x, int m, char *y, int n) {
    int bcShift, i, j, shift, u, v, turboShift,
        bmGs[XSIZE], bmBc[ASIZE];

    # Preprocessing #
    preBmGs(x, m, bmGs);
    preBmBc(x, m, bmBc);

    # Searching #
    j = u = 0;
    shift = m;
    while (j <= n - m) {
      i = m - 1;
      while (i >= 0 && x[i] == y[i + j]) {
         --i;
         if (u != 0 && i == m - 1 - shift)
            i -= u;
      }
      if (i < 0) {
         OUTPUT(j);
         shift = bmGs[0];
         u = m - shift;
      } else {
         v = m - 1 - i;
         turboShift = u - v;
         bcShift = bmBc[y[i + j]] - m + 1 + i;
         shift = MAX(turboShift, bcShift);
         shift = MAX(shift, bmGs[i]);
         if (shift == bmGs[i])
            u = MIN(m - shift, v);
         else {
           if (turboShift < bcShift)
              shift = MAX(shift, u + 1);
           u = 0;
         }
      }
      j += shift;
     }
  }
=end
  def search
    comparisons = 0
    found = false
    j = 0
    u = 0
    
    shift = @m
    
    while j <= (@n - @m)
      i = @m - 1
      
      while ((comparisons += 1) and i >= 0 and @pattern[i] == @text[i + j])
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
    
    puts "#{comparisons} were used in this search"
    
    return comparisons
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
  puts "Search ##{i+1}: searching text for #{patt}"
  tbm = TurboBoyerMoore.new
  tbm.setup(text, patt)
  total += tbm.search
end

puts "total number of comparisons: " << total.to_s

