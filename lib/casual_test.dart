import 'mistletoe.dart';

void main(){
//sample code for demonstrating an application of Mistletoe

  var m = new Mistletoe();
  var t = new DateTime.now();
  // Associating key and value on the context of t
  // both the key and the value should be garbage
  // collected once t has been garbage collected.
  m.add( t, 'print time now', () =>print(t));

  // getting keys store in m on the the context of t
  print(m.keys(t));
  //accessing the stored value
  for (var k in m.keys(t)) {
    print(k.toString()); // 'print time now' will be printed
    m.value(t, k)(); //()=>print(t) is invoked
  }
  print(m.length(t));
  //now destroying all keys, values by destroying the context t
  t = null;
  //creating a partial copy of the Mistletoe m
  print('==copying partially(only '
      'key two and its associates will be copied)==');
  //adding new key value pairs to now empty m on the context of new t;
  t = new Object();
  m.add(t, 'key one', () {
    print('key one used to fetch this:'+t.toString());
  });
  m.add(t, 'key two', () {
    print('key two used to fetch this'+t.toString());
  });
  // copying only 'key two' to the new Mistletoe
  var m2 = new Mistletoe();
  for (var k in m.keys(t)){
    if(k.toString().contains('key two')){
      m2.add(t,k,m.value(t,k));
    }
  }
  //using the copied key value pair
  for(var k in m2.keys(t)) {
    print(k.toString());
    m2.value(t,k)();
  }

  //dynamic property sim
  m = new Object();
  print('=====dynamic property sim====');
  var d = new Dynamism(true);
  d.add_method(m,'hi',(){print('dynamically added hi');});
  d.invoke(m,'hi');

  //More human readable form
  d.on(m).add_method('bye',(name,age){
    print("dynamically added bye \n ${name}, "
        'Your age is ${age}, you are not '
        'allowed to drink legally');
  });

  //get all added methods
  print(d.on(m).methods());
  d.on(m).bye('doggy',5);
  var wrapper = d.on(m);
  wrapper.bye('catty',0);

  //have function return something
  d.on(m).add_method('let_me_sleep',(){
    return 'you may sleep more than you wish for once the time comes ';
  });
  String msg = d.on(m).let_me_sleep();
  print(msg);
//should throw an error. as on(m) returns a pseudo temporal only object
//  wrapper.bye('catty',0);

}