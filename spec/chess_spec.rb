require './lib/board.rb'
require './lib/game.rb'
require './lib/player.rb'
require './lib/pieces.rb'
require './lib/rules.rb'

describe Board do
  describe '#make_board' do
    it 'outputs an 8x8 2-d array' do
      board = Board.new
      expect(board.grid).to eq(Array.new(8, [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']))
    end
  end
end

describe Piece do
  describe Rook do
    describe '#find_legal_moves' do
      it 'stops loop after blocking team piece discovered' do
        game = Game.new
        board = game.board
        player = Player.new('Cheese', 'white')
        game.place_white_pieces(board.grid)
        piece = board.grid[1][7]
        game.move_piece(piece, [3, 7], board.grid, player)
        piece = board.grid[0][7]
        expect(piece.find_legal_moves(board.grid)).to eq([[1, 7], [2, 7]])
      end
    end
  end
end

describe Game do
  game = Game.new
  board = game.board
  player = Player.new('Cheese', 'white')

  describe '#move_piece' do
    game.place_white_pieces(board.grid)
    piece = board.grid[1][7]
    game.move_piece(piece, [3, 7], board.grid, player)

    it "erases the chosen piece's old position" do
      expect(board.grid[1][7]).to eq(' ')
    end

    it 'moves the chosen piece to the new position' do
      expect(board.grid[3][7]).not_to eq(' ')
    end
  end

  describe '#promote_pawn' do
    it 'promotes a pawn in the right row' do
      pawn = board.grid[3][7]
      board.grid[3][7] = ' '
      board.grid[7][7] = pawn
      pawn.position = [7, 7]
      allow(game).to receive(:gets) { '1' }

      expect(game.promote_pawn(pawn, board.grid, board).class).to eq(Queen)
    end

    it 'replaces pawn with the chosen piece' do
      expect { puts board.grid[7][7] }.to output(puts("\u2655")).to_stdout
    end
  end

  game2 = Game.new
  board2 = game2.board
  player2 = game2.player1
  enemy2 = game2.player2

  describe '#in_check?' do
    it "returns true when player's king in check" do
      player2.king_piece = board2.grid[0][7] = King.new('white', [0, 7])
      board2.grid[0][4] = Rook.new('black', [0, 4])
      expect(game2.in_check?(player2, board2.grid)).to eq(true)
    end
  end

  describe '#checkmate?' do
    it "returns true when player's king is in check and has no moves" do
      board2.grid[2][7] = King.new('black', [2, 7])
      expect(game2.checkmate?(player2, board2.grid)).to eq(true)
    end
  end

  # describe '#end_game' do
  #   it 'prints correct winner' do
  #     expect{game2.end_game(player2,enemy2)}.to output("Game over! Player 2 wins!\n").to_stdout
  #   end
  # end

  describe '#stalemate?' do
    it 'returns true when player not in check and has no moves' do
      rook2 = board2.grid[0][4]
      rook2.position = [2, 6]
      board2.grid[2][6] = rook2
      board2.grid[0][4] = ' '
      expect(game2.stalemate?(player2, board2.grid)).to eq(true)
    end
  end

  game3 = Game.new
  board3 = game3.board
  player3 = game3.player1
  enemy3 = game3.player2
  board3.grid[4][4] = Pawn.new('black',[4, 4])
  board3.grid[4][4].move_count = 3
  game3.move_counter = 4
  player_piece = board3.grid[4][3] = Pawn.new('white',[4, 3])

  describe '#find_pawn' do
    it "returns the columns of enemy pawns" do
      expect(game3.find_pawn(player_piece,board3.grid)).to eq([4])
    end
  end

  describe '#en_passant' do
    it "returns the possible en passant moves" do
      expect(game3.en_passant(player_piece, player3, board3.grid)).to eq([[5, 4]])
    end
  end

  describe '#en_passant_possible?' do
    it "returns true when en passant is possible" do
      expect(game3.en_passant_possible?(player_piece, board3.grid)).to eq(true)
    end
  end

  describe '#take_pawn' do
    it "puts enemy pawn in graveyard in case of en passant" do
      expect(game3.take_pawn([5,4], player3, player_piece, board3.grid)).to eq(player3.graveyard)
    end
  end

end
