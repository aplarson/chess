require_relative 'chess_errors'

class Piece
  
  attr_accessor :position
  attr_reader :color, :board
  
  def initialize(color, position, board)
    @color = color
    @position = position
    @board = board
  end
  
  def on_board?(position)
    position.all? { |coord| coord.between?(0, 7) }
  end
  
  def move(new_position)
    if !(self.moves.include?(new_position))
      raise IllegalMoveError "Can't move there"
    elsif move_into_check?(new_position)
      raise IllegalMoveError "Can't move into check"
    end
    update_board(new_position)
    self.position = new_position
  end
  
  def valid_moves
    
  end
  
  def update_board(new_position)
    @board[new_position] = self
    @board[self.position] = nil
  end
  
  def occupied(position)
    @board[position].nil? ? false : @board[position].color
  end
  
  def move_into_check?(pos)
    duped_board = self.board.dup
    duped_board[self.position].move(pos)
    duped_board.in_check?(self.color)
  end
end