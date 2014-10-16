require_relative 'piece'
require 'active_support/inflector'

class Pawn < Piece
  def initialize(color, position, board)
    super(color, position, board)
    @moved = false
  end
  
  def moves
    explore_forward + attack_moves
  end
  
  def move(new_position)
    super(new_position)
    @moved = true
    promotion_check
  end
  
  def attack_moves
    attack_directions.map do |direction|
      generate_move(1, direction)
    end.select { |position| occupied(position) == self.opposing_color }
  end
  
  def explore_forward
    unless @moved
      straight_moves(2)
    else
      straight_moves(1)
    end
  end
  
  def straight_moves(times)
    moves = []
    (1..times).each do |i|
      x, y = generate_move(i, move_directions)
      break unless on_board?([x, y])
      if occupied([x, y])
        break
      end
      moves << [x, y]
    end
    moves
  end
  
  def promotion_check
    begin
      promote if self.position[0] == 7 || self.position[0] == 0
    rescue BadPromotionError
      puts "That's not a piece; this is a piece!"
      retry
    end
  end
  
  def promote
    puts "What piece would you like?"
    choice = gets.chomp.capitalize
    unless ["Queen", "Rook", "Bishop", "Knight"].include?(choice)
      raise BadPromotionError
    end
    new_piece = choice.constantize.new(self.color, self.position, self.board)
    self.board.place_piece(new_piece)
  end
  
  private
  
  def move_directions
    self.color == :black ? [1, 0] : [-1, 0]
  end
  
  def attack_directions
    self.color == :black ? [[1, 1], [1, -1]] : [[-1, 1], [-1, 1]]
  end
end