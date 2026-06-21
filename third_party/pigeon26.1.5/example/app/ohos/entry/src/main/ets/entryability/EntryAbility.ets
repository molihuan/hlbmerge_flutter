// Copyright (c) 2025 Huawei Device Co., Ltd.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE_HW file.
// Based on Camera.java originally written by
// Copyright 2013 The Flutter Authors.

import { FlutterAbility } from '@ohos/flutter_ohos'
import MessagePlugin from '../plugins/MessagePlugin';
import { FlutterPlugin } from '@ohos/flutter_ohos/src/main/ets/embedding/engine/plugins/FlutterPlugin';
import { GeneratedPluginRegistrant } from '../plugins/GeneratedPluginRegistrant';
import List from '@ohos.util.List';
import FlutterEngine from '@ohos/flutter_ohos/src/main/ets/embedding/engine/FlutterEngine';

export default class EntryAbility extends FlutterAbility {
  configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    GeneratedPluginRegistrant.registerWith(flutterEngine);
    this.addPlugin(new MessagePlugin())
  }
}