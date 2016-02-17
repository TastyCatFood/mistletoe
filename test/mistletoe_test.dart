// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library super_expando.test;

import '../lib/mistletoe.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    var o;
    var m;
    setUp(() {
      m = new Mistletoe();
      o = new DateTime.now();
    });

    test('adding to Mistletoe instance', () {
      expect( m.add( o, 'print time now', () =>print(o)), isNull );
      var t = new DateTime.now();
      expect( m.add( o, t, () =>print(o)), isNull );
    });

    test('fetching keys from Mistletoe instance',(){
      var t = new DateTime.now();
      m.add( o, 'time now', () =>t.toString());
      m.add( o, t, () =>print(o));
      expect( m.keys(o).toList(), isList );
      expect(m.keys(o).toList()[0],equals('time now'));
      expect(m.keys(o).toList()[1].runtimeType,equals(DateTime));
    });

    test('access values',(){
      var t = new DateTime.now();
      var o2 = new Object();
      m.add( o, 'time now', o2);
      m.add( o, t, () =>5);
      expect(m.value(o,'time now'),equals(o2));
      expect(m.value(o,t)(),equals(5));
    });
    test('partial copy and length',(){
      var t = new DateTime.now();
      var o2 = new Object();
      m.add( o, 'time now', o2);
      m.add( o2, t, () =>5);
      var m2 = m.partial_copy([o2]);
      expect(m.length(o),equals(1));
      expect(m2.length(o),equals(0));
      expect(m2.length(o2),equals(1));
      expect(m2.value(o2,t)(),equals(5));
    });

    test('dynamic',(){
      m = new Object();
      var d = new Dynamism(expert:true);
      d.add_method(m,'hi',(){return 'hi';});
      expect(d.invoke(m,'hi',[]),equals('hi'));
      d.add_method(m,'your_name_please',(name){return 'hi $name';});
      expect(d.invoke(m,'your_name_please',['owl']),equals('hi owl'));
    });

    test('dynamic wrapper',(){
      m = new Object();
      var d = new Dynamism(expert:true);
      d.on(m).add_method('ask_age',(name,age){
        return 'hi ${name}, are you really $age?';
      });
      expect(d.on(m).methods(),equals(['ask_age']));
      expect(d.on(m).ask_age('doggy',5),
        equals('hi doggy, are you really 5?'));
      var wrapper = d.on(m);
      expect(wrapper.ask_age('owl',0),
          equals('hi owl, are you really 0?'));
      //todo currently [DynamicWrapper] throws a string, do something
//      expect(wrapper.ask_age('owl',0),throwsA());
    });
    test('pop_key',(){
      var t = new DateTime.now();
      var o2 = new Object();
      m.add( o, 'time now', o2);
      m.add( o, 'over', o2);
      m.add( o2, t, () =>5);
      var key1 = m.pop(o,'time now').keys.toList()[0];
      expect(key1, equals('time now'));
      var map = m.pop(o,'over');
      expect(map.runtimeType,equals({}.runtimeType));
      expect(m.length(o),equals(0));
      expect(map['over'], equals(o2));
    });
  });

}
