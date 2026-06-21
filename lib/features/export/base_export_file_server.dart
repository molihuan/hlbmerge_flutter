import 'package:tuple/tuple.dart';

import 'cache_data_manager.dart';
import 'merge/model/cache_group.dart';
import 'merge/model/cache_item.dart';

abstract class BaseExportFileServer {
  Future<Tuple2<bool, String?>> exportFileByCacheItem(
    CacheItem item,
    OutputFileMode outputFileMode,
    String? groupTitle,
  );

  Future<List<Tuple2<CacheItem, String>>> exportFileByCacheGroup(
    CacheGroup cacheGroup,
    OutputFileMode outputFileMode,
  );
}
