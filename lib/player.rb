class Player
  def initialize(name, color)
    @name = name
    @color = color
  end

  def make_move
    puts "#{@name}, select your piece:"
    piece = gets.chomp.upcase
    piece = convert_input(piece)

    puts 'Move your piece:'
    move = gets.chomp.upcase
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

    input = [column[input[0]], input[1].to_i - 1]
  end
end
