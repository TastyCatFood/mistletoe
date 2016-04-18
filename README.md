# Mistletoe and Dynamism
A Weakmap variant. Expando on steroids. 



-  Has keys method
        
        
        import 'package:mistletoe/mistletoe.dart';
        void main(){
            var m = new Mistletoe();
            var t = new DateTime.now();
            m.add( t, 'hi', 'bye');
            print(m.keys(t));//prints 'hi'
            print(m.value(t,'hi'));//prints bye; 
            t = null;
            //With t garbage collected, m is empty now.
        }
        
-  Supports pseudo dynamic addition of properties

        import 'package:mistletoe/mistletoe.dart';
        Dynamism d = new Dynamism(expert:true);
        void main(){
            var o = new Object();
            d.on(o).set('greetings',()=>print('hello world'));
            d.on(o).methods(); //returns ['greetings']
            d.on(o).invoke('greetings');//prints hello world
            o = null;
            //With o garbage collected, d is empty now. 
        }
    
    
Mistletoes or the group of plants in the genus Viscum are parasitic and grow on another tree.
Likewise, Mistletoe attaches objects on an existing object and those attached objects, provided there are no external references to them, share the lifespan with the host object.

## Known Issue

-  When `minify:true`, assigning properties with `=` breaks code. 
    
        import 'package:mistletoe/mistletoe.dart';
        Dynamism d = new Dynamism(expert:true);
        void main(){
            var o = new Object();
            d.on(o).greetings = ()=>print('hello world');
            d.on(o).greetings();//prints hello world
        }
    
There is no known easy fix. I'm currently planning to write a transformer that converts `d.on(e).greetings = 'hi'` to `do.on(o).set('greetings','hi')` before dart2js compiles the code.

## Changes in v1.0.0
-  Redundant methods removed.  
-  Some methods renamed.
   

## Status
Currently looking for brave testers 

pub: https://pub.dartlang.org/packages/mistletoe    
home: https://github.com/TastyCatFood/mistletoe

# Warning!

Never do:

    var o = new Object();
    d.on(o).set('greetings',()=>print('hello world'));
    var strong_reference = d.on(o);

Do:

    var o = new Object();
    d.on(o).set('greetings',()=>print('hello world'));
    d.on(o).invoke('greetings');//prints hello world
      
[on] method returns a DynamicWrapper which contains a strong reference; in the case above, to the object o. If stored unused, it prevents the garbage collection of the referent. Once used, the strong reference is destroyed.

      //contains a strong reference  
      strong_reference.invoke('greetings');
      //now the strong reference in strong_reference is removed


# Pros and Cons

Pros:

-  Small  
The following code is 5.9KB when sent to dartium, 13.7KB on chrome with `minify:true`.  

        import 'package:mistletoe/mistletoe.dart';
        var d  = new Dynamism(expert:true);
        void main(){
         var e = new Object();
         d.on(e).set('greetings', 'hi from mistletoe');
         print(d.on(e).get('greetings'));
        }
 
-  Simple enough to read and tinker
-  Does not depend on external packages
-  Strings are unaffected by name mangling. Get them via [properties]
-  Unlikely to break. Drastic changes in Expando and Map are unlikely.
-  Does not modify your existing classes or objects.

Cons:

-  Without `=` operator, not very readable
-  No access to private members


# Sample code:

    import 'package:mistletoe/mistletoe.dart';
    // Sample code for demonstrating an application of Mistletoe.
    void main(){
      var m = new Mistletoe();
      var t = new DateTime.now();

      // Both 'print time now' and ()=>print(t))
      // should be garbage collected once t is
      // garbage collected.
      m.add( t, 'print time now', () =>print(t));
      m.add( t, 'time to go', 'no');

      // Getting keys stored in m on the the context t.
      print(m.keys(t)); //prints (print time now, time to go)

      // Getting the values
      for (var k in m.keys(t)) {
        // 'print time now' will be printed
        print(k.toString());
        var p = m.value(t, k);
        if(p is Function){
          //()=>print(t) is invoked
          print(p());
        }else{
          print(p); //prints no
        }
      }
      //How many keys on the context t?
      print(m.length(t));

      // Destroying the context t.
      // All keys, values in m stored on
      // the context t should be garbage
      // collected now.
      t = null;

      //copying
      t = new Object();
      m.add(t, 'key one', ()=>print('key one will not be copied'));
      m.add(t, 'key two', ()=>print('key two copied'));

      var m2 = new Mistletoe();
      for (var k in m.keys(t)){
        if(k.toString().contains('key two')){
          m2.add(t,k,m.value(t,k));
        }
      }
      //Only key two copied
      print('The new Mistletoe m2 only has:');
      for(var k in m2.keys(t)) {
        m2.value(t,k)();
      }

      print('=== Dynamism====');
      var d = new Dynamism(expert:true);
      d.on(t).set('t','fetched from a dynamically set property t');
      print(d.on(t).get('t'));
      d.on(t).set('t','I am the value of t now');
      print(d.on(t).get('t'));

      // Adding and calling a function
      d.on(t).set('time_now',
          (){ print('current time is: ${new DateTime.now()}');});
      d.on(t).invoke('time_now');

      // Viewing added properties and functions
      print('properties added on t in d: ${d.on(t).properties()}');
      print('methods added on t in d: ${d.on(t).methods()}');

      // passing parameters a function
      d.on(m).set('age_check',(name, age){
        print('Hi, I am a ${name}, ${age} years old.');
      });
      d.on(m).invoke('age_check',['dog',5]);

      // Never do the below.
      // The method [on] returns  a DynamicWrapper
      // instance which  contains a strong reference.
      var wrapper = d.on(m);
      // Using as in the below remove the strong
      // reference to allow garbage collection.
      wrapper.age_check('owl',0);

      // An attempt to reuse a DynamicWrapper
      // throws throws an error.
      //wrapper.bye('owl',0);

      //Have a function return something
      d.on(m).set('let_me_sleep',(){ return 'sleep later'; });
      String msg = d.on(m).invoke('let_me_sleep');
      print('The function let_me_sleep returned this string: ${msg}');

      //The bellow currently breaks when `minify:true`
      d.on(t).time_now = (){ print('current time is: ${new DateTime.now()}');};
      d.on(t).time_now();
    }
