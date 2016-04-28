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
            //With t garbage collected, m is now empty.
        }
        
-  Supports pseudo dynamic addition of properties

        import 'package:mistletoe/mistletoe.dart';
        Dynamism d = new Dynamism(expert:true);
        void main(){
            var o = new Object();
            d.on(o).set('greetings',()=>print('hello world'));
            d.on(o).methods(); //returns ['greetings']
            d.on(o).invoke('greetings');//prints hello world

            //Or with the use of the mistletoe transformer or if the code is not compiled into javascript.
            d.on(o).greetings = ()=>print('hello world');
            d.on(o).greetings();//prints hello world
            o = null;
            //With o garbage collected, d is empty now. 
        }
    
    
Mistletoes or the group of plants in the genus Viscum are parasitic and grow on another tree.
Likewise, Mistletoe attaches objects on an existing object and those attached objects, provided there are no external references to them, share the lifespan with the host object.

## Known Issue
#### Presence of orphaned part file crashes mistletoe transformer( irrelevant if no mistletoe transformer is used)
When mistletoe transformer is used, the transformation of a part file
is queued as a completer if such is requested before the transformation
of the main library file. When a part file is orphaned and it has
no main library file, the queued completer never completes.

#### When `minify:true` is set, assigning properties with `=` or calling a dynamically added method breaks the code.

    
        import 'package:mistletoe/mistletoe.dart';
        Dynamism d = new Dynamism(expert:true);
        void main(){
            var o = new Object();
            // Does not work
            d.on(o).greetings = ()=>print('hello world');
            d.on(o).greetings();//prints hello world
        }
#### Solution
   Use the mistletoe transformer, add `- mistletoe` to pubspec.yaml as below:

        transformers:
        - mistletoe

   Transformer adds the following compile time dependencies:

          mutator: '>=0.0.4'
          barback: '>=0.15.2+7'

#### Limitations of the transformer

   The transformer relies on: https://github.com/TastyCatFood/mutator and shares its limitations.
   +  Cannot refactor dynamically typed objects:

            f(d,e){
                //The type of d is not known, so mistletoe transformer cannot handle the below.
                return d.on(e).hi();
            }

        Do:

            if(d is Dynamism){
                d = d as dynamism;
                return d.on(e).hi();
            }
            //Or
            f(Dynamism d,e)=>d.on(e).hi();

   +   Cannot be chained or nested:

            var d = new Dynamism(expert:true);
            var e = new Object();
            d.on(e).dyna = new Dynamism(expert:true);
            //mistletoe transformer cannot guess the type of dyna
            d.on(e).dyna.on(d).hi = 'hi';

   +  Function's return value type is currently ignored:

            var dyna = new Dynamism(expert:true);
            Dynamism f()=> dyna;
            main(){
                var d = f();// mistletoe transformer fails to detect type of d.
                var o = new Object();
                d.on(o).hi = 'hi';// refactoring fails.
                f().on(o).hi = 'hi' //refactoring fails.
            }

        Do: `Dynamism d = f();` and never do `f().on(o).hi = 'hi'`.



## Changes in v1.0.0
-  Redundant methods removed.  
-  Some methods renamed.
## Changes in v1.0.1
-  Transformer added.
   

## Status
Have not been exhaustively tested. Transformer is not fail safe.
pub: https://pub.dartlang.org/packages/mistletoe
home: https://github.com/TastyCatFood/mistletoe


# Warning!

Never do:

    var o = new Object();
    d.on(o).set('greetings',()=>print('hello world'));
    var strong_reference = d.on(o);// bad

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
-  Simple enough to read and tinker
-  Does not depend on external packages on run time.
-  Strings are unaffected by name mangling. Get them via [properties]
-  Unlikely to break. Drastic changes in either Expando or Map is unlikely.
-  Does not modify your existing classes or objects.

Cons:

-  Without assignment operator `=` support,  code can be unreable.
-  Transformer has its limitations.
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

      //The bellow currently breaks when `minify:true` without the use of mistletoe transformer.
      d.on(t).time_now = (){ print('current time is: ${new DateTime.now()}');};
      d.on(t).time_now();
    }
