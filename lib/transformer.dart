// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'package:barback/barback.dart';
import 'dart:async';
import 'package:mistletoe/dynamism_mutator.dart';


class Replacer extends Transformer {
  // A constructor named "asPlugin" is required. It can be empty, but
  // it must be present. It is how pub determines that you want this
  // class to be publicly available as a loadable transformer plugin.
  Replacer.asPlugin();

  Future<bool> isPrimary(AssetId id) async =>
      id.extension == '.dart';

  Future apply(Transform transform) async {
    var id = transform.primaryInput.id;
    print('file_path: ${id.path}');
    print('id: ${id}');
    String content = await transform.primaryInput
        .readAsString();
    content = mutate_dynamism(
        id.path.toString(),code:content.toString());
    print('transformed content $content');
    transform.addOutput(
        new Asset.fromString(id, content.toString()));
  }
}
