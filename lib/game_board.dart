import 'dart:math';

import 'package:chess_game/components/box.dart';
import 'package:chess_game/components/data.dart';
import 'package:chess_game/components/piece.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Game_Board extends StatefulWidget {
  Game_Board({super.key});

  @override
  State<Game_Board> createState() => _Game_BoardState();
}

class _Game_BoardState extends State<Game_Board> {
  //2 d array for each of the elements in the game
  late List<List<ChessPiece?>> board;
  List<int> whiteking=[7,4];
  List<int>blackking=[0,3];
  bool checkstatus=false;


  void _init_board(){
    List<List<ChessPiece?>> newboard=(List.generate(8, (index) => List.generate(8,(index)=>null)));




    // pawns
    for(int i=0;i<8;i++){
      newboard[1][i]=ChessPiece(
        type: ChesPieceType.pawn,
        imagePath: "assets/pawn.png",
        isWhite: false
      );
      newboard[6][i]=ChessPiece(
          type: ChesPieceType.pawn,
          imagePath: "assets/pawn.png",
          isWhite: true
      );
    }

    // hathi
    newboard[0][0]=ChessPiece(
        type: ChesPieceType.ruke,
        imagePath: "assets/hathi.png",
        isWhite: false
    );
    newboard[0][7]=ChessPiece(
        type: ChesPieceType.ruke,
        imagePath: "assets/hathi.png",
        isWhite: false
    );
    newboard[7][0]=ChessPiece(
        type: ChesPieceType.ruke,
        imagePath: "assets/hathi.png",
        isWhite: true
    );
    newboard[7][7]=ChessPiece(
        type: ChesPieceType.ruke,
        imagePath: "assets/hathi.png",
        isWhite: true
    );

    // ghoda/knight
    newboard[0][1]=ChessPiece(
        type: ChesPieceType.knight,
        imagePath: "assets/knight.png",
        isWhite: false
    );
    newboard[0][6]=ChessPiece(
        type: ChesPieceType.knight,
        imagePath: "assets/knight.png",
        isWhite: false
    );
    newboard[7][1]=ChessPiece(
        type: ChesPieceType.knight,
        imagePath: "assets/knight.png",
        isWhite: true
    );
    newboard[7][6]=ChessPiece(
        type: ChesPieceType.knight,
        imagePath: "assets/knight.png",
        isWhite: true
    );

    // bishop
    newboard[0][2]=ChessPiece(
        type: ChesPieceType.bishop,
        imagePath: "assets/bishop_black.png",
        isWhite: false
    );
    newboard[0][5]=ChessPiece(
        type: ChesPieceType.bishop,
        imagePath: "assets/bishop_black.png",
        isWhite: false
    );
    newboard[7][2]=ChessPiece(
        type: ChesPieceType.bishop,
        imagePath: "assets/bishop_black.png",
        isWhite: true
    );
    newboard[7][5]=ChessPiece(
        type: ChesPieceType.bishop,
        imagePath: "assets/bishop_black.png",
        isWhite: true
    );

    // king
    newboard[0][3]=ChessPiece(
        type: ChesPieceType.king,
        imagePath: "assets/king.png",
        isWhite: false
    );
    newboard[7][4]=ChessPiece(
        type: ChesPieceType.king,
        imagePath: "assets/king.png",
        isWhite: true
    );

    // queen
    newboard[0][4]=ChessPiece(
        type: ChesPieceType.queen,
        imagePath: "assets/queen.png",
        isWhite: false
    );
    newboard[7][3]=ChessPiece(
        type: ChesPieceType.queen,
        imagePath: "assets/queen.png",
        isWhite: true
    );

    // board[]



    board=newboard;
  }
  ChessPiece? selectedpiece;

  List<ChessPiece> white=[];
  List<ChessPiece> black=[];
  @override
  void initState() {
    // TODO: implement initState
    _init_board();
  }
  int selrow=-1;
  int selcol=-1;
  List<List<int>> moves=[];
  bool whoseTurn=true;
  void pieceselect(int r,int c){
    setState(() {
      if(selectedpiece==null && board[r][c]!=null){
        if(board[r][c]!.isWhite==whoseTurn){
          selectedpiece=board[r][c];
          selrow=r;
          selcol=c;
        }
      }
      else if(board[r][c]!=null && board[r][c]!.isWhite == selectedpiece!.isWhite){
        selectedpiece=board[r][c];
        selrow=r;
        selcol=c;
      }
      else if(selectedpiece!=null && moves.any((element) => element[0]==r && element[1]==c)){
        movePiece(r, c);
      }
      moves=calcrealMoves(r,c,selectedpiece,true);
    });
  }

  List<List<int>> calcrammove(int r,int c,ChessPiece? piece){
    // if(piece==null)
    List<List<int>> mov=[];
    if(piece==null)return mov;
    // int dir = piece!.isWhite?-1:1;

    switch(piece!.type){
      case ChesPieceType.pawn:
        int dir = piece!.isWhite?-1:1;
        // 1 step
        if(validmove(r+dir, c) && board[r+dir][c]==null){
          mov.add([r+dir,c]);
        }
        // 2 steps
        if((r==1 && !piece.isWhite)||(r==6 && piece.isWhite)){
          if(validmove(r+2*dir, c) && board[r+2*dir][c]==null && board[r+dir][c]==null){
            mov.add([r+2*dir,c]);
          }
        }
        // diagonal kill
        if(validmove(r+dir, c-1) && board[r+dir][c-1]!=null && board[r+dir][c-1]!.isWhite != piece.isWhite){
          mov.add([r+dir,c-1]);
        }
        if(validmove(r+dir, c+1) && board[r+dir][c+1]!=null && board[r+dir][c+1]!.isWhite != piece.isWhite){
          mov.add([r+dir,c+1]);
        }
        break;

        // hathi ke chal hai bahi
      case ChesPieceType.ruke:
        var dir=[
          [-1,0],
          [1,0],
          [0,1],
          [0,-1]
        ];
        for(var d in dir){
          int i=1;
          while(true){
            var nr=r+i*d[0];
            var nc=c+i*d[1];
            if(!validmove(nr, nc))break;
            if(board[nr][nc]!=null){
              if(board[nr][nc]!.isWhite !=piece.isWhite){
                mov.add([nr,nc]);
              }break;
            }
            mov.add([nr,nc]);
            i++;
          }
        }
        break;


        // ghoda chalega ab
      case ChesPieceType.knight:
        var dir=[
          [-2,-1],
          [-2,1],
          [-1,-2],
          [-1,2],
          [1,-2],
          [1,2],
          [2,-1],
          [2,1]
        ];
        for(var m in dir){
          int nr=r+m[0];
          int nc=c+m[1];
          if(!validmove(nr, nc))continue;
          if(board[nr][nc]!=null){
            if(board[nr][nc]!.isWhite != piece.isWhite){
              mov.add([nr,nc]);
            }
            continue;
          }
          mov.add([nr,nc]);
        }

        break;
      case ChesPieceType.bishop:
        var dir=[
          [1,1],
          [-1,1],
          [-1,-1],
          [1,-1]
        ];
        for(var d in dir){
          int i=1;
          while(true){
            int nr=r+i*d[0];
            int nc=c+i*d[1];
            if(!validmove(nr, nc))break;
            if(board[nr][nc]!=null){
              if(board[nr][nc]!.isWhite != piece.isWhite){
                mov.add([nr,nc]);
              }
              break;
            }
            mov.add([nr,nc]);
            i++;
          }
        }
        break;
      case ChesPieceType.queen:
        var dir=[
          [-1,1],
          [1,1],
          [1,-1],
          [-1,-1],
          [1,0],
          [0,1],
          [0,-1],
          [-1,0]
        ];
        for(var d in dir){
          int i=1;
          while(true){
            int nr=r+i*d[0];
            int nc=c+i*d[1];
            if(!validmove(nr, nc))break;
            if(board[nr][nc]!=null){
              if(board[nr][nc]!.isWhite != piece.isWhite){
                mov.add([nr,nc]);
              }
              break;
            }
            mov.add([nr,nc]);
            i++;
          }
        }
        break;
      case ChesPieceType.king:
        var dir=[
          [-1,1],
          [1,1],
          [1,-1],
          [-1,-1],
          [1,0],
          [0,1],
          [0,-1],
          [-1,0]
        ];
        for(var d in dir){
          int nr=r+d[0];
          int nc=c+d[1];
          if(!validmove(nr, nc))continue;
          if(board[nr][nc]!=null){
            if(board[nr][nc]!.isWhite != piece.isWhite) {
              mov.add([nr,nc]);
            }
          }else{
            mov.add([nr,nc]);
          }
        }
        break;
    }
    return mov;
  }

  List<List<int>> calcrealMoves(int r,int c,ChessPiece? piece,bool checkSimulation){
    List<List<int>> realMoves=[];
    List<List<int>> moves=calcrammove(r, c, piece);

    if(checkSimulation){
      for(var move in moves){
        int er=move[0];
        int ec=move[1];

        if(simulatedMoveSafe(piece!,r,c,er,ec)){
          realMoves.add(move);
        }
      }
    }
    else {
      realMoves=moves;
    }
    return realMoves;
  }

  bool simulatedMoveSafe(ChessPiece piece,int row,int col,int er,int ec){
    ChessPiece? op=board[er][ec];

    List<int>? kingpos;
    if(piece!.type ==ChesPieceType.king){
      kingpos=piece.isWhite?whiteking:blackking;

      if(piece.isWhite){
        whiteking=[er,ec];
      }
      else{
        blackking=[er,ec];
      }
    }

    board[er][ec]=piece;
    board[row][col]=null;


    bool iskingcheck=KingIschecked(piece.isWhite);

    board[row][col]=piece;
    board[er][ec]=op;

    if(piece.type== ChesPieceType.king){
      if(piece.isWhite){
        whiteking=kingpos!;
      }
      else{
        blackking=kingpos!;
      }
    }

  return !iskingcheck;
  }

  void movePiece(int nr,int nc){
    if(board[nr][nc]!=null){
      if(board[nr][nc]!.isWhite) {
        white.add(board[nr][nc]!);
      } else {
        black.add(board[nr][nc]!);
      }
    }

      board[nr][nc]=selectedpiece;
      board[selrow][selcol]=null;
      if(selectedpiece!.type==ChesPieceType.king){
        if(selectedpiece!.isWhite){
          whiteking=[nr,nc];
        }
        else{
          blackking=[nr,nc];
        }
      }

      if(KingIschecked(!whoseTurn)){
        checkstatus=true;
      }else{
        checkstatus=false;
      }
      setState(() {
        selcol=-1;
        selrow=-1;
        moves.clear();
        selectedpiece=null;
      });

      if(isCheckMate(!whoseTurn)){
        showDialog(context: context, builder: (context) => AlertDialog(
          title: Text("CHECK MATE!"),
            actions: [
              TextButton(onPressed: reset, child: Text("Restart"))
            ],
        ),);
      }

      whoseTurn=!whoseTurn;
  }

  void reset(){
    Navigator.pop(context);
    _init_board();
    whoseTurn=true;
    whiteking=[7,4];
    blackking=[0,3];
    checkstatus=false;
    white.clear();
    black.clear();
    setState(() {});
  }

  bool KingIschecked(bool iswhite){
    List<int> kingposition= iswhite?whiteking:blackking;

    for(int i=0;i<8;i++){
      for(int j=0;j<8;j++){
        if(board[i][j]==null)continue;
        if(board[i][j]!=null && board[i][j]!.isWhite ==iswhite)continue;

        List<List<int>> piece=calcrealMoves(i, j, board[i][j],false);
        if(piece.any((ele) => ele[0]==kingposition[0] && ele[1]==kingposition[1])) {
          return true;
        }
      }
    }
    return false;

  }

  bool isCheckMate(bool iswhiteKing){
    if(!KingIschecked(iswhiteKing)){
      return false;
    }
    for(int i=0;i<8;i++){
      for(int j=0;j<8;j++){
        if(board[i][j]==null || board[i][j]!.isWhite !=iswhiteKing)continue;
        List<List<int>> piecemoves=calcrealMoves(i, j, board[i][j], true);
        if(piecemoves.isNotEmpty)return false;
      }
    }
    return true;
  }

  // ChessPiece mypawn = ChessPiece(imagePath: "assets/king.png", isWhite: false, type: ChesPieceType.pawn);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child:GridView.builder(itemCount: white.length,physics: NeverScrollableScrollPhysics(),gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8), itemBuilder: (context, index) => DeadPiece(imagepath: white[index].imagePath,iswhite: true,),)),
          checkstatus==true?const Text("Check"):const Text(""),
          Expanded(
            flex: 3,
            child: GridView.builder(
              itemCount:64,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
                itemBuilder: (context, index) {
                int r=index~/8;
                int c=index%8;
                bool issel=selrow==r && selcol==c;
                bool valid=false;
                for(var pos in moves){
                  if(pos[0]==r && pos[1]==c){
                    valid=true;
                  }
                }
                  return Center(
                      child: Square(iswhite: help(index),
                        piece: board[r][c], isselected: issel,
                        onTap: () => pieceselect(r,c),
                        isvalid: valid,
                      )
                  );
                }
              ),
          ),

          Expanded(child:GridView.builder(itemCount: black.length,physics: NeverScrollableScrollPhysics(),gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8), itemBuilder: (context, index) => DeadPiece(imagepath: black[index].imagePath,iswhite: false,),)),
        ],
      ),
    );
  }
}