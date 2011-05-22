require 'set'

class TurboBoyerMoore
  def initialize
    @text = String.new
    @pattern = Array.new
    @sourceText
    @sourcePattern
    @good = Array.new
    @bad = Array.new
    @suff = Array.new
    @alpha = Array.new
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
        if (curLine and curLine.chomp)
          @pattern[line] = curLine.chomp
          @m[line] = @pattern[line].length
          line = line + 1
        end
      end
  
      @n = @text.length
      puts @pattern.to_set.length.chr
      #gPrefix
      bPrefix
    else
      puts "First argument should be the data file, second argument should be the search pattern."
    end
  end
  
  def search
    
    
  end
  
  def getSuffix
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
    for i in (0..@pattern.length - 1)
      @suff[i] = Array.new
      
      @suff[i][@m[i].length-1] = @m[i].length
      
      g = @m[i].length - 1
      
      for j in ((@m[i].length - 2)..0)
        if (j > g and @suff[i][j + @m[i].length - 1 - f] < (j - g))
          @suff[i][j] = @suff[i][j + @m[i].length -1 - f]
        else
          if (j < g)
            g = j
          end
          
          f = j
          
          while (g >= 0 and @pattern[i][g] == @pattern[i][g + @m[i].length - 1 - f])
            g -= 1
          end
          
          @suff[i][j] = f - g
        end
      end
    end
  end
  
  def gPrefix
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
    for i in (0..@pattern.length - 1)
      @good[i] = Array.new
      
      
      
    end
  end
  
  def bPrefix
=begin
    void preBmBc(char *x, int m, int bmBc[]) {
       int i;

       for (i = 0; i < ASIZE; ++i)
          bmBc[i] = m;
       for (i = 0; i < m - 1; ++i)
          bmBc[x[i]] = m - i - 1;
    }
=end

    for i in (0..@pattern.length - 1)
      @bad[i] = Hash.new
      @alpha[i] = Set.new
      
      for j in (0..@pattern[i].length - 1)
        @alpha[i].add(@pattern[i][j])
      end
      
      for j in (0..@alpha[i].size)
        @bad[i][j] = @m[i]
      end
      
      for j in (0..(@m[i] - 1))
        @bad[i][@pattern[j]] = @m[i] - j - 1
      end
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

tbm = TurboBoyerMoore.new
tbm.setup(ARGV[0], ARGV[1])
#tbm.printPi
#tbm.search