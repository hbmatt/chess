class Player
  attr_accessor :name, :graveyard, :king_piece
  attr_reader :color

  def initialize(name, color)
    @name = name
    @color = color
    @graveyard = []
    @king_piece = ''
  end

  def choose_piece
    piece = ''
    until piece == 'SAVE' || /^[A-H][1-8]$/.match?(piece)
      puts "#{@name}, select your piece:"
      piece = gets.chomp.upcase
    end
    return piece if piece == 'SAVE'

    piece = convert_input(piece)
  end

  def move_piece
    move = ''
    until move == 'SAVE' || /^[A-H][1-8]$/.match?(move)
      puts 'Move your piece:'
      move = gets.chomp.upcase
    end
    return move if move == 'SAVE'

    move = convert_input(move)
  end

  def convert_input(input)
    column = {
      'A' => 0,
      'B' => 1,
      'C' => 2,
      'D' => 3,
      'E' => 4,
      'F' => 5,
      'G' => 6,
      'H' => 7
    }

    row = input[1].to_i - 1

    input = [row, column[input[0]]]
  end
end
