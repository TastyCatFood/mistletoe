import 'package:mistletoe/mistletoe.dart';
var d  = new Dynamism(expert:true);
Dynamism d2 = new Dynamism(expert:true);
var e = new Object();
var n = new B();

func_test(p){
  p = p as Dynamism;
  p.on(p).greetings = 'hi from function';
  return p.on(p).greetings;
}

class A{
  static Dynamism d = new Dynamism(expert:true);
  static use_d(v){
    return d.on(v).greetings;
  }
}
class B{
  Dynamism d = new Dynamism(expert:true);
  use_d(v){
    return d.on(v).greetings;
  }
}
