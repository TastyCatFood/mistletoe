import 'imported_file.dart' as p;

void main(){
  p.d.on(p.e).greetings = 'hi from top level variable d';
  print(p.d.on(p.e).greetings);

  p.d.on(p.e).f = (a, b)=>a+' '+b;
  print(p.d.on(p.e).f('function f called on d', ' with 2 params'));

  p.d2.on(p.e).greetings = 'hi from locally defined '
      'top level variable d2';
  print(p.d2.on(p.e).greetings);

  p.d2.on(p.e).f = (a,b){return a+b;};
  print(p.d2.on(p.e).f('d2 function f', ' cadded'));

  p.A.d.on(p.e).greetings = 'hi from static class member';
  print(p.A.d.on(p.e).greetings);

  p.A.d.on(p.e).f = (){return 'f called on A';};
  print(p.A.d.on(p.e).f());

  p.n.d.on(p.e).greetings = 'hi from an instance member of n';
  print(p.n.d.on(p.e).greetings) ;

  p.n.d.on(p.e).f = (g)=>g;
  print(p.n.d.on(p.e).f('instance member Dynamic d access passed'));


  print(p.func_test(p.d));

  print(p.A.use_d(p.e));

  print(p.n.use_d(p.e));
}
