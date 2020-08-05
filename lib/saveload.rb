require 'yaml'

module SaveLoad
  def save_game(board, player1, player2, move_counter)
    saved_variables = [board, player1, player2, move_counter]

    data = { 'board' => board, 'player1' => player1, 'player2' => player2, 'move_counter' => move_counter }

    File.open('save.yaml', 'w') do |file|
      file.write(data.to_yaml)
    end

    puts "\nYour game has been saved.\n"

    exit_game
  end

  def exit_game
    puts "\nKeep playing? [Y/N]"

    answer = gets.chomp.upcase

    until answer == 'Y' || answer == 'N'
      puts "\nYou can't do that! Keep playing? [Y/N]"
      answer = gets.chomp.upcase
    end

    if answer == 'N'
      puts "\nGoodbye!"
      exit
    end
  end

  def load_file
    if File.exist?('save.yaml')
      YAML.load(File.read('save.yaml'))
    else
      puts "\n\nThere is no save information."
      puts "\n\nStarting new game!\n\n"
      false
    end
  end
end
