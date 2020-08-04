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
  end
end