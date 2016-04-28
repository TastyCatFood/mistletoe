// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'package:barback/barback.dart';
import 'dart:async';
import 'package:mistletoe/dynamism_mutator.dart';
import 'dart:io' show Platform, File;

//
//class Replacer extends AggregateTransformer {
//  // A constructor named "asPlugin" is required. It can be empty, but
//  // it must be present. It is how pub determines that you want this
//  // class to be publicly available as a loadable transformer plugin.
//  Replacer.asPlugin();
//  classifyPrimary(AssetId id) {
//    // Only process assets where the filename ends with "recipe.html".
//    if (!id.path.endsWith('.dart')) return null;
//    // Return the path string, minus the recipe itself.
//    // This is where the output asset will be written.
//    return Path.url.dirname(id.path);
//  }
//
//  Future<bool> isPrimary(AssetId id) async =>
//      id.extension == '.dart';
//
//  Future apply(AggregateTransform transform) async {
//    List<Asset> assets = await transform.primaryInputs.toList();
//
//    for(Asset asset in assets){
//      var id = asset.id;
//      String path = id.path.toString();
//      // If the asset belongs to a package,
//      // id.path points to the url relative to package root.
//      if(await new File(path).exists()){
//        print('transforming file: $path');
//        String content = await asset.readAsString();
//        mutate_dynamism(path,code:content).then((String c){
//          print('transformed file: $path result:$c');
////          transform.addOutput(new Asset.fromString(id, c));
//        });
//
//      }else{
//        String content = await asset.readAsString();
//        transform.addOutput(new Asset.fromString(id, content.toString()));
//        //look for the package folder
////      path = 'packages/${id.package.toString()}/${id.path}';
//      }
//    }
//  }
//}

class Replacer extends Transformer {
  Replacer.asPlugin();

  Future<bool> isPrimary(AssetId id) async => id.extension == '.dart';

  Future apply(Transform transform) async {
    var input = transform.primaryInput;
    String path = input.id.path.toString();
    if(await new File(path).exists()) {
      print('mistletoe transformer transforming file: $path');
      var content = await input.readAsString();
      var newContent = await mutate_dynamism(path,code:content);
      transform.addOutput(new Asset.fromString(input.id, newContent));
    } else{
      var content = await input.readAsString();
      transform.addOutput(new Asset.fromString(input.id, content));
    }
  }
}











