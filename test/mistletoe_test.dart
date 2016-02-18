// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library mistletoe.test;

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

    test('mistletoe.keys() and value() '
        'returns null if context has nothing',
        (){
      var t = new DateTime.now();
      var o2 = new Object();
      m.add( o, 'time now', () =>t.toString());
      expect(m.keys(o).toList()[0],equals('time now'));
      expect(m.keys(o2),isNull);
      expect(m.value(o2,t),isNull);
    });

    test('mistletoe.value returns null '
        'if key does not exist',
        (){
      var t = new DateTime.now();
      m.add( o, 'time now', 5);
      expect(m.keys(o).toList()[0],isNotNull);
      expect(m.value(o,'time now'),isNotNull);
      expect(m.value(o,t),isNull);
    });

    test('access values',(){
      var t = new DateTime.now();
      var o2 = new Object();
      m.add( o, 'time now', o2);
      m.add( o, t, () =>5);
      expect(m.value(o,'time now'),equals(o2));
      expect(m.value(o,t)(),equals(5));
    });
    test('Mistletoe partial copy and length',(){
      var t = new DateTime.now();
      var o2 = new Object();
      m.add( o, 'time now', o2);
      m.add( o2, t, () =>5);
      var m2 = m.selective_clone([o2]);
      expect(m.length(o),equals(1));
      expect(m2.length(o),equals(0));
      expect(m2.length(o2),equals(1));
      expect(m2.value(o2,t)(),equals(5));
    });

    test('Mistletoe selective_clone is not '
        'affected by the changes in the '
        'original mistletoe instance',(){
      var t = new DateTime.now();
      var o2 = new Object();
      m.add( o, 'time now', o2);
      m.add( o2, t, () =>5);
      var m2 = m.selective_clone([o2]);
      m.remove(o2,t);
      m.remove(o,'time now');

      expect(m.length(o),equals(0));
      expect(m.length(o2),equals(0));

      expect(m2.length(o),equals(0));
      expect(m2.length(o2),equals(1));
      expect(m2.value(o2,t)(),equals(5));

      m = null;
      expect(m2.length(o),equals(0));
      expect(m2.length(o2),equals(1));
      expect(m2.value(o2,t)(),equals(5));
    });

    test('dynamic method addition and calls',(){
      m = new Object();
      var d = new Dynamism(expert:true);
      d.add_property(m,'hi',(){return 'hi';});
      expect(d.invoke(m,'hi',[]),equals('hi'));
      d.add_property(m,'your_name_please',(name){return 'hi $name';});
      expect(d.invoke(m,'your_name_please',['owl']),equals('hi owl'));
    });

    test('dynamic wrapper method addition and calls',(){
      m = new Object();
      var d = new Dynamism(expert:true);
      d.on(m).add_property('ask_age',(name,age){
        return 'hi ${name}, are you really $age?';
      });
      expect(d.on(m).methods(),equals(['ask_age']));
      expect(d.on(m).ask_age('doggy',5),
        equals('hi doggy, are you really 5?'));
      var wrapper = d.on(m);
      expect(wrapper.ask_age('owl',0),
          equals('hi owl, are you really 0?'));
//      expect(wrapper.ask_age('owl',0),throwsA(StateError));
    });
    test('dynamic wrapper property addition, '
        ' getter and setter',(){
      var t = new Object();
      var dy = new Dynamism(expert:true);
      dy.on(t).add_property('te','hi');
      expect(dy.on(t).te,equals('hi'));
      dy.on(t).te = 'changed from hi to bye';
      expect(dy.on(t).te,equals('changed from hi to bye'));
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
    test('Dynamic::get_property_value',(){
      var dy = new Dynamism(expert:true);
      dy.add_property(o,'te','hi');
      expect(dy.get_property_value(o,'te'),
          equals('hi'));
    });

    test('Dynamic::methods',(){
      var dy = new Dynamism(expert:true);
      dy.add_property(o,'te','hi');
      dy.add_property(o,'strong',()=>'I am');
      dy.add_property(o,'weak',()=>'maybe');
      expect(dy.methods(o),equals(['strong','weak']));
    });

  });

}
