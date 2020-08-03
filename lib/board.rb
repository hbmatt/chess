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
        row << i
        i += 1
      end
      grid << row
    end

    grid
  end

  def display_board
    display = '+-------'
    6.times do
      display += '--------'
    end
    display += "--------+\n"

    7.times do
      3.times do
        8.times do
          display += '|       '
        end
        display += "|\n"
      end

      8.times do
        display += '+-------'
      end
      display += "+\n"
    end

    3.times do
      8.times do
        display += '|       '
      end
      display += "|\n"
    end

    display += '+-------'
    6.times do
      display += '--------'
    end
    display += "--------+\n"
  
    puts "\n\n" + display
  end
end