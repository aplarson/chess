require_relative 'piece'

class SlidingPiece < Piece
  def moves
    moves = []
    self.move_directions.each do |direction|
      moves += explore_direction(direction)
    end
    moves
  end
  
  def explore_direction(direction)
    moves_in_direction = []
    (1..7).each do |i|
      x = (direction[0] * i) + self.position[0]
      y = (direction[1] * i) + self.position[1]
      break unless on_board?([x, y])
      case occupied([x, y])
      when false
        moves_in_direction << [x,y]
      when self.color
        break
      else
        moves_in_direction << [x,y]
        break
      end
    end
    moves_in_direction
  end
end

class Bishop < SlidingPiece
  def move_directions
    [[1, 1], [-1, 1], [-1, -1], [1, -1]]
  end
end

class Rook < SlidingPiece
  def move_directions
    [[1, 0], [-1, 0], [0, 1], [0, -1]]
  end
end

class Queen < SlidingPiece
  def move_directions
    [[1, 0], [-1, 0], [0, 1], [0, -1], [1, 1], [-1, 1], [-1, -1], [1, -1]]
  end
end