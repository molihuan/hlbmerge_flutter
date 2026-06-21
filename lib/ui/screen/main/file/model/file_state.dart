import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'file_state.freezed.dart';

@freezed
abstract class FileState with _$FileState {
  const FileState._();

  const factory FileState({
    @Default([]) List<FileSystemEntity> outputFileList,
    String? errMsg,
  }) = _FileState;
}
