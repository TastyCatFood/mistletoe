library main;

import 'package:mistletoe/mistletoe.dart';

var d_t = new Dynamism(expert: true);
void main() {
  var e = new Object();
  d_t.on(e).set('greetings', 'hi from mistletoe');
  print(d_t.on(e).get('greetings'));
}

var b = 'by bye';
var d = new Dynamism(expert: true);

class A {
  Dynamism d = new Dynamism(expert: true);
}

class B {
  static Dynamism d = new Dynamism(expert: true);
  static var c;
}
