import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../../../generate/gen/assets.gen.dart';

//缓存封面图片
ImageProvider buildCacheCoverImage(
  final String? coverPath,
  final String? coverUrl,
) {
  if (coverPath != null) {
    return FileImage(File(coverPath));
  } else if (coverUrl != null) {
    return NetworkImage(coverUrl);
  } else {
    return AssetImage(Assets.icons.appLogo.path);
  }
}
