import 'package:chess_game/components/piece.dart';
import 'package:flutter/material.dart';

class Square extends StatelessWidget {
  final iswhite;
  final ChessPiece? piece;
  final bool isselected;
  final bool isvalid;
  final void Function()? onTap;
  const Square({super.key, required this.iswhite,required this.piece,required this.isselected,required this.onTap, required this.isvalid});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: isselected?Colors.green:isvalid?Colors.green[300]:(iswhite?Colors.black26:Colors.black54),
        child: piece !=null ? Padding(
          padding: const EdgeInsets.all(2.0),
          child: Image.asset(piece!.imagePath,color: piece!.isWhite?Colors.white:Colors.black,),
        ):null,

      ),
    );
  }
}

class DeadPiece extends StatelessWidget {
  final String imagepath;
  final bool iswhite;
  const DeadPiece({super.key, required this.imagepath, required this.iswhite});

  @override
  Widget build(BuildContext context) {
    return Image.asset(imagepath,color: iswhite?Colors.blue:Colors.black54,);
  }
}
