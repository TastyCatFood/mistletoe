library main;

import 'package:mistletoe/mistletoe.dart';
part 'b.dart';

var d_t  = new Dynamism(expert:true);
void main(){
  var e = new Object();
  d_t.on(e).greetings = 'hi from mistletoe';
  print(d_t.on(e).greetings);
}