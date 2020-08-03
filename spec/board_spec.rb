require './lib/board.rb'

describe Board do
  describe '#make_board' do
    it "outputs an 8x8 2-d array" do
      board = Board.new
      expect(board.grid).to eq(Array.new(8, [' ',' ',' ',' ',' ',' ',' ',' ']))
    end
  end
end