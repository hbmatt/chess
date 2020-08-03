class King
  attr_accessor :position, :legal_moves

  def initialize(position = nil)
    @position = position
    @moves = [
      [0,1],[1,1],[1,0],[1,-1],
      [0,-1],[-1,-1],[-1,0],[-1,1]
    ]
    @legal_moves = find_legal_moves()
  end

  def find_legal_moves
    legal_moves = []

    @moves.each do |move|
      x = @position[0] + move[0]
      y = @position[1] + move [1]
      if x >= 0 && y >= 0 && x <= 7 && y <= 7
        legal_moves << [x,y]
      end
    end

    legal_moves
  end
end