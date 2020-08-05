require './lib/board.rb'
require './lib/game.rb'
require './lib/player.rb'
require './lib/pieces.rb'
require_relative 'saveload.rb'
require 'yaml'

class Game
  include SaveLoad
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
      if in_check?(player) && !king_no_moves?(player)
        while in_check?(player)
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
    if checkmate?(player)
      enemy
    elsif stalemate?(player)
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
    return true if checkmate?(player)
    return true if stalemate?(player)
    return true if player.graveyard.include?(enemy.king_piece)

    false
  end

  def stalemate?(player)
    return true if !in_check?(player) && no_moves?(player)

    false
  end

  def no_moves?(player)
    player_pieces = find_player_pieces(player)
    moves = []
    player_pieces.each do |piece|
      moves << piece.find_legal_moves(@board.grid)
    end
    moves = moves.flatten(1)

    enemy_pieces = find_enemy_pieces(player)
    enemy_moves = []
    enemy_pieces.each do |piece|
      enemy_moves << piece.find_legal_moves(@board.grid)
    end
    enemy_moves = enemy_moves.flatten(1)

    moves.all? do |move|
      enemy_moves.include?(move)
    end
  end

  def in_check?(player)
    enemy_pieces = find_enemy_pieces(player)

    enemy_pieces.each do |piece|
      moves = piece.find_legal_moves(@board.grid)
      return true if moves.include?(player.king_piece.position)
    end

    false
  end

  def king_no_moves?(player)
    king_moves = player.king_piece.find_legal_moves(@board.grid)

    enemy_pieces = find_enemy_pieces(player)

    enemy_moves = []
    enemy_pieces.each do |piece|
      enemy_moves << piece.find_legal_moves(@board.grid)
    end

    enemy_moves = enemy_moves.flatten(1)

    king_moves.all? do |move|
      enemy_moves.include?(move)
    end
  end

  def find_all_pieces(grid)
    pieces = []

    grid.each do |row|
      i = 0
      until i > 7
        pieces << row[i] if row[i] != ' '
        i += 1
      end
    end

    pieces
  end

  def find_player_pieces(player)
    all_pieces = find_all_pieces(@board.grid)

    player_pieces = []

    all_pieces.each do |piece|
      player_pieces << piece if piece.color == player.color
    end

    player_pieces
  end

  def find_enemy_pieces(player)
    all_pieces = find_all_pieces(@board.grid)

    enemy_pieces = []

    all_pieces.each do |piece|
      enemy_pieces << piece if piece.color != player.color
    end

    enemy_pieces
  end

  def checkmate?(player)
    in_check?(player) && king_no_moves?(player) ? true : false
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
        legal_moves << castle(piece, player) if can_castle?(piece)
        if en_passant_possible?(piece)
          moves = en_passant(piece, player)
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
    promote_pawn(piece)
  end

  def can_castle?(piece)
    return true if piece.class == King && piece.moved == false

    false
  end

  def spaces_not_in_check?(position, player)
    open_spaces = open_spaces(position)

    return false if open_spaces == []

    enemy_pieces = find_enemy_pieces(player)
  
    enemy_pieces.each do |piece|
      moves = piece.find_legal_moves(@board.grid)
      return false if open_spaces.any? { |space| moves.include?(space) }
    end
  
    true
  end

  def open_spaces(position)
    if position == [0, 7] && @board.grid[0][6] == ' ' && @board.grid[0][5] == ' '
      [[0,6],[0,5]]
    elsif position == [0, 0] && @board.grid[0][1] == ' ' && @board.grid[0][2] == ' ' && board.grid[0][3]
      [[0,1],[0,2],[0,3]]
    elsif position == [7, 7] && @board.grid[7][6] == ' ' && @board.grid[7][5] == ' '
      [[7,6],[7,5]]
    elsif position == [7, 0] && @board.grid[7][1] == ' ' && @board.grid[7][2] == ' ' && board.grid[7][3]
      [[7,1],[7,2],[7,3]]
    else
      []
    end
  end

  def castle(piece, player)
    if piece.color == 'white'
      if @board.grid[0][7].moved == false && spaces_not_in_check?([0, 7], player)
        [0, 6]
      elsif @board.grid[0][0].moved == false && spaces_not_in_check?([0, 0], player)
        [0, 2]
      end
    elsif piece.color == 'black'
      if @board.grid[7][7].moved == false && spaces_not_in_check?([7, 7], player)
        [7, 6]
      elsif @board.grid[7][0].moved == false && spaces_not_in_check?([7, 0], player)
        [7, 2]
      end
    end
  end

  def move_piece(piece, move, grid, player)
    piece.moved = true if piece.moved == false
    piece.move_count = @move_counter if piece.class == Pawn && (move[0] - piece.position[0] == 2 || move[0] - piece.position[0] == -2)

    move_rook(move, player, piece) if piece.class == King
    take_pawn(move, player, piece) if piece.class == Pawn

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

  def move_rook(move, player, piece)
    if move == [0,6]
      move_piece(@board.grid[0][7], [0,5],@board.grid, player)
      piece.castled = true
    elsif move == [0,2]
      move_piece(@board.grid[0][0], [0,3],@board.grid, player)
      piece.castled = true
    elsif move == [7,6]
      move_piece(@board.grid[7][7], [7,5],@board.grid, player)
      piece.castled = true
    elsif move == [7,2]
      move_piece(@board.grid[7][0], [7,3],@board.grid, player)
      piece.castled = true
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

  def promote_pawn(piece)
    return piece if piece.class != Pawn

    if piece.color == 'white' && piece.position[0] == 7 || piece.color == 'black' && piece.position[0] == 0
      clear_screen
      @board.display_board
      puts 'Your pawn made it across the board!'
      puts 'What would you like to promote it to?'
      puts '1. Queen, 2. Rook, 3. Bishop, 4. Knight'
      promotion = gets.chomp

      until /^[1-4]/.match?(promotion)
        puts 'Please enter a number between 1 - 4:'
        promotion = gets.chomp
      end

      color = piece.color
      position = piece.position
      row = position[0]
      column = position[1]
      piece.position = nil

      if promotion == '1'
        @board.grid[row][column] = Queen.new(color, position)
      elsif promotion == '2'
        @board.grid[row][column] = Rook.new(color, position)
      elsif promotion == '3'
        @board.grid[row][column] = Bishop.new(color, position)
      elsif promotion == '4'
        @board.grid[row][column] = Knight.new(color, position)
      end
    end
  end

  def en_passant_possible?(player_piece)
    return false if player_piece.class != Pawn
    return true if find_pawn(player_piece) != []

    false
  end

  def take_pawn(move, player, piece)
    columns = find_pawn(piece)

    columns.each do |i|
      take_piece(4, i, player) if move[1] == i && player.color == 'white'
      take_piece(3, i, player) if move[1] == i && player.color == 'black'
    end

    player.graveyard
  end

  def en_passant(piece, player)
    columns = find_pawn(piece)
    moves = []

    columns.each do |i|
      moves << [5, i] if player.color == 'white'
      moves << [2, i] if player.color == 'black'
    end

    moves
  end

  def find_pawn(player_piece)
    n = 4 if player_piece.color == 'white'
    n = 3 if player_piece.color == 'black'

    i = 0
    pawn_column = []

    until i > 7
      piece = @board.grid[n][i]
      pawn_column << i if piece.class == Pawn && piece.color != player_piece.color && piece.move_count + 1 == @move_counter
      i += 1
    end

    pawn_column
  end
end
