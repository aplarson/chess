# encoding: utf-8
require_relative "stepping_piece"
require_relative 'sliding_piece'
require_relative 'pawn'
require_relative 'chess_errors'
require 'colorize'

class Board
  attr_reader :grid
  def initialize(new_game = true)
    @grid = Array.new(8) { Array.new(8) { nil } }
    populate if new_game == true
  end
  
  def translate_move(move_information)
    origin, destination, color = move_information
    
    origin = translate_coord(origin)
    destination = translate_coord(destination)
  
    self.move([origin, destination, color])
  end
  
  def [](pos)
    row, col = pos
    @grid[row][col]
  end
  
  def []=(pos, val)
    row, col = pos
    @grid[row][col] = val
  end
  
  def game_over?
    (checkmate? :white) || (checkmate? :black)
  end
  
  def display
    print "    a  b  c  d  e  f  g  h \n"
    grid.each_with_index do |row, i|
      print " #{8-i} "
      row.each_with_index do |square, j|
        print background_color(display_piece(square), i, j)
      end
      print " #{8-i}\n"
    end
    print "    a  b  c  d  e  f  g  h \n"
  end
  
  def opposing_color(color)
    color == :black ? :white : :black
  end
  
  def in_check?(color)
    king_position = find_king(color).position
    color_pieces(opposing_color(color)).any? do |piece|
      piece.moves.include?(king_position)
    end
  end
  
  def checkmate?(color)
    in_check?(color) && 
        color_pieces(color).all? { |piece| piece.valid_moves.empty? }
  end
  
  def dup
    dup_board = Board.new(false)
    pieces.each do |piece|
      new_piece = piece.class.new(piece.color, piece.position, dup_board)
      dup_board.place_piece(new_piece)
    end
    return dup_board
  end
  
  def move(move_information)
    start, end_pos, color = move_information
    raise NoPieceError if self[start] == nil || 
      self[start].color != color
    self[start].move(end_pos)
  end
  
  def place_piece(piece)
    self[piece.position] = piece
  end
  
  private
  
  def display_piece(piece)
    return '   ' if piece.nil?
    UNICODE_PIECES[[piece.color, piece.class]]
  end
  
  def background_color(value, row, col)
    return value.colorize(:background => :light_black) if (row + col) % 2 == 1
    value
  end  
  
  def populate
    back_row = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
    back_row.each_with_index do |klass, col|
      self[[0, col]] = klass.new(:black, [0, col], self)
      self[[1, col]] = Pawn.new(:black, [1, col], self)
      self[[6, col]] = Pawn.new(:white, [6, col], self)
      self[[7, col]] = klass.new(:white, [7, col], self)
    end
  end

  def pieces
    @grid.flatten.select { |square| !(square.nil?) }
  end
  
  def color_pieces(color)
    pieces.select { |piece| piece.color == color }
  end
  
  def find_king(color)
    pieces.find { |piece| piece.is_a?(King) && piece.color == color }
  end

  def translate_coord(position)
    position = position.downcase.split("")
    coords = [RANK[position[1]], FILE[position[0]]]
    raise InvalidInputError if coords.include?(nil)
    coords
  end

  RANK = { "8" => 0,
      "7" => 1,
      "6" => 2,
      "5" => 3,
      "4" => 4,
      "3" => 5,
      "2" => 6,
      "1" => 7 
      }
  
    FILE = { "a" => 0,
      "b" => 1,
      "c" => 2,
      "d" => 3,
      "e" => 4,
      "f" => 5,
      "g" => 6,
      "h" => 7 
      }
      
  
    UNICODE_PIECES = {
      [:white,  King] => " ♔ ",	
      [:white, Queen] => " ♕ ",	
      [:white, Rook] => " ♖ ",	
      [:white, Bishop] => " ♗ ",	
      [:white, Knight] => " ♘ ",	
      [:white, Pawn] => " ♙ ",	
      [:black, King] => " ♚ ",	
      [:black, Queen] => " ♛ ",	
      [:black, Rook] => " ♜ ",	
      [:black, Bishop] => " ♝ ",	
      [:black, Knight] => " ♞ ",	
      [:black, Pawn] => " ♟ "
      }	 
end