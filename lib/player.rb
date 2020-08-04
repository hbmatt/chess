class Player
  def initialize(name, color)
    @name = name
    @color = color
  end

  def choose_piece
    puts "#{@name}, select your piece:"
    piece = gets.chomp.upcase
    piece = convert_input(piece)
    
    until check_piece_legal?(piece)
      puts 'Please select a valid piece:'
      piece = gets.chomp.upcase
      piece = convert_input(piece)
    end
  end

  def move_piece
    puts 'Move your piece:'
    move = gets.chomp.upcase
    move = convert_input(move)

    until check_move_legal?(move)
      puts 'Please enter a legal move:'
      move = gets.chomp.upcase
      move = convert_input(move)
    end
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

    input = [row,column[input[0]]]
  end
end
