class IllegalMoveError < StandardError
end

class NoPieceError < IllegalMoveError
end

class IntoCheckError < IllegalMoveError
end

class InvalidInputError < StandardError
end

class BadPromotionError < InvalidInputError
end