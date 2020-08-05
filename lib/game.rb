require_relative 'saveload.rb'
require_relative 'rules.rb'

class Game
  include SaveLoad
  include Rules
  attr_accessor :board, :player1, :player2, :move_counter

  def initialize
    @player1 = Player.new('Player 1', 'white')
    @player2 = Player.new('Player 2', 'black')
    @board = Board.new
    @move_counter = 1
  end

  def start_game
    puts "\n+------------------------------------------------+
    \rLet's Play Chess!"
    old_game = ask_load
    if old_game == false
      get_players
      place_white_pieces(@board.grid)
      place_black_pieces(@board.grid)
    end
    clear_screen

    loop do
      player = choose_player_turn
      enemy = assign_enemy
      break if game_over?(player, enemy)

      @board.display_board
      if in_check?(player, @board.grid) && !king_no_moves?(player, @board.grid)
        while in_check?(player, @board.grid)
          puts 'You are in check! You must move your king out of check.'
          make_move(player)
        end
      else
        make_move(player)
      end
      clear_screen

      @move_counter += 1
    end

    end_game(player, enemy)
  end

  def ask_load
    puts "\nLoad saved game? [Y/N]"
    answer = gets.chomp.upcase

    until answer == 'Y' || answer == 'N'
      puts "\nYou can't do that! Load game? [Y/N]"
      answer = gets.chomp.upcase
    end

    if answer == 'Y'
      load_game
    else
      puts "\n\nStarting new game!\n\nTo save your game, type 'save' at any time."
      false
    end
  end

  def load_game
    load = load_file
    return false if load == false

    @board = load['board']
    @player1 = load['player1']
    @player2 = load['player2']
    @move_counter = load['move_counter']

    puts "\n\nYour game has been loaded.\n\nTo save your game, type 'save' at any time."
  end

  def end_game(player, enemy)
    winner = find_winner(player, enemy)

    if winner == 'draw'
      puts 'Stalemate! The game is a draw.'
    else
      puts "Game over! #{winner.name} wins!"
    end

    restart_game
  end

  def find_winner(player, enemy)
    if checkmate?(player, @board.grid)
      enemy
    elsif stalemate?(player, @board.grid)
      'draw'
    elsif player.graveyard.include?(enemy.king_piece)
      player
    end
  end

  def restart_game
    puts "\nPlay again? [Y/N]"
    answer = gets.chomp.upcase

    unless answer == 'Y' || answer == 'N'
      puts 'Please enter Y or N:'
      answer = gets.chomp.upcase
    end

    if answer == 'Y'
      Game.new.start_game
    else
      puts "\nGoodbye!"
      exit
    end
  end

  def game_over?(player, enemy)
    return true if checkmate?(player, @board.grid)
    return true if stalemate?(player, @board.grid)
    return true if player.graveyard.include?(enemy.king_piece)

    false
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

  def assign_enemy
    if @move_counter.odd?
      @player2
    elsif @move_counter.even?
      @player1
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
    @player1.king_piece = grid[0][4] = King.new('white', [0, 4])
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
    @player2.king_piece = grid[7][4] = King.new('black', [7, 4])
  end

  def make_move(player)
    legal_moves = []

    while legal_moves == []
      piece = player.choose_piece
      if piece == 'SAVE'
        save_game(@board, @player1, @player2, @move_counter)
      else
        piece = player.choose_piece until piece_legal?(player, piece)
        piece = find_piece(piece)
        legal_moves = piece.find_legal_moves(@board.grid)
        legal_moves << castle(piece, player, @board.grid) if can_castle?(piece)
        if en_passant_possible?(piece, @board.grid)
          moves = en_passant(piece, player, @board.grid)
          moves.each do |move|
            legal_moves << move
          end
        end
      end
    end

    move = player.move_piece
    if move == 'SAVE'
      save_game(@board, @player1, @player2, @move_counter)
    else
      move = player.move_piece until move_legal?(move, legal_moves)
    end

    piece = move_piece(piece, move, @board.grid, player)
    promote_pawn(piece, @board.grid, @board)
  end

  def move_piece(piece, move, grid, player)
    piece.moved = true if piece.moved == false
    if piece.class == Pawn && (move[0] - piece.position[0] == 2 || move[0] - piece.position[0] == -2)
      piece.move_count = @move_counter
    end

    move_rook(move, player, piece, @board.grid) if piece.class == King
    take_pawn(move, player, piece, @board.grid) if piece.class == Pawn

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

    @board.grid[row][column] = ' '

    player.graveyard << taken_piece
  end
end
