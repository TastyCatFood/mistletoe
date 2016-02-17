part of mistletoe;
/// Add properties and methods to objects.
///
///
///     var d = new Dynamism();
///     var o = new Object();
///     d.on(o).add('say_hi',()=>print('hi you'));
///     d.on(o).say_hi();//prints: hi you
///     o = null;//removes everything
class Dynamism {
  Mistletoe _am = new Mistletoe();
  ///Adds a dynamic property to
  ///an existing object.
  ///e.g.
  ///
  ///     var d = new Dynamism();
  ///     var o = new Object();
  ///     d.on(o).add('say_hi',()=>print('hi you'));
  ///     d.on(o).say_hi();//prints: hi you
  ///     o = null;//removes everything
  add_method(
      var targetObject,
      String methodName,
      var newMethod){
    _am.add( targetObject, methodName,
        newMethod);
  }
  ///Invokes a dynamically added method.
  ///Unlike the [on] method, invoke takes
  ///the method name as a string, arguments
  ///as a list.
  ///
  /// e.g.
  ///
  ///     var d = new Dynamism();
  ///     var o = new Object();
  ///     d.on(o).add('say_hi',()=>print('hi you'));
  ///     d.invoke(o,'say_hi');
  ///
  dynamic invoke(var object, String method,
      [List args=null]) {
    Function f = _am.value(object,method);
    args ??= [];
    return on(object).call(f,args);
  }

  ///Returns DynamicWrapper instance.
  ///Usage: adding or calling a dynamic
  ///property.
  ///
  ///The return value object of this
  ///method should be used only as a
  ///temporal object
  ///e.g.
  ///
  ///     var d = new Dynamism();
  ///     var o = new Object();
  ///     d.on(o).add('say_hi',()=>print('hi you'));
  ///     d.on(o).say_hi();//prints: hi you
  ///     o = null;//removes everything
  ///
  ///Pitfall:
  ///
  ///     var strong_reference =
  ///     d.on(o, allow_strong_reference:true);
  ///
  ///The above creates a strong reference
  ///
  ///     var later_created_reference = d.on(o);
  ///
  ///The above creates a Future that deletes strong
  ///references in the DynamicWrapper instance
  DynamicWrapper on(var object, {bool allow_strong_reference:false}){
    return new DynamicWrapper(
        object,_am,allow_strong_reference);
  }
}
class DynamicWrapper{
  var _key_object;
  bool _destroyed = false;
  Mistletoe _awm;
  DynamicWrapper(
      this._key_object,
      this._awm,
      [bool allow_strong_reference=false]
      ){
    //todo consult someone if allow_strong_reference is worth the trouble
    if(!allow_strong_reference)
      new Future((){this._destroy();});
  }
  add_method(
      String methodName,
      var newMethod){
    _awm.add(
        _key_object,
        methodName,
        newMethod);
    _destroy();
  }
  List<String> methods(){
    List keys = [];
    for(var k in _awm.keys(_key_object))
      keys.add(k.toString());
    return keys;
  }
  _destroy(){
    _key_object = null;
    _awm = null;
    _destroyed = true;
  }
  noSuchMethod(Invocation invocation) {
    if(_destroyed){
      throw 'DynamicWrapper reused error: '
          'Dynamism_instance.on(object) must be '
          'used as a temporal object';
    }
    Symbol methodSymbol = invocation.memberName;
    List args = invocation.positionalArguments;
    Function f;
    for(String k in _awm.keys(_key_object)){
      Symbol s = new Symbol(k);
      if(s == methodSymbol){
        f = _awm.value(_key_object,k);
        break;
      }
    }
    if(f == null) super.noSuchMethod(invocation);
    return call(f,args);
  }
  call(Function f, List args){
    switch(args.length){
      case 0:
        var r = f();
        _destroy();
        return r;
      case 1:
        return _call1(f,args);
      case 2:
        return _call2(f,args);
      case 3:
        return _call3(f,args);
      case 4:
        return _call4(f,args);
      case 5:
        return _call5(f,args);
      case 6:
        return _call6(f,args);
      case 7:
        return _call7(f,args);
    }
    throw 'DynamicWrapper only supports up to 7 parameters';
  }
  _call1(Function f,List l){
    var one=l[0];
    var r = f(one);
    _destroy();
    return r;
  }
  _call2(Function f,List l){
    var one=l[0],two=l[1];
    var r = f(one,two);
    _destroy();
    return r;
  }
  _call3(Function f, List l){
    var one=l[0], two=l[1],
        three =l[2];
    var r = f(one,two,three);
    _destroy();
    return r;
  }
  _call4(Function f,List l){
    var one=l[0], two=l[1],
        three =l[2],four =l[3];
    var r = f(one,two,three,four);
    _destroy();
    return r;
  }
  _call5(Function f,List l){
    var one=l[0], two=l[1], three =l[2]
    ,four =l[3],five = l[4];
    var r = f(one,two,three,four,five);
    _destroy();
    return r;
  }
  _call6(Function f,List l){
    var one=l[0], two=l[1], three =l[2]
    ,four =l[3],five = l[4],six =l[5];
    var r = f(one,two,three,four,five,six);
    _destroy();
    return r;
  }
  _call7(Function f,List l){
    var one=l[0], two=l[1], three =l[2]
    ,four =l[3],five = l[4],six=l[5],seven=l[6];
    var r = f(one,two,three,four,five,six,seven);
    _destroy();
    return r;
  }
}
