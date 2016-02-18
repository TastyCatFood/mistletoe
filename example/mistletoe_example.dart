import 'package:mistletoe/mistletoe.dart';
// Sample code for demonstrating an application of Mistletoe.
void main(){
  var m = new Mistletoe();
  var t = new DateTime.now();

  // Associating the key 'print time now'
  // and the value ()=>print(t) on the context
  // of the object t; both the key and the value
  // should be garbage collected once t is
  // garbage collected.
  m.add( t, 'print time now', () =>print(t));

  // Getting keys store in m on the the context of t
  print(m.keys(t));
  // Accessing the stored value
  for (var k in m.keys(t)) {
    // 'print time now' will be printed
    print(k.toString());
    var p = m.value(t, k);
    if(p is Function){
      //()=>print(t) is invoked
      print(p());
    }else{
      print(p);
    }
  }
  // Find the number on values stored
  // on the context of t in m.
  print(m.length(t));
  // Destroying the context t.
  // All keys, values in m stored on
  // the context t should be garbage
  // collected now.
  t = null;
  //copying
  print('== m contains ==');
  t = new Object();
  m.add(t, 'key one',
      ()=>print('key one will not be copied'));
  m.add(t, 'key two',
      ()=>print('key two copied'));
  for(var k in m.keys(t)) m.value(t,k)();

  print('=== only key two copied to m2 === ');
  var m2 = new Mistletoe();
  for (var k in m.keys(t)){
    if(k.toString().contains('key two')){
      m2.add(t,k,m.value(t,k));
    }
  }
  //Only key two copied
  for(var k in m2.keys(t)) {
    m2.value(t,k)();
  }


  //Dynamic property sim
  print('=====dynamic property sim====');
  // adding a property, getting and
  // setting a value.
  var d = new Dynamism(expert:true);
  d.on(t).add_property(
      't','fetched from a dynamically added property t');
  print(d.get_property_value(t,'t'));
  d.set_property_value(t,'t','I am the value of t now');
  print(d.get_property_value(t,'t'));

  //Made easier with DynamicWrapper and [on]
  d.on(t).test = 'I am set via '
      '[on] method and [DynamicWrapper]';
  print(d.on(t).test);
  //adding a function
  d.on(t).time_now = (){
    print('current time is: ${new DateTime.now()}');};
  d.on(t).time_now();
  // Viewing added properties and functions
  print('properties added on t in d: ${d.on(t).properties()}');
  print('methods added on t in d: ${d.methods(t)}');

  // passing parameters
  d.on(m).age_check = (name, age){
    print('Hi, I am a ${name}, ${age} years old.');
  };
  d.on(m).age_check('dog',5);

  // Never do the below.
  // The method [on] returns
  // a DynamicWrapper instance which
  // contains a strong reference.
  var wrapper = d.on(m);
  // Calling a method or accessing a property
  // in a DynamicWrapper instance, destroys
  // the strong reference that exists within.
  // But, binding a DynamicWrapper to a variable
  // should not be done.
  wrapper.age_check('owl',0);

  //Have a function return something
  d.on(m).add_property('let_me_sleep',(){
    return 'sleep later';
  });
  String msg = d.on(m).let_me_sleep();
  print('The function let_me_sleep returned this string: ${msg}');
  // The below should throw an error.
  // A DynamicWapper object can only be
  // used once.
  //wrapper.bye('owl',0);
}