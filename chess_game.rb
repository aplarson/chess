require_relative 'board'

class ChessGame
  attr_reader :board
  
  def initialize
    @board = Board.new
  end
  
  def play
    colors = [:white, :black]
    turn = 0
    until @board.game_over?
     opponent = colors[(turn + 1) % 2]
     play_turn(colors[turn % 2], opponent)
     turn += 1
    end
    checkmate(colors.find { |color| !(self.board.checkmate?(color)) })
  end
  
  private
  
  def play_turn(color, opponent)
    self.board.display
    get_move(color)

    check_notification(opponent)
  end
  
  def checkmate(color)
    puts "#{color} wins!"
    self.board.display
  end
  
  def check_notification(color)
    puts "#{color} is in check" if self.board.in_check?(color)
  end
  
  def user_messages(color)
    puts "Where is the piece you want to move?"
    origin = gets.chomp
  
    puts "Where do you want to move it?"
    destination = gets.chomp
  
    board.translate_move([origin, destination, color])
  end
  
  def get_move(color)
    puts "It is #{color}'s turn"
    begin
      user_messages(color)
    rescue NoPieceError
      puts "You don't have a piece there!"
      retry
    rescue IntoCheckError
      puts "You can't move into check"
      retry
    rescue IllegalMoveError
      puts "That is illegal, buddy!"
      retry
    rescue InvalidInputError
      puts "This is indeed an existential problem"
      retry
    end
  end
end

ChessGame.new.play