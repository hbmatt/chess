class Piece
  attr_accessor :position, :moved
  attr_reader :color

  def initialize(color, position)
    @color = color
    @position = position
    @moved = false
  end

  def find_legal_moves(grid)
    moves = get_moves
    legal_moves = []

    moves.each do |move|
      row = @position[0] + move[0]
      column = @position[1] + move[1]
      if on_board?(row, column) && open_square?(row, column, grid) || on_board?(row, column) && enemy_square?(row, column, grid)
        legal_moves << [row, column]
      else
        next
      end
    end

    legal_moves
  end

  def enemy_square?(row, column, grid)
    return false if grid[row][column] == ' '

    grid[row][column].color != @color
  end

  def open_square?(row, column, grid)
    grid[row][column] == ' '
  end

  def on_board?(row, column)
    row.between?(0, 7) && column.between?(0, 7)
  end
end

class King < Piece
  attr_accessor :castled

  def initialize(color, position)
    super(color, position)
    @castled = false
  end

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
  end

  def find_legal_moves(grid)
    moves = get_moves
    legal_moves = []

    moves.each do |move|
      i = 1

      until i > 7
        row = @position[0] + move[0] * i
        column = @position[1] + move[1] * i

        if on_board?(row, column) && open_square?(row, column, grid)
          legal_moves << [row, column]
          i += 1
        elsif on_board?(row, column) && enemy_square?(row, column, grid)
          legal_moves << [row, column]
          i = 8
        else
          i = 8
        end
      end
    end

    legal_moves
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
  end

  def find_legal_moves(grid)
    moves = get_moves
    legal_moves = []

    moves.each do |move|
      i = 1

      until i > 7
        row = @position[0] + move[0] * i
        column = @position[1] + move[1] * i

        if on_board?(row, column) && open_square?(row, column, grid)
          legal_moves << [row, column]
          i += 1
        elsif on_board?(row, column) && enemy_square?(row, column, grid)
          legal_moves << [row, column]
          i = 8
        else
          i = 8
        end
      end
    end

    legal_moves
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
  end

  def find_legal_moves(grid)
    moves = get_moves
    legal_moves = []

    moves.each do |move|
      i = 1

      until i > 7
        row = @position[0] + move[0] * i
        column = @position[1] + move[1] * i

        if on_board?(row, column) && open_square?(row, column, grid)
          legal_moves << [row, column]
          i += 1
        elsif on_board?(row, column) && enemy_square?(row, column, grid)
          legal_moves << [row, column]
          i = 8
        else
          i = 8
        end
      end
    end

    legal_moves
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
  attr_accessor :move_count

  def initialize(color, position)
    super(color, position)
    @move_count = ''
  end

  def get_moves
    moves = @color == 'white' ? [[2, 0], [1, 0], [1, 1], [1, -1]] : [[-2, 0], [-1, 0], [-1, 1], [-1, -1]]
    @moved == true ? moves.shift : moves
    moves
  end

  def find_legal_moves(grid)
    moves = get_moves
    legal_moves = []

    moves.each do |move|
      row = @position[0] + move[0]
      column = @position[1] + move[1]
      if move[1] == 1 || move[1] == -1
        legal_moves << [row, column] if on_board?(row, column) && enemy_square?(row, column, grid)
      else
        if on_board?(row, column) && open_square?(row, column, grid) || on_board?(row, column) && enemy_square?(row, column, grid)
          legal_moves << [row, column]
        end
      end
    end

    legal_moves
  end

  def to_s
    @color == 'white' ? "\u2659" : "\u265F"
  end
end
