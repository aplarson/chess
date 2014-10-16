require_relative 'piece'
require 'debugger'

class SteppingPiece < Piece
  def moves
    move_directions.map do |direction|
      self.generate_move(1, direction)
    end.select do |position|
      on_board?(position) &&
      occupied(position) != self.color
    end
  end
end

class King < SteppingPiece
  
  def initialize(color, position, board)
    super(color, position, board)
    @moved = false
  end
  
  def move(new_position)
    if castle_moves.has_key?(new_position)
      castle(new_position)
    else
      super(new_position)
    end
    @moved = true
  end
  
  def moves
    super + castle_moves.keys
  end
  
  def moved?
    @moved
  end
  
  def castle(new_position)
    rook = castle_moves[new_position]
    move!(new_position)
    
    if rook.position[1] == 7
      rook.move!([self.position[0], 5])
    else
      rook.move!([self.position[0], 3])
    end
  end
  
  def castle_moves
    return {} if moved?
    
    row = self.position[0]
    king_side_rook = board[[row, 7]]
    queen_side_rook = board[[row, 0]]
    
    castles = {}
    if !king_side_rook.nil? && !king_side_rook.moved? && 
                               castle_path_clear?(5..6, row)
      castles[[row, 6]] = king_side_rook
    end
    
    if !queen_side_rook.nil? && !queen_side_rook.moved? && 
                                 castle_path_clear?(1..3, row)
      castles[[row, 2]] = queen_side_rook
    end
    
    castles
  end
  
  def castle_path_clear?(range, row)
    range.all? do |col|
      board[[row, col]].nil?
    end
  end
  
  private
  def move_directions
    [[1,0],[1,1],[0,1],[-1,1],[-1,0],[-1,-1],[0,-1],[1,-1]]
  end
end

class Knight < SteppingPiece
  private
  def move_directions
    [[1,2],[2,1],[-1,2],[2,-1],[-2,-1],[-2,1],[1,-2],[-1,-2]]
  end
end