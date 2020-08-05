module Rules
  def in_check?(player, grid)
    enemy_pieces = find_enemy_pieces(player, grid)

    enemy_pieces.each do |piece|
      moves = piece.find_legal_moves(grid)
      return true if moves.include?(player.king_piece.position)
    end

    false
  end

  def stalemate?(player, grid)
    return true if !in_check?(player, grid) && no_moves?(player, grid)

    false
  end

  def checkmate?(player, grid)
    in_check?(player, grid) && king_no_moves?(player, grid) ? true : false
  end

  def no_moves?(player, grid)
    player_pieces = find_player_pieces(player, grid)
    moves = []
    player_pieces.each do |piece|
      moves << piece.find_legal_moves(grid)
    end
    moves = moves.flatten(1)

    enemy_pieces = find_enemy_pieces(player, grid)
    enemy_moves = []
    enemy_pieces.each do |piece|
      enemy_moves << piece.find_legal_moves(grid)
    end
    enemy_moves = enemy_moves.flatten(1)

    moves.all? do |move|
      enemy_moves.include?(move)
    end
  end

  def king_no_moves?(player, grid)
    king_moves = player.king_piece.find_legal_moves(grid)

    enemy_pieces = find_enemy_pieces(player, grid)

    enemy_moves = []
    enemy_pieces.each do |piece|
      enemy_moves << piece.find_legal_moves(grid)
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

  def find_player_pieces(player, grid)
    all_pieces = find_all_pieces(grid)

    player_pieces = []

    all_pieces.each do |piece|
      player_pieces << piece if piece.color == player.color
    end

    player_pieces
  end

  def find_enemy_pieces(player, grid)
    all_pieces = find_all_pieces(grid)

    enemy_pieces = []

    all_pieces.each do |piece|
      enemy_pieces << piece if piece.color != player.color
    end

    enemy_pieces
  end

  def can_castle?(piece)
    return true if piece.class == King && piece.moved == false

    false
  end

  def spaces_not_in_check?(position, player, grid)
    open_spaces = open_spaces(position, grid)

    return false if open_spaces == []

    enemy_pieces = find_enemy_pieces(player, grid)

    enemy_pieces.each do |piece|
      moves = piece.find_legal_moves(grid)
      return false if open_spaces.any? { |space| moves.include?(space) }
    end

    true
  end

  def open_spaces(position, grid)
    if position == [0, 7] && grid[0][6] == ' ' && grid[0][5] == ' '
      [[0, 6], [0, 5]]
    elsif position == [0, 0] && grid[0][1] == ' ' && grid[0][2] == ' ' && board.grid[0][3]
      [[0, 1], [0, 2], [0, 3]]
    elsif position == [7, 7] && grid[7][6] == ' ' && grid[7][5] == ' '
      [[7, 6], [7, 5]]
    elsif position == [7, 0] && grid[7][1] == ' ' && grid[7][2] == ' ' && board.grid[7][3]
      [[7, 1], [7, 2], [7, 3]]
    else
      []
    end
  end

  def castle(piece, player, grid)
    if piece.color == 'white'
      if grid[0][7].moved == false && spaces_not_in_check?([0, 7], player, grid)
        [0, 6]
      elsif grid[0][0].moved == false && spaces_not_in_check?([0, 0], player, grid)
        [0, 2]
      end
    elsif piece.color == 'black'
      if grid[7][7].moved == false && spaces_not_in_check?([7, 7], player, grid)
        [7, 6]
      elsif grid[7][0].moved == false && spaces_not_in_check?([7, 0], player, grid)
        [7, 2]
      end
    end
  end

  def move_rook(move, player, piece, grid)
    if move == [0, 6]
      move_piece(grid[0][7], [0, 5], grid, player)
      piece.castled = true
    elsif move == [0, 2]
      move_piece(grid[0][0], [0, 3], grid, player)
      piece.castled = true
    elsif move == [7, 6]
      move_piece(grid[7][7], [7, 5], grid, player)
      piece.castled = true
    elsif move == [7, 2]
      move_piece(grid[7][0], [7, 3], grid, player)
      piece.castled = true
    end
  end

  def en_passant_possible?(player_piece, grid)
    return false if player_piece.class != Pawn
    return true if find_pawn(player_piece, grid) != []

    false
  end

  def take_pawn(move, player, piece, grid)
    columns = find_pawn(piece, grid)

    columns.each do |i|
      take_piece(4, i, player) if move[1] == i && player.color == 'white'
      take_piece(3, i, player) if move[1] == i && player.color == 'black'
    end

    player.graveyard
  end

  def en_passant(piece, player, grid)
    columns = find_pawn(piece, grid)
    moves = []

    columns.each do |i|
      moves << [5, i] if player.color == 'white'
      moves << [2, i] if player.color == 'black'
    end

    moves
  end

  def find_pawn(player_piece, grid)
    n = 4 if player_piece.color == 'white'
    n = 3 if player_piece.color == 'black'

    i = 0
    pawn_column = []

    until i > 7
      piece = grid[n][i]
      if piece.class == Pawn && piece.color != player_piece.color && piece.move_count + 1 == @move_counter
        pawn_column << i
      end
      i += 1
    end

    pawn_column
  end

  def promote_pawn(piece, grid, board)
    return piece if piece.class != Pawn

    if piece.color == 'white' && piece.position[0] == 7 || piece.color == 'black' && piece.position[0] == 0
      clear_screen
      board.display_board
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
        grid[row][column] = Queen.new(color, position)
      elsif promotion == '2'
        grid[row][column] = Rook.new(color, position)
      elsif promotion == '3'
        grid[row][column] = Bishop.new(color, position)
      elsif promotion == '4'
        grid[row][column] = Knight.new(color, position)
      end
    end
  end
end
