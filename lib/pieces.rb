class Piece
  attr_accessor :position, :legal_moves

  def initialize(color, position = nil)
    @color = color
    @position = position
    @legal_moves = find_legal_moves
  end

  def find_legal_moves
    legal_moves = []

    @moves.each do |move|
      x = @position[0] + move[0]
      y = @position[1] + move [1]
      legal_moves << [x, y] if x >= 0 && y >= 0 && x <= 7 && y <= 7
    end

    legal_moves
  end
end

class King < Piece
  def initialize
    @moves = [
      [0, 1], [1, 1], [1, 0], [1, -1],
      [0, -1], [-1, -1], [-1, 0], [-1, 1]
    ]
  end

  def show_symbol
    @color == 'white' ? "\u2654" : "\u265A"
  end
end

class Queen < Piece
  def initialize
    @moves = [
      [1, 0], [-1, 0], [0, 1], [0, -1],
      [1, 1], [-1, 1], [-1, -1], [1, -1]
    ]
  end

  def show_symbol
    @color == 'white' ? "\u2655" : "\u265B"
  end
end

class Rook < Piece
  def initialize
    @moves = [
      [1, 0], [-1, 0], [0, 1], [0, -1]
    ]
  end

  def show_symbol
    @color == 'white' ? "\u2656" : "\u265C"
  end
end

class Bishop < Piece
  def initialize
    @moves = [
      [1, 1], [-1, 1], [-1, -1], [1, -1]
    ]
  end

  def show_symbol
    @color == 'white' ? "\u2657" : "\u265D"
  end
end

class Knight < Piece
  def initialize
    @moves = [
      [1, 2], [-1, 2], [-1, -2], [1, -2],
      [2, 1], [-2, 1], [-2, -1], [2, -1]
    ]
  end

  def show_symbol
    @color == 'white' ? "\u2658" : "\u265E"
  end
end

class Pawn < Piece
  attr_accessor :moved

  def initialize(moved = false)
    @moves = if @color == 'white'
               [[0, 2], [0, 1]]
             else
               [[0, -2], [0, -1]]
             end
    @moved = moved
  end

  def find_legal_moves
    @moves.shift if @moved == true
    super
  end

  def show_symbol
    @color == 'white' ? "\u2659" : "\u265F"
  end
end

