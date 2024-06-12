enum ChesPieceType {pawn, ruke, king,queen,bishop,knight}

class ChessPiece{
  final ChesPieceType type;
  final bool isWhite;
  final String imagePath;

  ChessPiece({required this.imagePath,required this.isWhite, required this.type});
}

