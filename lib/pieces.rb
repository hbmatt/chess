class Piece
  attr_accessor :position, :legal_moves, :moved
  attr_reader :color

  def initialize(color, position = nil, moved = false)
    @color = color
    @position = position
    @moved = moved
    @moves = get_moves
    @legal_moves = []
  end

  def find_legal_moves
    @moves = get_moves
    @legal_moves = []

    @moves.each do |move|
      x = @position[0] + move[0]
      y = @position[1] + move [1]
      @legal_moves << [x, y] if x >= 0 && y >= 0 && x <= 7 && y <= 7
    end

    @legal_moves
  end
end

class King < Piece
  def get_moves
    moves = [
      [0, 1], [1, 1], [1, 0], [1, -1],
      [0, -1], [-1, -1], [-1, 0], [-1, 1]
    ]
  end

  def show_symbol
    @color == 'white' ? "\u2654" : "\u265A"
  end
end

class Queen < Piece
  def get_moves
    moves = [
      [1, 0], [-1, 0], [0, 1], [0, -1],
      [1, 1], [-1, 1], [-1, -1], [1, -1]
    ]
  end

  def show_symbol
    @color == 'white' ? "\u2655" : "\u265B"
  end
end

class Rook < Piece
  def get_moves
    moves = [
      [1, 0], [-1, 0], [0, 1], [0, -1]
    ]
  end

  def show_symbol
    @color == 'white' ? "\u2656" : "\u265C"
  end
end

class Bishop < Piece
  def get_moves
    moves = [
      [1, 1], [-1, 1], [-1, -1], [1, -1]
    ]
  end

  def show_symbol
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

  def show_symbol
    @color == 'white' ? "\u2658" : "\u265E"
  end
end

class Pawn < Piece
  def get_moves
    moves = @color == 'white' ? [[0, 2], [0, 1]] : [[0, -2], [0, -1]]
    @moved == true ? moves.shift : moves
    moves
  end

  def show_symbol
    @color == 'white' ? "\u2659" : "\u265F"
  end
end
