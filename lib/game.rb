require './lib/board.rb'
require './lib/game.rb'
require './lib/player.rb'
require './lib/pieces.rb'

class Game
  attr_accessor :board
  
  def initialize
    @player1 = Player.new('Player 1', 'white')
    @player2 = Player.new('Player 2', 'black')
    @board = Board.new
    @move_counter = 1
  end

  def start_game
    get_players
    clear_screen

    place_white_pieces(@board.grid)
    place_black_pieces(@board.grid)

    until game_over?
      @board.display_board
      player = choose_player_turn
      make_move(player)
      clear_screen

      @move_counter += 1
    end

    end_game
  end

  def game_over?
    # in_check? and no legal moves out of check
    # checkmate? true. opposing player wins
  end

  def clear_screen
    system('clear') || system('cls')
  end

  def get_players
    puts "\nPlayer 1, enter your name:"
    @player1.name = gets.chomp
    puts "\nPlayer 2, enter your name:"
    @player2.name = gets.chomp
  end

  def choose_player_turn
    if @move_counter.odd?
      puts "\nPlayer 1's turn"
      @player1
    elsif @move_counter.even?
      puts "\nPlayer 2's turn"
      @player2
    end
  end

  def place_white_pieces(grid)
    i = 0
    until i > 7
      grid[1][i] = Pawn.new('white', [1, i])
      i += 1
    end

    grid[0][0] = Rook.new('white', [0, 0])
    grid[0][7] = Rook.new('white', [0, 7])

    grid[0][1] = Knight.new('white', [0, 1])
    grid[0][6] = Knight.new('white', [0, 6])

    grid[0][2] = Bishop.new('white', [0, 2])
    grid[0][5] = Bishop.new('white', [0, 5])

    grid[0][3] = Queen.new('white', [0, 3])
    grid[0][4] = King.new('white', [0, 4])
  end

  def place_black_pieces(grid)
    i = 0
    until i > 7
      grid[6][i] = Pawn.new('black', [6, i])
      i += 1
    end

    grid[7][0] = Rook.new('black', [7, 0])
    grid[7][7] = Rook.new('black', [7, 7])

    grid[7][1] = Knight.new('black', [7, 1])
    grid[7][6] = Knight.new('black', [7, 6])

    grid[7][2] = Bishop.new('black', [7, 2])
    grid[7][5] = Bishop.new('black', [7, 5])

    grid[7][3] = Queen.new('black', [7, 3])
    grid[7][4] = King.new('black', [7, 4])
  end

  def make_move(player)
    legal_moves = []

    while legal_moves == []
      piece = player.choose_piece
      piece = player.choose_piece until piece_legal?(player, piece)
      piece = find_piece(piece)
      legal_moves = piece.find_legal_moves(@board.grid)
    end

    move = player.move_piece
    move = player.move_piece until move_legal?(move, legal_moves)

    move_piece(piece, move, @board.grid, player)
  end

  def move_piece(piece, move, grid, player)
    piece.moved = true if piece.moved == false

    old_position = piece.position
    row = old_position[0]
    column = old_position[1]
    grid[row][column] = ' '

    piece.position = move
    row = move[0]
    column = move[1]

    if grid[row][column] != ' '
      take_piece(row, column, player)
      grid[row][column] = piece
    else
      grid[row][column] = piece
    end
  end

  def find_piece(piece)
    row = piece[0]
    column = piece[1]
    piece = @board.grid[row][column]
  end

  def piece_legal?(player, piece)
    piece = find_piece(piece)
    return false if piece == ' '
    piece.color == player.color
  end

  def move_legal?(move, legal_moves)
    legal_moves.include?(move) ? true : false
  end

  def take_piece(row, column, player)
    taken_piece = @board.grid[row][column]
    taken_piece.position = nil

    player.graveyard << taken_piece
  end

  def promote_pawn(piece)
    return if piece.class != Pawn

    if piece.color == 'white' && piece.position[0] == 7 || piece.color == 'black' && piece.position[0] == 0
      puts "Your pawn made it across the board!"
      puts "What would you like to promote it to?"
      puts "1. Queen, 2. Rook, 3. Bishop, 4. Knight"
      promotion = gets.chomp
      
      until /^[1-4]/.match?(promotion)
        puts "Please enter a number between 1 - 4:"
        promotion = gets.chomp
      end

      color = piece.color
      position = piece.position
      cell = @board.grid[position[0]][position[1]]

      if promotion == '1'
        cell = Queen.new(color, position)
      elsif promotion == '2'
        cell = Rook.new(color, position)
      elsif promotion == '3'
        cell = Bishop.new(color, position)
      elsif promotion == '4'
        cell = Knight.new(color, position)
      end
    end
  end
end
