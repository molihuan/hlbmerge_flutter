import 'dart:io';

import 'package:tuple/tuple.dart';


import '../../../log/log.dart';
import '../../../repository/settings_repository.dart';
import '../../../utils/file_util.dart';
import '../../../utils/str_util.dart';
import '../base_export_file_server.dart';
import '../cache_data_manager.dart';
import 'model/cache_group.dart';
import 'model/cache_item.dart';
import 'package:path/path.dart' as path;

abstract class BaseMergeServer implements BaseExportFileServer {
  final _singleOutputPathChecked =
      SettingsRepository.getSingleOutputPathChecked();
  final _isExportDanmakuFile =
      SettingsRepository.getExportDanmakuFileChecked();

  Future<Tuple2<bool, String?>> mergeBefore(CacheItem item);

  void mergeAfter(CacheItem item,Tuple2<bool, String?> result,String outputPath){
    if (result.item1) {
      // 导出弹幕文件
      if (_isExportDanmakuFile) {
        final srcPath = item.danmakuPath;
        final destPath = FileUtil.changeFileExtension(outputPath, "xml");
        if (srcPath != null) {
          FileUtil.copyFile(srcPath, destPath);
        }
      }
    }
  }

  @override
  Future<Tuple2<bool, String?>> exportFileByCacheItem(
    CacheItem item,
    OutputFileMode outputFileMode,
    String? groupTitle,
  ) async {
    final prepareResult = await mergeBefore(item);
    if (!prepareResult.item1) {
      return prepareResult;
    }

    // 处理特殊字符
    final title = StrUtil.handleSpecialCharacters(item.title);
    groupTitle = StrUtil.handleSpecialCharacters(groupTitle);

    // 输出目录
    final outputDirPath = await buildOutputDirPathByGroupTitle(
      groupTitle,
      _singleOutputPathChecked,
    );
    if (outputDirPath == null) {
      return const Tuple2(false, "输出目录创建失败");
    }

    //文件名
    final String outputFileName;
    if (title == null) {
      outputFileName =
      "${DateTime.now().millisecondsSinceEpoch}.${outputFileMode.extension}";
    } else {
      outputFileName =
      "${title}.${outputFileMode.extension}";
    }

    // 输出完整路径
    String outputPath = path.join(outputDirPath, outputFileName);
    //判断输出文件是否存在,如果存在则重命名(加序号)
    outputPath = await FileUtil.getAvailableFilePath(outputPath);

    //合并文件
    final result = await finalMerge(item,outputPath);

    mergeAfter(item, result, outputPath);

    Log.e(result);

    return result;
  }

  Future<Tuple2<bool, String?>> finalMerge(CacheItem item,String outputPath);



  @override
  Future<List<Tuple2<CacheItem, String>>> exportFileByCacheGroup(
      CacheGroup cacheGroup,
      OutputFileMode outputFileMode,
      ) async {
    //错误item和错误信息列表
    final errorItemList = <Tuple2<CacheItem, String>>[];
    for (final item in cacheGroup.cacheItemList) {
      final result = await exportFileByCacheItem(
        item,
        outputFileMode,
        cacheGroup.title,
      );
      if (!result.item1) {
        errorItemList.add(Tuple2(item, result.item2 ?? "未知错误"));
      }
    }

    return errorItemList;
  }

  // 构建输出目录
  Future<String?> buildOutputDirPathByGroupTitle(
    String? groupTitle,
    bool singleOutputPathChecked,
  ) async {
    final outputRoot = await SettingsRepository.getOutputDirPath();
    if (outputRoot == null) {
      return null;
    }

    String outputDirPath;
    if (groupTitle == null || singleOutputPathChecked) {
      outputDirPath = outputRoot;
    } else {
      outputDirPath = path.join(outputRoot, groupTitle);
    }

    // 创建目录
    if (!Directory(outputDirPath).existsSync()) {
      Directory(outputDirPath).createSync(recursive: true);
    }

    return outputDirPath;
  }
}
