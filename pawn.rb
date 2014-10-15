require_relative 'piece'

class Pawn < Piece
  def initialize(color, position, board)
    super(color, position, board)
    @moved = false
  end
  
  def moves
    explore_forward + attack_moves
  end
  
  def straight_moves(times)
    moves = []
    (1..times).each do |i|
      x = (move_directions[0] * i) + self.position[0]
      y = (move_directions[1] * i) + self.position[1]
      break unless on_board?([x, y])
      if occupied([x, y])
        break
      end
      moves << [x, y]
    end
    moves
  end
  
  def attack_moves
    self.attack_directions.map do |direction|
      x = direction[0] + self.position[0]
      y = direction[1] + self.position[1]
      [x,y]
    end.select { |position| occupied(position) && 
      occupied(position) != self.color }
  end
  
  def move(new_position)
    super(new_position)
    @moved = true
  end
  
  def move_directions
    self.color == :black ? [1, 0] : [-1, 0]
  end
  
  def attack_directions
    self.color == :black ? [[1, 1], [1, -1]] : [[-1, 1], [-1, 1]]
  end
  
  def explore_forward
    unless @moved
      straight_moves(2)
    else
      straight_moves(1)
    end
  end
end