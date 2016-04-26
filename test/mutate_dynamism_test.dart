import 'package:mistletoe/dynamism_mutator.dart';
import 'package:test/test.dart';
String code = """
library main;
import 'package:mistletoe/mistletoe.dart';

var d_t = new Dynamism(expert: true);
void main() {
  var e = new Object();
  d_t.on(e).greetings = 'hi from mistletoe';
  print(d_t.on(e).greetings);
}
var b = 'by bye';
var d = new Dynamism(expert:true);
class A{
  Dynamism d = new Dynamism(expert:true);
}
class B{
  static Dynamism d = new Dynamism(expert:true);
  static var c;
}
""";

main(){
  group('A gropu of tests',(){
    test('A simple mutate_dynamism_output_test',
        ()async{
          String output =
            """library main; import 'package:mistletoe/mistletoe.dart'; var d_t = new Dynamism(expert: true); void main() {var e = new Object(); d_t.on(e).set('greetings', 'hi from mistletoe'); print(d_t.on(e).get('greetings'));} var b = 'by bye'; var d = new Dynamism(expert: true); class A {Dynamism d = new Dynamism(expert: true);} class B {static Dynamism d = new Dynamism(expert: true); static var c;}""";
          String r = await mutate_dynamism('',code:code);
          expect(r,output);
        });
  });
}