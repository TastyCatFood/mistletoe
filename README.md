# Mistletoe
A weakmap with keys method and support for dynamic addition of properties and their invocation.

Mistletoes or the group of plants in the genus Viscum are parasitic and grow on another tree.
Likewise, mistletoe grows on existing objects and what has grown disappears when the host object is garbage collected.

# Currently in alpha

Sample code
<code><pre>
import 'mistletoe.dart';
void main(){
//sample code for demonstrating an application of AdvancedWeakmap
  var m = new AdvancedWeakmap();
  var t = new DateTime.now();
  //associating key and value on the context of t
  // both key and value should be garbage collected once t has been garbage collected
  m.add(
      t,
      'print time now',
      () =>print(t));

  // fetching all the keys that can be used to fetch
  // values in the context of t
  for (var k in m.keys(t)) {
    print(k.toString()); // 'print time now' will be printed
    m.value(t, k)(); //value fetched is the function ()=>print(t)
  }
  //check the number of properties stored in the context of t on m.
  print(m.get_length(t));
  //now destroying all keys, values by destroying the context t
  t = null;
  //creating a partial copy of the AdvancedWeakmap m
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
 // copying only 'key two' to the new AdvancedWeakmap
  var m2 = new AdvancedWeakmap();
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
  var d = new Dynamism();
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
  d.on(m).add_method('sleep',(){
    return 'you may sleep more than you wish for once the time comes ';
  });
  String msg = d.on(m).sleep();
  print(msg);

//should throw an error. as on(m) returns a pseudo temporal only object
//  wrapper.bye('catty',0); 

}
</code></pre>
