bool help(int a){
  int x= a~/8;
  int y= a%8;
  if((x+y)%2==0)return true;
  return false;
}
bool validmove(int r,int c){
  return r>=0 && r<8 && c>=0 && c<8;
}