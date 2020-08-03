class Piece
  def initialize(color)
    @color = color
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
  attr_accessor :position, :legal_moves

  def initialize(position = nil)
    @position = position
    @moves = [
      [0, 1], [1, 1], [1, 0], [1, -1],
      [0, -1], [-1, -1], [-1, 0], [-1, 1]
    ]
    @legal_moves = find_legal_moves
  end
end

class Knight < Piece
  attr_accessor :position, :legal_moves

  def initialize(position = nil)
    @position = position
    @moves = [
      [1, 2], [-1, 2], [-1, -2], [1, -2],
      [2, 1], [-2, 1], [-2, -1], [2, -1]
    ]
    @legal_moves = find_legal_moves
  end
end

class Pawn < Piece
  attr_accessor :position, :legal_moves

  def initialize(position = nil, moved = false)
    @position = position
    @moves = if @color == 'white'
               [[0, 2], [0, 1]]
             else
               [[0, -2], [0, -1]]
             end
    @moved = moved
    @legal_moves = find_legal_moves
  end

  def find_legal_moves
    @moves.shift if @moved == true
    super
  end
end

class Rook < Piece
  attr_accessor :position, :legal_moves

  def initialize(position = nil)
    @position = position
    @moves = [
      [1, 0], [-1, 0], [0, 1], [0, -1]
    ]
    @legal_moves = find_legal_moves
  end
end

class Bishop < Piece
  attr_accessor :position, :legal_moves

  def initialize(position = nil)
    @position = position
    @moves = [
      [1, 1], [-1, 1], [-1, -1], [1, -1]
    ]
    @legal_moves = find_legal_moves
  end
end
