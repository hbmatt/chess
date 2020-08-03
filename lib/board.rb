class Board
  attr_accessor :grid

  def initialize
    @rows = 8
    @columns = 8
    @grid = make_board
  end

  def make_board
    grid = []

    @rows.times do
      i = 0
      row = []
      until i > @columns - 1
        row << ' '
        i += 1
      end
      grid << row
    end

    grid
  end

  def display_board
    display = separator

    n = 8

    @grid.reverse.each do |row|
      display += cell_padding

      display += " #{n} |"
      i = 0
      while i < 8
        display += "   #{row[i]}   |"
        i += 1
      end
      display += "\n"

      display += cell_padding
      display += separator
      n -= 1
    end

    display += '       A       B       C       D       E       F       G       H    '

    puts "\n\n" + display
  end

  def separator
    display = '   '
    8.times do
      display += '+-------'
    end
    display += "+\n"
  end

  def cell_padding
    display = ''
    8.times do
      display += '   |    '
    end
    display += "   |\n"
  end
end
