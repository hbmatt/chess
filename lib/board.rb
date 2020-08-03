class Board
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
end