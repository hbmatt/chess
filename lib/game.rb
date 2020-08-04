class Game
  def initialize
    @player1 = Player.new('Player 1','white')
    @player2 = Player.new('Player 2','black')
    @board = Board.new
  end

  def place_white_pieces(grid)
    i = 0
    until i > 7
      grid[1][i] = Pawn.new('white',[1,i]).show_symbol
      i += 1
    end

    grid[0][0] = Rook.new('white',[0,0])
    grid[0][7] = Rook.new('white',[0,7])

    grid[0][1] = Knight.new('white',[0,1])
    grid[0][6] = Knight.new('white',[0,6])

    grid[0][2] = Bishop.new('white',[0,2])
    grid[0][5] = Bishop.new('white',[0,5])

    grid[0][3] = Queen.new('white',[0,3])
    grid[0][4] = King.new('white',[0,4])
  end

  def place_black_pieces(grid)
    i = 0
    until i > 7
      grid[6][i] = Pawn.new('black',[1,i])
      i += 1
    end

    grid[7][0] = Rook.new('black',[7,0])
    grid[7][7] = Rook.new('black',[7,7])

    grid[7][1] = Knight.new('black',[7,1])
    grid[7][6] = Knight.new('black',[7,6])

    grid[7][2] = Bishop.new('black',[7,2])
    grid[7][5] = Bishop.new('black',[7,5])

    grid[7][3] = Queen.new('black',[7,3])
    grid[7][4] = King.new('black',[7,4])
  end

  def make_move(player)
    legal_moves = []

    while legal_moves == []
      piece = player.choose_piece until piece_legal?(player, piece)
      piece = find_piece(piece)
      legal_moves = piece.find_legal_moves(@board.grid)
    end

    move = player.move_piece until move_legal?(move, legal_moves)

    move_piece(piece, move, @board.grid)
  end

  def move_piece(piece, move, grid)
    piece.moved = true if piece.moved == false

    old_position = piece.position
    row = old_position[0]
    column = old_position[1]

    grid[row][column] = ' '
    piece.position = move
  end

  def find_piece(piece)
    row = piece[0]
    column = piece[1]
    piece = @board.grid[row][column]
  end

  def piece_legal?(player, piece)
    piece = find_piece(piece)
    piece.color == player.color ? true : false
  end

  def move_legal?(move, legal_moves)
    legal_moves.include?(move) ? true : false
  end
end