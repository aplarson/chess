require_relative 'chess_errors'

class Piece
  
  attr_accessor :position
  attr_reader :color, :board
  
  def initialize(color, position, board)
    @color = color
    @position = position
    @board = board
  end
  
  def move(new_position)
    unless self.valid_moves.include?(new_position)
      raise IntoCheckError if move_into_check?(new_position)
      raise IllegalMoveError
    end
    update_board(new_position)
    self.position = new_position
  end
  
  def valid_moves
    self.moves.select do |move|
      !move_into_check?(move)
    end
  end
  
  def generate_move(length, direction)
    x = (direction[0] * length) + self.position[0]
    y = (direction[1] * length) + self.position[1]
    [x, y]
  end
  
  def opposing_color
    self.board.opposing_color(self.color)
  end
  
  def to_s
    "#{self.class.name}, #{self.color}, #{self.position}"
  end
  
  protected
  
  def move!(new_position)
    update_board(new_position)
    self.position = new_position
  end
  
  private 
  
  def on_board?(position)
    position.all? { |coord| coord.between?(0, 7) }
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
    duped_board[self.position].move!(pos)
    duped_board.in_check?(self.color)
  end

end