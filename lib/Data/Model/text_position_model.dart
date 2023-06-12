
class TextBlockObject{
  String text;
  double yUp;
  double yDown;
  double xLeft;
  double xRight;
  double yMean;
  double xMean;

  TextBlockObject({required this.text,required this.yUp,required this.yDown,required this.yMean,required this.xMean,required this.xLeft,required this.xRight});
  //this method will append the data of the
  // incoming next block coming from parameter
  // to the current
  void append(next){
    text = text + next.text;
    // todo :if error occurs handle x position
    yUp = yUp;
    yDown = next.yDown;
    yMean = (yUp.toDouble() + next.yDown.toDouble()) / 2;
    xMean = xMean;
  }
}