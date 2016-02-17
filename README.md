# Mistletoe
A weakmap variant.
- Has keys method
- Support pseudo dynamic addition of properties


Mistletoes or the group of plants in the genus Viscum are parasitic plants and grow on another tree.
Likewise, mistletoe attaches objects on an existing object and those attached objects, provided there are no external references to them, share the life span with the host object.

# Currently in Beta(Basic tests are done)$
pub: https://pub.dartlang.org/packages/mitstletoe
home: https://github.com/TastyCatFood/mistletoe


Sample code
<code><pre>
import 'package:mitstletoe/mistletoe.dart';

void main(){
  //sample code for demonstrating an
  // application of Mistletoe.

  var m = new Mistletoe();
  var t = new DateTime.now();
  // Associating the key 'print time now'
  // and the value ()=>print(t) on the context
  // of the object t; both the key and the value
  // should be garbage collected once t has been
  // garbage collected.
  m.add( t, 'print time now', () =>print(t));

  // Getting keys store in m on the the context of t
  print(m.keys(t));
  // Accessing the stored value
  for (var k in m.keys(t)) {
    // 'print time now' will be printed
    print(k.toString());
    //()=>print(t) is invoked
    m.value(t, k)();
  }
  // Find the number on values stored
  // on the context of t in m.
  print(m.length(t));
  // Destroying the context t.
  // All keys, values in m stored on
  // the context t should be garbage
  // collected now.
  t = null;

  // Copying
  t = new Object();
  m.add(t, 'key one', ()=>print('key one'));
  m.add(t, 'key two', ()=>print('key two'));

  // copying only 'key two'
  var m2 = new Mistletoe();
  for (var k in m.keys(t)){
    if(k.toString().contains('key two')){
      m2.add(t,k,m.value(t,k));
    }
  }
  //Only key two copied
  for(var k in m2.keys(t)) {
    print(k.toString());
    m2.value(t,k)();
  }


  //Dynamic property sim
  m = new Object();
  print('=====dynamic property sim====');
  var d = new Dynamism(expert:true);
  d.add_method(m,'hi',(){
    print('dynamically added hi called');});
  d.invoke(m,'hi');

  // View all added methods
  print(d.on(m).methods());

  //More human friendly syntax
  d.on(m).add_method('age_check',(name,age){
    print('hi ${name}, are you really ${age}?' );
  });

  d.on(m).age_check('doggy',5);

  // Never do the below
  // The method on returns
  // a DynamicWrapper which
  // contains a strong reference.
  // Once used, a DynamicWrapper
  // destroys itself, but if stored
  // will keep the wrapped object,
  // in the case below m, alive.
  var wrapper = d.on(m);
  wrapper.age_check('owl',0);

  //Have a function return something
  d.on(m).add_method('let_me_sleep',(){
    return 'you may sleep more than you wish for once the time comes ';
  });
  String msg = d.on(m).let_me_sleep();
  print(msg);
  // The below should throw an error.
  // A DynamicWapper object can only be
  // used once.
  //wrapper.bye('owl',0);

}
</code></pre>
