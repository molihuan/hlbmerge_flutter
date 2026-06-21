import 'dart:io';

import 'package:tuple/tuple.dart';

import '../../../repository/settings_repository.dart';
import '../../../utils/file_util.dart';
import '../../../utils/str_util.dart';

import 'package:path/path.dart' as path;

import '../base_export_file_server.dart';
import '../cache_data_manager.dart';
import '../merge/model/cache_group.dart';
import '../merge/model/cache_item.dart';

abstract class BaseCopyFileServer implements BaseExportFileServer {
  final _singleOutputPathChecked =
      SettingsRepository.getSingleOutputPathChecked();

  // 准备数据
  Future<bool> prepareData(CacheItem item);

  @override
  Future<Tuple2<bool, String?>> exportFileByCacheItem(
    CacheItem item,
    OutputFileMode outputFileMode,
    String? groupTitle,
  ) async {
    final prepareResult = await prepareData(item);
    if (!prepareResult) {
      return const Tuple2(false, "准备数据失败");
    }
    // 处理特殊字符
    final title = StrUtil.handleSpecialCharacters(item.title);
    groupTitle = StrUtil.handleSpecialCharacters(groupTitle);

    //判断导出文件类型
    String? exportTargetPath;
    switch (outputFileMode) {
      case OutputFileMode.video:
        exportTargetPath = item.videoPath;
        break;
      case OutputFileMode.audio:
        exportTargetPath = item.audioPath;
        break;
      default:
        return const Tuple2(false, "未知导出文件类型");
    }

    if (exportTargetPath == null) {
      return const Tuple2(false, "导出文件路径为空");
    }

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
          "${DateTime.now().millisecondsSinceEpoch}_only${outputFileMode.extension}.${outputFileMode.extension}";
    } else {
      outputFileName =
          "${title}_only${outputFileMode.extension}.${outputFileMode.extension}";
    }

    String outputPath = path.join(outputDirPath, outputFileName);
    //判断输出文件是否存在,如果存在则重命名(加序号)
    outputPath = await FileUtil.getAvailableFilePath(outputPath);

    //导出文件
    final result = await finalExportFile(exportTargetPath, outputPath);

    return result;
  }

  Future<Tuple2<bool, String?>> finalExportFile(
    String srcPath,
    String destPath,
  );


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
