// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library super_expando.test;

import '../lib/super_expando.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    var o;
    var m;
    m = new AdvancedWeakmap();
    o = new DateTime.now();
//    setUp(() {
//      m = new AdvancedWeakmap();
//      o = new DateTime.now();
//    });

//    test('First Test', () {
//      expect(awesome.isAwesome, isTrue);
//    });

    //associating key and value on the context of t
    // both key and value should be garbage collected when t is garbage collected
    m.add(
        o,
        'print time now',
        () =>print(o));


//fetching all the keys than can be used to fetch values in the context of t
    for (var k in m.keys(o)) {
      print(k.toString()); // 'print time now' will be printed
      m.value(o, k)(); //value fetched is the function ()=>print(t)
    }
    //now destroying all keys, values by destroying the context t
    o = null;

//creating a partial copy of the AdvancedWeakmap m
    print('==copying partially(only '
        'key two and its associates copied)==');
    //adding new key value pairs to now empty m
    o = new DateTime.now();
    m.add(o, 'key one', () {
      print('key one used to fetch this:'+o.toString());
    });
    m.add(o, 'key two', () {
      print('key two used to fetch this'+o.toString());
    });
    // copying only 'key two' to the new AdvancedWeakmap
    var m2 = new AdvancedWeakmap();
    for (var k in m.keys(o)){
      if(k.toString().contains('key two')){
        m2.add(o,k,m.value(o,k));
      }
    }
    //using the copied key value pair
    for(var k in m2.keys(o)) {
      print(k.toString());
      m2.value(o,k)();
    }


//dynamic property sim ugly but safe
    m = new Object();
    print('=====dynamic property sim====');
    var d = new Dynamism();
    d.add_method(m,'hi',(){print('dynamically added hi');});
    d.invoke((){m.hi();},m);



// improved, but the return value of on call
    // now contains a strong reference to the key.
    // var strongReferenceTo_m = d.on(m);
    // potentially dangerous.
    d.on(m).add_method('bye',(name,age){
      print("dynamically added bye \n ${name}, "
          'Your age is ${age}, you are not '
          'allowed to drink legally');
    });
    //get all added methods
    print(d.on(m).methods());
    d.on(m).bye('doggy',5);
    var wrapper = d.on(m);//doing this is create a strong reference and dangerous
    wrapper.bye('catty',0);
//    wrapper.bye('catty',0); //should throw an error as the object the on method returns only can be called once.
  });
}
