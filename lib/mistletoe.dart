library mistletoe;

//async is used by DynamicWrapper to ensure
//DynamicWrapper objects get deleted and
//does not create strong reference.
//maybe not necessary but to be on the safe side.
part 'dynamism.dart';

///A Weakmap variant. Expando on steroids.
///The lifespan of keys and values, provided
///there are no external references to them,
///depends on the lifespan of the context object.
///
///Mistletoe is a parasitic plant.
///Likewise, Mistletoe instance
///attaches objects on an existing
///object.
///
/// e.g.
///
///     var m = new Mistletoe();
///     var o = new Object();
///
///     //o is a context object
///     m.add(o,'hi',()=>print('hi'));
///     var key = new Object();
///     m.add(o,key,100);
///
///     //()=>print('hi'); gets called
///     m.value(o,'hi')();
///
///     //prints 100
///     print(m.value(o,key));
///
///     o = null
///     //now no reference to 'hi' and ()=>print('hi')
///     //should exist in m as the context is garbage
///     //collected.
///
class Mistletoe{
  Expando _map = new Expando();
  ///Keys and values should be garbage collected
  ///once their context object is garbage collected.
  /// e.g.
  ///
  ///     var m = new Mistletoe();
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

  ///Returns keys that can be used on
  ///the context to fetch values stored
  ///in this Mistletoe instance.
  Iterable keys(var context) => _map[context]?.keys;

  ///returns the value associated with
  ///the key on the context. If either
  ///no context or key is found, returns
  ///null.
  ///
  /// e.g.
  ///
  ///     var m = new Mistletoe();
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
  ///Creates a partial or full clone.
  ///
  ///The cloned contains keys and
  ///values associated with the
  ///provided contexts only.
  ///
  ///Deleting the original does not
  ///affect the copy.
  Mistletoe selective_clone(List contexts){
    var newMap = new Mistletoe();
    for(var c in contexts) {
      newMap._map[c] = {};
      newMap._map[c].addAll(_map[c]);
//        for (var k in keys(c)) {
//          newMap.add(c, k, value(c, k));
//        }
    }
    return newMap;
  }
  ///Returns a LinkedHashMap.
  ///
  ///{key:value}
  ///
  ///Removes the key value set
  ///stored on the context
  ///from this instance of
  ///Mistletoe.
  ///
  Map pop(context,key){
    var v = _map[context][key];
    _map[context].remove(key);
    return {key:v};
  }

  ///Removes the key value set
  ///stored on the context
  ///from this instance of
  ///Mistletoe.
  void remove(context,key){
    _map[context].remove(key);
  }
  int length(context){
    var v = _map[context]?.length;
    v ??= 0;
    return v;
  }
}

