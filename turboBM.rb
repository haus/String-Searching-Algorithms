class TurboBoyerMoore
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
        if (curLine and curLine.chomp)
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
  
#  void TBM(char *x, int m, char *y, int n) {
/     int bcShift, i, j, shift, u, v, turboShift,
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
        }
        else {
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
/  
#  void preBmBc(char *x, int m, int bmBc[]) {
/     int i;

     for (i = 0; i < ASIZE; ++i)
        bmBc[i] = m;
     for (i = 0; i < m - 1; ++i)
        bmBc[x[i]] = m - i - 1;
  }
/
#  void preBmGs(char *x, int m, int bmGs[]) {
/     int i, j, suff[XSIZE];

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
/
  

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
tbm˝.search