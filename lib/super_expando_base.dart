library super_expando;

//async is used by DynamicWrapper to ensure
//DynamicWrapper objects get deleted and
//does not create strong reference.
//maybe not necessary but to be on the safe side.
import 'dart:async';

part 'dynamism.dart';

///A Weakmap variant
///The lifespan of keys and values
///depends on the life of context object.
class AdvancedWeakmap{
  Expando _map = new Expando();
  ///Keys and values should be garbage collected
  ///once their context object has been garbage
  ///collected.
  /// e.g.
  ///
  ///     var m = new AdvancedWeakmap();
  ///     var o = new Object();
  ///     m.add(o,'hi',()=>print('hi'));
  ///     var key = new Object();
  ///     m.add(o,key,100);
  ///     m.value(o,'hi')();
  ///     //()=>print('hi'); gets called
  ///
  ///     print(m.value(o,key));
  ///
  ///     o = null
  ///     //now no reference to 'hi' and ()=>print('hi')
  ///     //should exist in m.
  ///
  add(var context,var key, var value){
    _map[context] ??= {};
    _map[context][key] = value;
  }
  ///Returns keys that can be used with the
  ///context to fetch values stored
  ///on the context.
  //todo see if ?.toList()is needed
  keys(var context) => _map[context]?.keys;

    ///returns the value saved on the
    ///context with the key.
    ///
    /// e.g.
    ///
    ///     var m = new AdvancedWeakmap();
    ///     var o = new Object();
    ///     m.add(o,'hi',()=>print('hi'));
    ///     var key = new Object();
    ///     m.add(o,key,100);
    ///     m.value(o,'hi')();
    ///     //()=>print('hi'); gets called
    ///
    ///     print(m.value(o,key));
    ///
    ///
    value(var context, var key){
      Map m  =  _map[context];
      m ??= {};
      return m[key];
    }
    ///copy values and keys associated
    ///with the context to a new
    ///AdvancedWeakmap.
    ///Deleting the original should not
    ///affect the copy
    partial_copy(var context){
      var newMap = new AdvancedWeakmap();
      for(var k in keys(context))
        newMap.add(context,k,value(context,k));
      return newMap;
    }
    dynamic pop_key(context,key){
      var k = _map[context][key];
      _map[context].remove(key);
      return k;
    }
    int get_length(context)=>_map[context].length;
}

