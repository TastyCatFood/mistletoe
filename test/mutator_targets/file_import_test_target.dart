import 'imported_file.dart';

void main(){
  d.on(e).greetings = 'hi from top level variable d';
  print(d.on(e).greetings);

  d.on(e).f = (a, b)=>a+' '+b;
  print(d.on(e).f('function f called on d', ' with 2 params'));

  d2.on(e).greetings = 'hi from locally defined '
      'top level variable d2';
  print(d2.on(e).greetings);

  d2.on(e).f = (a,b){return a+b;};
  print(d2.on(e).f('d2 function f', ' cadded'));

  A.d.on(e).greetings = 'hi from static class member';
  print(A.d.on(e).greetings);

  A.d.on(e).f = (){return 'f called on A';};
  print(A.d.on(e).f());

  n.d.on(e).greetings = 'hi from an instance member of n';
  print(n.d.on(e).greetings) ;

  n.d.on(e).f = (g)=>g;
  print(n.d.on(e).f('instance member Dynamic d access passed'));


  print(func_test(d));

  print(A.use_d(e));

  print(n.use_d(e));
}
