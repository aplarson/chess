require_relative "stepping_piece"
require_relative 'sliding_piece'
require_relative 'pawn'
require_relative 'chess_errors'

class Board
  attr_reader :grid
  def initialize(new_game = true)
    @grid = Array.new(8) { Array.new(8) { nil } }
    if new_game == true
      populate(:black)
      populate(:white)
    end
  end
  
  def [](pos)
    row, col = pos
    @grid[row][col]
  end
  
  def []=(pos, val)
    row, col = pos
    @grid[row][col] = val
  end
  
  PIECE_ABBREVS = { King => "K", 
    Queen => "Q", 
    Knight => "N", 
    Rook => "R", 
    Bishop => "B", 
    Pawn => "P"
  }
  
  COLOR_ABBREVS = { :black => "b", :white => "w" }
  
  def display_piece(piece)
    (COLOR_ABBREVS[piece.color] + PIECE_ABBREVS[piece.class]).to_sym
  end
  
  def display
    self.grid.each do |row|
      row.each do |square|
        if square.nil?
          print '[]'
        else
          print display_piece(square)
        end
      end
      print "\n"
    end
  end
  
  def populate(color)
    back_row = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]

    color == :black ? (b_row, f_row = 0, 1) : (b_row, f_row = 7, 6)     

    back_row.each_with_index do |klass, col|
      self[[b_row, col]] = klass.new(color, [b_row, col], self)
      self[[f_row, col]] = Pawn.new(color, [f_row, col], self)
    end
  end
  
  def pieces
    @grid.flatten.select { |square| !(square.nil?) }
  end
  
  def opposing_pieces(color)
    pieces.select { |piece| piece.color == opposing_color(color) }
  end
  
  def opposing_color(color)
    color == :black ? :white : :black
  end
  
  def find_king(color)
    pieces.find { |piece| piece.is_a?(King) && piece.color == color }
  end
  
  def in_check?(color)
    king_position = find_king(color).position
    opposing_pieces(color).any? do |piece|
      piece.moves.include?(king_position)
    end
  end
  
  def checkmate?(color)
    in_check?(color) && 
  end
  
  def move(start, end_pos)
    raise NoPieceError if self[start] == nil
    self[start].move(end_pos)
  end
  
  def dup
    dup_board = Board.new(false)
    pieces.each do |piece|
      new_piece = piece.class.new(piece.color, piece.position, dup_board)
      dup_board.place_piece(new_piece)
    end
    return dup_board
  end
  
  def place_piece(piece)
    self[piece.position] = piece
  end
  
  def put_king_almost_in_check
    find_king(:white).update_board([3, 0])
    self[[3, 0]] = find_king(:white)
    find_king(:white).position = [3, 0]
  end
end

b = Board.new
b.put_king_almost_in_check
b.display
p b[[3, 0]].move_into_check?([2, 0])
p b[[3, 0]].move_into_check?([3, 1])
b.display
p b[[3, 0]]