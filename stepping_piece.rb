require_relative 'piece'

class SteppingPiece < Piece
  def moves
    self.move_directions.map do |direction|
      x = direction[0] + self.position[0]
      y = direction[1] + self.position[1]
      [x,y]
    end.select { |position| on_board?(position) &&
                  occupied(position) != self.color }
  end
end

class King < SteppingPiece
  def move_directions
    [[1,0],[1,1],[0,1],[-1,1],[-1,0],[-1,-1],[0,-1],[1,-1]]
  end
end

class Knight < SteppingPiece
  def move_directions
    [[1,2],[2,1],[-1,2],[2,-1],[-2,-1],[-2,1],[1,-2],[-1,-2]]
  end
end