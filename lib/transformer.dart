// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'package:barback/barback.dart';
import 'dart:async';
import 'package:mistletoe/dynamism_mutator.dart';
import 'package:path/path.dart' as Path;
import 'dart:io' show Platform, File;


class Replacer extends Transformer {
  Path.Context context;
  // A constructor named "asPlugin" is required. It can be empty, but
  // it must be present. It is how pub determines that you want this
  // class to be publicly available as a loadable transformer plugin.
  Replacer.asPlugin();

  Future<bool> isPrimary(AssetId id) async =>
      id.extension == '.dart';

  Future apply(Transform transform) async {
    if(Platform.isWindows){
      context ??= new Path.Context(style:Path.Style.windows);
    }else{
      context ??= new Path.Context(style:Path.Style.posix);
    }
    var id = transform.primaryInput.id;
    String path = id.path.toString();
    // If the asset belongs to a package,
    // id.path points to the url relative to package root.
    if(await new File(path).exists()){
      String content = await transform.primaryInput
          .readAsString();
      content = mutate_dynamism(path,code:content.toString());
      transform.addOutput(
          new Asset.fromString(id, content.toString()));
    }
//    else{
      //look for the package folder
//      path = 'packages/${id.package.toString()}/${id.path}';
//    }
  }
}
