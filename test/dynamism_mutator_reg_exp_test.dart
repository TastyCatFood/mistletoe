import 'package:mistletoe/dynamism_mutator.dart';
import 'package:test/test.dart';
import 'package:mutator/mutator.dart';
/// A Test on the regular expression patterns used in
/// dynamism_mutator.
///
///Maybe I should ditch regex altogether.
main(){
  group('A group of tests',(){
    simple_pattern_test();
  });
}
simple_pattern_test(){
  String src = """
    Dynamism d = new Dynamism(expert:true);
    var o_2;
    main(){
      d.on(f()).hi = 'hi';
      print(d.on(f('dummy',(){print('hi');})).hi);
      print(d.on(o_2).hi);
    }
    f(not_used,f){
      print(not_used);
      f();
      o_2 ??= new Object();
      return o_2;
    }
  """;
  test('klass_name_regex_test',(){
    List nodes = [];
    var rep =new PropertyAccessReplacer(
            filter:(e){
          // Skip if e is a child node of
          // AssignmentExpression; not needed
          // as long as AssignmentExpression
          // gets processed first.
          if(e.parent is AssignmentExpression)
            return e.toString();
          nodes.add(e.toString());
          return e;
        });
    var m = new Mutator<PropertyAccess>(
        klass_name,pattern,rep );
    m.mutate_t('',code:src,skip_type_check: true);

    var r = [
      'd.on(f(\'dummy\', () {print(\'hi\');})).hi',
      'd.on(o_2).hi'];
    for(int i =0;i<2;++i){
      expect(r[i],nodes[i]);
    }
  });
}