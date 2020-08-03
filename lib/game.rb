class Game
  def initialize
    @player1 = Player.new('Player 1','white')
    @player2 = Player.new('Player 2','black')
    @board = Board.new
  end
end