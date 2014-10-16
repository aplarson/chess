require_relative 'piece'

class SlidingPiece < Piece
  def moves
    moves = []
    move_directions.each do |direction|
      moves += explore_direction(direction)
    end
    moves
  end
  
  def explore_direction(direction)
    
    moves_in_direction = []
    (1..7).each do |i|
      pos = generate_move(i, direction)
      break unless on_board?(pos)
      moves_in_direction << handle_occupation(pos)
      break if occupied(pos)
    end
    moves_in_direction.compact
  end
  
  def handle_occupation(pos)
    x, y = pos
    case occupied([x, y])
    when false
      return [x,y]
    when self.color
      return nil
    else
      return [x,y]
    end
  end
end

class Bishop < SlidingPiece
  
  private
  def move_directions
    [[1, 1], [-1, 1], [-1, -1], [1, -1]]
  end
end

class Rook < SlidingPiece
  
  def initialize(color, position, board)
    super(color, position, board)
    @moved = false
  end
  
  def move(new_position)
    super(new_position)
    @moved = true
  end
  
  def moved?
    @moved
  end
  
  private
  
  def move_directions
    [[1, 0], [-1, 0], [0, 1], [0, -1]]
  end
end

class Queen < SlidingPiece
  private
  def move_directions
    [[1, 0], [-1, 0], [0, 1], [0, -1], [1, 1], [-1, 1], [-1, -1], [1, -1]]
  end
end