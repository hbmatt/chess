class Piece
  attr_accessor :position, :moved
  attr_reader :color

  def initialize(color, position, moved = false)
    @color = color
    @position = position
    @moved = moved
    @moves = get_moves
  end

  def find_legal_moves(grid)
    @moves = get_moves
    legal_moves = []

    @moves.each do |move|
      row = @position[0] + move[0]
      column = @position[1] + move [1]
      legal_moves << [row, column] if on_board?(row, column) && open_square?(row, column, grid)
    end

    legal_moves
  end

  def on_board?(row, column)
    row >= 0 && column >= 0 && row <= 7 && column <= 7 ? true : false
  end

  def open_square?(row, column, grid)
    return true if grid[row][column] == ' '
    grid[row][column].color == @color false : true
  end
end

class King < Piece
  def get_moves
    moves = [
      [0, 1], [1, 1], [1, 0], [1, -1],
      [0, -1], [-1, -1], [-1, 0], [-1, 1]
    ]
  end

  def to_s
    @color == 'white' ? "\u2654" : "\u265A"
  end
end

class Queen < Piece
  def get_moves
    moves = [
      [1, 0], [-1, 0], [0, 1], [0, -1],
      [1, 1], [-1, 1], [-1, -1], [1, -1]
    ]

    full_moves = []

    moves.each do |move|
      i = 1
      until i > 7
        row = move[0] * i
        column = move[1] * i
        full_moves << [row,column]
        i += 1
      end
      full_moves
    end

    full_moves
  end

  def to_s
    @color == 'white' ? "\u2655" : "\u265B"
  end
end

class Rook < Piece
  def get_moves
    moves = [
      [1, 0], [-1, 0], [0, 1], [0, -1]
    ]

    full_moves = []

    moves.each do |move|
      i = 1
      until i > 7
        row = move[0] * i
        column = move[1] * i
        full_moves << [row,column]
        i += 1
      end
      full_moves
    end

    full_moves
  end

  def to_s
    @color == 'white' ? "\u2656" : "\u265C"
  end
end

class Bishop < Piece
  def get_moves
    moves = [
      [1, 1], [-1, 1], [-1, -1], [1, -1]
    ]

    full_moves = []

    moves.each do |move|
      i = 1
      until i > 7
        row = move[0] * i
        column = move[1] * i
        full_moves << [row,column]
        i += 1
      end
      full_moves
    end

    full_moves
  end

  def to_s
    @color == 'white' ? "\u2657" : "\u265D"
  end
end

class Knight < Piece
  def get_moves
    moves = [
      [1, 2], [-1, 2], [-1, -2], [1, -2],
      [2, 1], [-2, 1], [-2, -1], [2, -1]
    ]
  end

  def to_s
    @color == 'white' ? "\u2658" : "\u265E"
  end
end

class Pawn < Piece
  def get_moves
    moves = @color == 'white' ? [[2,0], [1,0]] : [[-2,0], [-1,0]]
    @moved == true ? moves.shift : moves
    moves
  end

  def to_s
    @color == 'white' ? "\u2659" : "\u265F"
  end
end
