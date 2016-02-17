part of mistletoe;
/// Adds properties and methods to objects.
///
///
///     var d = new Dynamism(expert:true);
///     var o = new Object();
///     d.on(o).add('say_hi',()=>print('hi you'));
///     d.on(o).say_hi();//prints: hi you
///     o = null;//removes everything
///
class Dynamism {
  ///var d = new Dynamism(expert:true); to use.
  ///
  /// Never do:
  ///
  ///     var d = new Dynamism(expert:true);
  ///     var o = new Object();
  ///     d.on(o).add('say_hi',()=>print('hi you'));
  ///     var strong_reference = d.on(o);
  ///     //Never store the variable
  ///     //strong_reference without using
  ///
  /// [on] method returns a [DynamicWrapper]
  /// instance which contains a strong
  /// reference to o. Once used it destroys
  /// itself, but when stored unused, it keeps
  /// the object o alive as a strong reference.
  ///
  /// Do:
  ///
  ///     var d = new Dynamism(expert:true);
  ///     var o = new Object();
  ///     d.on(o).add('say_hi',()=>print('hi you'));
  ///     d.on(o).say_hay();
  ///
  Dynamism({bool expert:false}){
    if(!expert){
      String msg = '[on] method returns a'
          ' DynamicWrapper which is meant '
          'to be used as a temporal; binding '
          'an instance of DynamicWrapper to '
          'a variable and never using it '
          'creats a zombie objectPlease '
          'that will not be garbage collected.'
          ' Please read the documentation first';
      throw msg;
    }
  }
  Mistletoe _am = new Mistletoe();
  ///Adds a dynamic property to
  ///an existing object.
  ///e.g.
  ///
  ///     var d = new Dynamism(expert:true);
  ///     var o = new Object();
  ///     d.on(o).add('say_hi',()=>print('hi you'));
  ///     d.on(o).say_hi();//prints: hi you
  ///     o = null;//removes everything
  ///
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
  ///     var d = new Dynamism(expert:true);
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

  ///Returns a DynamicWrapper instance.
  ///Usage: adding or calling a dynamic
  ///property.
  ///
  ///The return value object of this
  ///method should be used only as a
  ///temporal object
  ///e.g.
  ///
  ///     var d = new Dynamism(expert:true);
  ///     var o = new Object();
  ///     d.on(o).add('say_hi',()=>print('hi you'));
  ///     d.on(o).say_hi();//prints: hi you
  ///     o = null;//removes everything
  ///
  ///Pitfall:
  ///
  /// Never do:
  ///
  ///     var d = new Dynamism(expert:true);
  ///     var o = new Object();
  ///     d.on(o).add('say_hi',()=>print('hi you'));
  ///     var strong_reference = d.on(o);
  ///     //never store the variable
  ///     //strong_reference without using
  ///
  /// [on] method returns a dynamic wrapper
  /// which contains a strong reference to o.
  /// Once used it destroys itself, but when stored
  /// unused, tt keeps the object o alive as a strong
  /// reference.
  ///
  /// Do:
  ///
  ///     var d = new Dynamism(expert:true);
  ///     var o = new Object();
  ///     d.on(o).add('say_hi',()=>print('hi you'));
  ///     d.on(o).say_hay();
  ///
  ///
  DynamicWrapper on(var object, {bool allow_strong_reference:false}){
    return new DynamicWrapper(
        object,_am);
  }
}
class DynamicWrapper{
  var _key_object;
  bool _destroyed = false;
  Mistletoe _awm;
  DynamicWrapper(
      this._key_object,
      this._awm
      ){ }
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
      String msg = 'DynamicWrapper reused error: '
          'Dynamism_instance.on(object) must be '
          'used as a temporal object';
      throw new StateError(msg);
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
      case 8:
        return _call8(f,args);
      case 9:
        return _call9(f,args);
      case 10:
        return _call10(f,args);
      case 11:
        return _call11(f,args);
    }
    String msg = 'DynamicWrapper '
        'only supports up to 11 parameters';
    throw new ArgumentError(msg);
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
  _call8(Function f,List l){
    var one=l[0], two=l[1], three =l[2]
    ,four =l[3],five = l[4],six=l[5],seven=l[6],
    p8=l[7];
    var r = f(one,two,three,four,five,six,seven,p8);
    _destroy();
    return r;
  }
  _call9(Function f,List l){
    var one=l[0], two=l[1], three =l[2]
    ,four =l[3],five = l[4],six=l[5],seven=l[6],
        p8=l[7],p9=l[8];
    var r = f(one,two,three,four,five,six,seven,p8,p9);
    _destroy();
    return r;
  }
  _call10(Function f,List l){
    var one=l[0], two=l[1], three =l[2]
    ,four =l[3],five = l[4],six=l[5],seven=l[6],
        p8=l[7],p9=l[8],p10=l[9];
    var r = f(one,two,three,four,five,six,
        seven,p8,p9,p10);
    _destroy();
    return r;
  }
  _call11(Function f,List l){
    var one=l[0], two=l[1], three =l[2]
    ,four =l[3],five = l[4],six=l[5],seven=l[6],
        p8=l[7],p9=l[8],p10=l[9],p11=l[10];
    var r = f(one,two,three,four,five,six,
        seven,p8,p9,p10,p11);
    _destroy();
    return r;
  }
}
