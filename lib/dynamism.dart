part of mistletoe;
/// Store values on mistletoe using objects as keys.
///
///
///     var d = new Dynamism(expert:true);
///     var o = new Object();
///     d.on(o).set('say_hi',
///       (name)=>print('hi you $name'));
///     d.on(o).invoke('say_hi',['you']);//prints: hi you
///
///     d.on(o).set('in_good_mood', 'Yap!');
///     print(d.on(o).value('in_good_mood'));//print Yap!
///
///     d.on(o).set('in_good_mood','No') ;
///     print(d.on(o).in_good_mood);//prints no
///     o = null;//removes everything
///
///    //Due to the limitations of dart2js
///    //the following syntax does not work
///    //when dart code is compiled into
///    //javascript and minified.
///
///    //adding and setting a new property
///    d.on(o).bye = 'Not so soon';
///
///    //prints Not so soon
///    print(d.on(e).bye);
///
///
class Dynamism {
  Mistletoe _m = new Mistletoe();
  /// var d = new Dynamism(expert:true); to use.
  ///
  /// Never do:
  ///
  ///     var d = new Dynamism(expert:true);
  ///     var o = new Object();
  ///     d.on(o).set('say_hi'),()=>print('hi you'));
  ///     var strong_reference = d.on(o);
  ///
  /// [on] method returns a dynamic wrapper
  /// which contains a strong reference.
  /// Once used, the strong reference is removed
  /// to allow the garbage collection of the
  /// referent to happen.
  ///
  /// Do:
  ///
  ///     var d = new Dynamism(expert:true);
  ///     var o = new Object();
  ///     d.on(o)set('say_hi',
  ///       (name)=>print('hi $name'));
  ///     d.on(o).invoke('say_hi',[doggy]);
  ///
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
          ' Please read the readme first';
      throw msg;
    }
  }

  ///Returns a DynamicWrapper instance.
  ///Usage: setting, getting or invoking
  ///a dynamic property.
  ///
  ///The return value object of this
  ///method should be used only as a
  ///temporal object
  ///e.g.
  ///
  ///     var d = new Dynamism(expert:true);
  ///     var o = new Object();
  ///     d.on(o).set('say_hi'),(name)=>print('hi $name'));
  ///     d.on(o).invoke('say_hi',['doggy']);//prints: hi doggy
  ///     o = null;//removes everything
  ///
  ///Pitfall:
  ///
  /// Never do:
  ///
  ///     var d = new Dynamism(expert:true);
  ///     var o = new Object();
  ///     d.on(o).set('say_hi'),()=>print('hi you'));
  ///     var strong_reference = d.on(o);
  ///
  /// [on] method returns a dynamic wrapper
  /// which contains a strong reference.
  /// Once used, the strong reference is removed
  /// to allow the garbage collection of the
  /// referent to happen.
  ///
  /// Do:
  ///
  ///     var d = new Dynamism(expert:true);
  ///     var o = new Object();
  ///     d.on(o)set('say_hi',
  ///       (name)=>print('hi $name'));
  ///     d.on(o).invoke('say_hi',[doggy]);
  ///
  ///
  DynamicWrapper on(var object){
    return new DynamicWrapper(
        object,_m);
  }
}
@proxy
class DynamicWrapper{
  var _key_object;
  bool _destroyed = false;
  Mistletoe _m;
  DynamicWrapper(
      this._key_object,
      this._m
      ){ }
  ///Adds and sets a property value
  ///e.g.
  ///
  ///   var d = new Dynamism(expert:true);
  ///   var o = new Object();
  ///   d.on(o).set(
  ///     'morning_greeting', 'good morning');
  ///
  ///   //returns good morning
  ///   print(d.on(o).get('morning_greeting'));
  ///
  void set(
      String property_name,
      var value
      ){
    _m.add(
        _key_object,
        property_name,
        value );
    _destroy();
  }
  ///Fetches the value of a property
  ///e.g.
  ///
  ///   var d = new Dynamism(expert:true);
  ///   var o = new Object();
  ///   d.on(o).set('morning_greeting',
  ///     'good morning');
  ///
  ///   //returns good morning
  ///   print(d.on(o).value('morning_greeting'))
  ///
  ///If the property does not exit, returns null
  ///todo test
  dynamic get(String propertyName){
    var v = _m.value(_key_object,propertyName);
    _destroy();
    return v;
  }
  ///Returns a list of all method names;
  ///only functions.
  List<String> methods(){
    List keys = [];
    for(var k in _m.keys(_key_object))
      if(_m.value(_key_object,k) is Function)
        keys.add(k.toString());
    return keys;
  }
  ///Returns a list of all property names;
  ///functions and attributes.
  List<String> properties(){
    return _m.keys(_key_object).toList();
  }
  _destroy(){
    _key_object = null;
    _m = null;
    _destroyed = true;
  }
  ///Handles dynamic addition of properties
  ///but `minify:true` currently breaks
  ///this.
  ///todo write a transformer to solve this.
  noSuchMethod(Invocation inv) {
    if(_destroyed){
      String msg = 'DynamicWrapper reused error: '
          'Dynamism_instance.on(object) must be '
          'used as a temporal object';
      throw new StateError(msg);
    }
    //property or method name as a String
    //breaks once code gets minified.
    String pn = inv.memberName.toString();
    pn = pn.substring(8,pn.length-2);
    List args = inv.positionalArguments;
    // Handling a setter call
    if(inv.isSetter){
      pn = pn.substring( 0,pn.length-1);
      _m.add(_key_object,pn,args[0]);
      _destroy();
      return null;
    }
    //handling a getter or method call
    var p = _m.value(_key_object,pn);
    if(p == null) super.noSuchMethod(inv);
    //property
    if(p is! Function){
      _destroy();
      return p;
    }
    //function
    return call(p,args);
  }
  ///Invokes the value of a property
  ///e.g.
  ///
  ///   var d = new Dynamism(expert:true);
  ///   var o = new Object();
  ///   d.on(o).set(
  ///     'morning_greeting',
  ///     (name)=>print('good morning ${name}!'));
  ///
  ///   //prints good morning doggy!
  ///   d.on(o).invoke('morning_greeting',['doggy']);
  ///
  dynamic invoke(String methodName,
      [List args = const []]){
    Function f = _m.value(_key_object,methodName);
    if(f is! Function){
      String msg = 'A function with the name '
          '$methodName has not been set in '
          'Dynamism yet.';
      throw new ArgumentError.value(methodName,msg);
    }
    return call(f,args);
  }
  call(Function f, [List args = const []]){
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
