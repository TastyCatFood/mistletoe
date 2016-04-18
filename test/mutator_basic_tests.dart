//import 'package:mutator/mutator.dart';
//import 'package:analyzer/analyzer.dart';
//import 'package:analyzer/src/generated/ast.dart';
//import 'package:analyzer/src/generated/scanner.dart';
import 'package:path/path.dart' as Path;
import 'dart:io' show Platform, Directory,File;
import 'package:test/test.dart';
import 'package:mistletoe/dynamism_mutator.dart';

const String klass_name = 'Dynamism';
const String pattern =
    '^[a-z.A-Z_0-9]+\\.on\\'
    '([a-z.A-Z_0-9]+\\)\\.[a-z.A-Z_0-9]+';

void main() {
  group('A group of tests', () {
    //single file tests
    String path = append_to_project_dir(
        './test/mutator_targets/basic_test_target.dart');
    assignment_nodes_extraction_test(
        path, 'single file assignmenst node extraction');
    single_file_property_access_nodes_extraction_test(
        path,'single file property access '
        'node extraction');
    method_invocation_nodes_extraction_test(
        path,'single file method invocation '
        'node extraction');
    file_as_whole_final_test(path);

    //part file tests
    path = append_to_project_dir(
        './test/mutator_targets/part_file_test_target.dart' );
    library_assignment_nodes_extraction_test(
        path, 'assignmenst node extraction test'
        'for nodes defined in a part file');
    library_file_property_access_nodes_extraction_test(
        path,'property access node extraction test'
        'for nodes defined in a part file');
    method_invocation_nodes_extraction_test(
        path,'method invocation node extraction '
        'test for nodes defined in a part file');
//
//    //file import tests
    path = append_to_project_dir(
        './test/mutator_targets/'
        'file_import_test_target.dart');
    library_assignment_nodes_extraction_test(
        path, 'file assignmenst node extraction test'
        ' for nodes defined in an imported file');
    //re-using the test above as the expected
    // results are the same.
    library_file_property_access_nodes_extraction_test(
        path,'property access to nodes extraction '
        'test for nodes defined in an imported file');
    method_invocation_nodes_extraction_test(
        path,'method invocation node extraction '
        'test for nodes defined in an imported file');

    //file import test with alias
    path = append_to_project_dir(
        './test/mutator_targets/'
            'file_import_test_target_with_alias.dart');
    library_assignment_nodes_extraction_with_alias_test(
        path, 'file assignmenst node extraction test'
        ' for nodes defined in an aliased '
        'imported file');
    //re-using the test above as the expected
    // results are the same.
    library_file_property_access_nodes_extraction_with_alias_test(
        path,'property access to nodes extraction '
        'test for nodes defined in an aliased '
        'imported file');
    method_invocation_nodes_with_alias_extraction_test(
        path,'method invocation node extraction '
        'test for nodes defined in an aliased '
        'imported file');

  });
}

single_file_property_access_nodes_extraction_test(path,test_name){
  List<String> nodes = extract_property_access_nodes(
      path);
  List expected_output = [
    'p.on(p).greetings',
    'd.on(v).greetings',
    'd.on(v).greetings',
    'd.on(e).greetings',
    'd2.on(e).greetings',
    'A.d.on(e).greetings',
    'n.d.on(e).greetings'
  ];
  test(test_name,(){
    for(int i =0;i<nodes.length;++i){
      expect(expected_output[i],equals(nodes[i]));
    }
    expect(nodes.length, expected_output.length);
  });
}
library_assignment_nodes_extraction_test(path,test_name){
  List<String> nodes = extract_assignment_nodes(path);
  List<String> expected_output = [
    'd.on(e).greetings = \'hi from top level variable d\'',
    'd.on(e).f = (a, b) => a + \' \' + b',
    'd2.on(e).greetings = \'hi from locally defined \' \'top level variable d2\'',
    'd2.on(e).f = (a, b) {return a + b;}',
    'A.d.on(e).greetings = \'hi from static class member\'',
    'A.d.on(e).f = () {return \'f called on A\';}',
    'n.d.on(e).greetings = \'hi from an instance member of n\'',
    'n.d.on(e).f = (g) => g',
  ];
  if(nodes.length != expected_output.length){
    print(test_name);
    print(expected_output);
    print(nodes);
  }
  test(test_name,(){
    for(int i = 0;i<nodes.length;++i){
      expect(nodes[i],equals(expected_output[i]));
    }
    expect(nodes.length, expected_output.length);
  });
}
library_assignment_nodes_extraction_with_alias_test(path,test_name){
  List<String> nodes = extract_assignment_nodes(path);
  List<String> expected_output = [
    'p.d.on(p.e).greetings = \'hi from top level variable d\'',
    'p.d.on(p.e).f = (a, b) => a + \' \' + b',
    'p.d2.on(p.e).greetings = \'hi from locally defined \' \'top level variable d2\'',
    'p.d2.on(p.e).f = (a, b) {return a + b;}',
    'p.A.d.on(p.e).greetings = \'hi from static class member\'',
    'p.A.d.on(p.e).f = () {return \'f called on A\';}',
    'p.n.d.on(p.e).greetings = \'hi from an instance member of n\'',
    'p.n.d.on(p.e).f = (g) => g',
  ];
  if(nodes.length != expected_output.length){
    print(test_name);
    print(expected_output);
    print(nodes);
  }
  test(test_name,(){
    for(int i = 0;i<nodes.length;++i){
      expect(nodes[i],equals(expected_output[i]));
    }
    expect(nodes.length, expected_output.length);
  });
}
///When given the path to part_file_test_target.dart
///the PropertyAccess nodes extracted are only ones
///in the file.
library_file_property_access_nodes_extraction_test(path,test_name){
  List<String> nodes = extract_property_access_nodes(
      path);
  List expected_output = [
    'd.on(e).greetings',
    'd2.on(e).greetings',
    'A.d.on(e).greetings',
    'n.d.on(e).greetings'
  ];
  if(nodes.length != expected_output.length){
    print(test_name);
    print(expected_output);
    print(nodes);
  }
  test(test_name,(){
    for(int i =0;i<nodes.length;++i){
      expect(expected_output[i],equals(nodes[i]));
    }
    expect(nodes.length, expected_output.length);
  });
}
library_file_property_access_nodes_extraction_with_alias_test(path,test_name){
  List<String> nodes = extract_property_access_nodes(
      path);
  List expected_output = [
    'p.d.on(p.e).greetings',
    'p.d2.on(p.e).greetings',
    'p.A.d.on(p.e).greetings',
    'p.n.d.on(p.e).greetings'
  ];
  if(nodes.length != expected_output.length){
    print(test_name);
    print(expected_output);
    print(nodes);
  }
  test(test_name,(){
    for(int i =0;i<nodes.length;++i){
      expect(expected_output[i],equals(nodes[i]));
    }
    expect(nodes.length, expected_output.length);
  });
}

file_as_whole_final_test(path){
  String expected_result_path = append_to_project_dir(
      './test/mutator_expected_results/'
          'basic_test_expected_output.dart');

  String r = mutate_dynamism(path);
  String er = new File(expected_result_path)
      .readAsStringSync();

//    new File(wpath ).writeAsStringSync(r);
  test('Is output as expected?',(){
    expect(r,equals(er));
  });

}

method_invocation_nodes_extraction_test(path,test_name){
  List<String> nodes = extract_method_invocation_nodes(path);
  List<String> er = [
    'd.on(e).f(\'function f called on d\', \' with 2 params\')',
    'd2.on(e).f(\'d2 function f\', \' cadded\')',
    'A.d.on(e).f()',
    'n.d.on(e).f(\'instance member Dynamic d access passed\')'
  ];

  test(test_name,(){
    for(int i =0;i<nodes.length;++i){
      expect(er[i],equals(nodes[i]));
    }
  });
}
method_invocation_nodes_with_alias_extraction_test(path,test_name){
  List<String> nodes = extract_method_invocation_nodes(path);
  List<String> er = [
    'p.d.on(p.e).f(\'function f called on d\', \' with 2 params\')',
    'p.d2.on(p.e).f(\'d2 function f\', \' cadded\')',
    'p.A.d.on(p.e).f()',
    'p.n.d.on(p.e).f(\'instance member Dynamic d access passed\')'
  ];

  test(test_name,(){
    for(int i =0;i<nodes.length;++i){
      expect(er[i],equals(nodes[i]));
    }
  });
}

assignment_nodes_extraction_test(path,test_name){
  List<String> nodes = extract_assignment_nodes(path);
  List<String> expected_output = [
    'd.on(e).greetings = \'hi from top level variable d\'',
    'd.on(e).f = (a, b) => a + \' \' + b',
    'd2.on(e).greetings = \'hi from locally defined \' \'top level variable d2\'',
    'd2.on(e).f = (a, b) {return a + b;}',
    'A.d.on(e).greetings = \'hi from static class member\'',
    'A.d.on(e).f = () {return \'f called on A\';}',
    'n.d.on(e).greetings = \'hi from an instance member of n\'',
    'n.d.on(e).f = (g) => g',
    'p.on(p).greetings = \'hi from function\''
  ];
  if(nodes.length != expected_output.length){
    print(test_name);
    print(expected_output);
    print(nodes);
  }
  test(test_name,(){
    for(int i = 0;i<nodes.length;++i){
      expect(nodes[i],equals(expected_output[i]));
    }
    expect(nodes.length, expected_output.length);
  });
}


append_to_project_dir(path,[base_dir = null]){
// Fetching the project home dir
//  var cd = Path.current;

//  Changing the current directory
//  Directory original_dir = Directory.current;
//  Directory.current = dirname.toFilePath();
  Path.Context context;
  if(Platform.isWindows){
    context = new Path.Context(style:Path.Style.windows);
  }else{
    context = new Path.Context(style:Path.Style.posix);
  }
  // Fails to join when path contains a `/`
  // at the head position.
  if(path.indexOf('/')==0)
    throw '`/` at the head. Invalid '
        'relative path:${path}';
  base_dir ??= Directory.current.path;
  path = context.join(
      Path.normalize(base_dir),
      Path.normalize(path));
  return context.normalize(path);
}
