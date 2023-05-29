class Textblock{
  String text;
  double yup;
  double ydown;
  double xleft;
  double xright;
  double ymean;
  double xmean;



  Textblock({required this.text,required this.yup,required this.ydown,required this.ymean,required this.xmean,required this.xleft,required this.xright});
  // textblock.empty();


  //this method will append the data of the
  // incoming next block coming from parameter
  // to the current
  void append(next){
    this.text = this.text+"🟨"+ next.text;
    // todo :if error occurs handle x position
    // current.xleft =;
    // current.xright=;
    this.yup = this.yup;
    this.ydown = next.ydown;
    this.ymean = (this.yup.toDouble() + next.ydown.toDouble()) / 2;
    this.xmean = this.xmean;
  }
}