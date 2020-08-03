describe Board do
  describe '#make_board' do
    it "outpus an 8x8 2-d array" do
      board = Board.new
      expect(board.grid).to eq([
        [0,1,2,3,4,5,6,7],
        [0,1,2,3,4,5,6,7],
        [0,1,2,3,4,5,6,7],
        [0,1,2,3,4,5,6,7],
        [0,1,2,3,4,5,6,7],
        [0,1,2,3,4,5,6,7],
        [0,1,2,3,4,5,6,7],
        [0,1,2,3,4,5,6,7],
      ])
    end
  end
end