import 'package:mutator/mutator.dart';

const String klass_name = 'Dynamism';
//todo consider changing pattern to a functor.
const String pattern =
    '^[a-z\\.A-Z_0-9]+\\.on\\'
    '(.+\\)\\.[a-z\\.A-Z_0-9]+';

/// The functors below are to make sure
/// both extract* for tests and mutator_dynamism
/// share the majority of code.
/// todo evaluate the overhead of using these functors.
var  propertyAccessReplacer =
  new PropertyAccessReplacer();

var methodInvocationReplacer =
  new MethodInvocationReplacer();

var assignmentExpressionReplacer =
  new AssignmentExpressionReplacer();

///A function for dynamism_mutator_basic_test.
extract_assignment_nodes(file_path){
  List nodes = [];
  var replacer = new AssignmentExpressionReplacer(
      filter:(AstNode e){
        nodes.add(e.toString());
        return e;
      }
  );
  var m = new Mutator<AssignmentExpression>(
      klass_name, pattern,replacer);
  m.mutate_t(file_path);
  return nodes;
}


///A function for dynamism_mutator_basic_test.
List<String> extract_property_access_nodes(file_path){
  var nodes = [];
  var replacer = new PropertyAccessReplacer(
      filter:(AstNode e){
        nodes.add(e.toString());
        return e;
      });
  var m = new Mutator<PropertyAccess>(
      klass_name, pattern,replacer );
  m.mutate_t(file_path);
  return nodes;
}

///A function for dynamism_mutator_basic_test.
List<String> extract_method_invocation_nodes(file_path){
  List<String> nodes = [];
  var methodInvocationReplacer =
      new MethodInvocationReplacer(filter:(e){
        nodes.add(e.toString());
        return e;
      });
  var m = new Mutator<MethodInvocation>(klass_name,pattern,
    methodInvocationReplacer);
  m.mutate_t(file_path);
  return nodes;
}

///Meant to be used by mistletoe transformer.
///todo fix new Mutator<PropertyAccess>
///It fetches a child node of AssignmentExpression
///which is a PropertyAccess.
///
mutate_dynamism(String file_path,{String code}){
  //Assignment
  var m = new Mutator<AssignmentExpression>(
      klass_name, pattern,assignmentExpressionReplacer,
      required_imports: ['package:mistletoe/mistletoe.dart']);
  if(code != null){
    code = m.mutate_t(file_path,code:code);
  }else{
    code = m.mutate_t(file_path);
  }
  //PropertyAccess
  m = new Mutator<PropertyAccess>(
      klass_name,
      pattern,
      propertyAccessReplacer );
  code = m.mutate_t(file_path,code:code);
  //invocation
  m = new Mutator<MethodInvocation>(
      klass_name,pattern,methodInvocationReplacer);
  code  = m.mutate_t(file_path,code:code);
  return code;
}

class MethodInvocationReplacer {
  Function filter;
  MethodInvocationReplacer({Function filter}) {
    this.filter = filter;
  }

  call(MethodInvocation e) {
    if(filter != null)
      e = filter.call(e);
    //skip if e is an invocation of on method.
    for (var c in e.childEntities)
      if (c.toString() == 'on') return e.toString();
    List parts = split_into_base_method_args(e);
    //skip if method name is set/invoke/get
    String method_name = parts[1];
    if(method_name == 'invoke' ||
        method_name == 'set' ||
        method_name == 'get')
      return e.toString();
  //assembling parts into a method call
    return '${parts[0]}.invoke'
        '(\'${parts[1]}\',[${parts[2]}])';
  }
}

class AssignmentExpressionReplacer {
  Function filter;

  AssignmentExpressionReplacer({Function filter}) {
    this.filter = filter;
  }
  call(AstNode e) {
    if(filter != null)
      e = filter.call(e);
    String s = e.toString();
    List l = s.split('=');
    var invocation = l.removeAt(0).split('.');
    String name = invocation.removeLast().trim();
    invocation = invocation.join('.') +
        '.set(\'${name}\', ${l.join('=').trim()})';
//        print('before:${s}');
//        print('after:$invocation');
    return invocation;
  }
}
  ///filter may be used to skip some nodes or for logging.
  ///filter must take and return a AstNode
class PropertyAccessReplacer{
  Function filter;
  PropertyAccessReplacer(
    {Function filter}){
    this.filter = filter;
  }
  call(e){
    if(filter != null)
      e = filter.call(e);
    List l = e.toString().split('.');
    String property_name = l.removeLast();
    String invocation = l.join('.');
    invocation = invocation +
    '.get(\'${property_name.trim()}\')';
//        print('before:${e.toString()}');
//        print('after:$invocation');
    return invocation;
  }
}

/// Returns [invocation_base, method_name, args]
/// Given a node `d.on(e).hi(a,f(),c)`.
/// args: `a,f(),c`
/// invocation_base:d.on(e)
/// method_name:hi
List<String> split_into_base_method_args(AstNode n){
  List r = new List(3);
  String method_name;
  String s = n.toString();
  String args;
  for(var c in n.childEntities){
    if(c is! ArgumentList) continue;
    args = c.toString();
    //skip if c is an argument of on method.
    method_name = s.substring(
      0,s.length - args.length);
    method_name = method_name.substring(
        method_name.lastIndexOf('.')+1,
        method_name.length );
    if(method_name != 'on') break;
  }
  if(args == ''){
    method_name = s.substring(
        method_name.lastIndexOf('.')+1,
        method_name.length );
  }
  int arg_name_len= args.length +
          method_name.length +1;
  r[0] = s.substring(
      0,s.length -  arg_name_len).trim();
  r[1] = method_name.trim();
  r[2] = args.substring(1,args.length-1).trim();
  return r;
}
