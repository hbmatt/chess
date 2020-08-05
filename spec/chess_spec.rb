require './lib/board.rb'
require './lib/game.rb'
require './lib/player.rb'
require './lib/pieces.rb'

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
        player = Player.new('Cheese','white')
        game.place_white_pieces(board.grid)
        piece = board.grid[1][7]
        game.move_piece(piece,[3,7],board.grid,player)
        piece = board.grid[0][7]
        expect(piece.find_legal_moves(board.grid)).to eq([[1,7],[2,7]])
      end
    end
  end
end

describe Game do
  game = Game.new
  board = game.board
  player = Player.new('Cheese','white')

  describe '#move_piece' do
    game.place_white_pieces(board.grid)
    piece = board.grid[1][7]
    game.move_piece(piece,[3,7],board.grid,player)

    it "erases the chosen piece's old position" do
      expect(board.grid[1][7]).to eq(' ')
    end

    it "moves the chosen piece to the new position" do
      expect(board.grid[3][7]).not_to eq(' ')
    end
  end

  describe '#promote_pawn' do
    it 'promotes a pawn in the right row' do
      pawn = board.grid[3][7]
      board.grid[3][7] = ' '
      board.grid[7][7] = pawn
      pawn.position = [7,7]
      allow(game).to receive(:gets) { '1' }
      
      expect(game.promote_pawn(pawn).class).to eq(Queen)
    end

    it 'replaces pawn with the chosen piece' do
      expect{puts board.grid[7][7]}.to output(puts "\u2655").to_stdout
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
      expect(game2.in_check?(player2)).to eq(true)
    end
  end

  describe '#checkmate?' do
    it "returns true when player's king is in check and has no moves" do
      board2.grid[2][7] = King.new('black', [2, 7])
      expect(game2.checkmate?(player2)).to eq(true)
    end
  end

  describe '#end_game' do
    it 'prints correct winner' do
      expect{game2.end_game(player2,enemy2)}.to output("Game over! Player 2 wins!\n").to_stdout
    end
  end
end