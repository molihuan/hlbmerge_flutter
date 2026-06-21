/*
* Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import {
  FlutterPlugin,
  FlutterPluginBinding
} from '@ohos/flutter_ohos/src/main/ets/embedding/engine/plugins/FlutterPlugin';
import { ExampleHostApi, MessageData } from './Messages';
import { IntEvent, StringEvent, PigeonCodec } from './EventChannelMessages';
import {
  Any,
  EventChannel,
  EventSink,
  StreamHandler
} from '@ohos/flutter_ohos';
import { StandardMethodCodec } from '@ohos/flutter_ohos';

class HostApiImp extends ExampleHostApi implements StreamHandler {
  private eventSender: EventSender = new EventSender();
  private reconnectTimer: number | null = null;

  onListen(args: Any, events: EventSink): void {
    if (this.reconnectTimer) {
      clearTimeout(this.reconnectTimer);
      this.reconnectTimer = null;
    }

    this.eventSender.start(events);
  }

  onCancel(args: Any): void {

    this.eventSender.stopSendingEvents();
  }

  getHostLanguage(): string {
    return 'ArkTS';
  }

  add(a: number, b: number): number {
    return a + b;
  }

  sendMessage(message: MessageData): boolean {
    return true;
  }
}

class EventSender {
  private count: number = 0;
  private timer: number | null = null;
  private eventSink: EventSink | null = null;
  private isActive: boolean = false;

  start(eventSink: EventSink): void {
    setTimeout(() => {
      if (!eventSink) {
        console.error('EventSink为null，无法启动事件发送');
        return;
      }

      this.eventSink = eventSink;
      this.isActive = true;

      this.timer = setInterval(() => {
        if (!this.isActive || !this.eventSink) {
          this.forceStop();
          return;
        }

        try {
          if (this.count >= 100) {
            this.forceStop();
            return;
          }

          if (this.count % 2 === 0) {
            const intEvent = new IntEvent();
            intEvent.setData(this.count);
            this.eventSink.success(intEvent);
          } else {
            const stringEvent = new StringEvent();
            stringEvent.setData(`${this.count}`);
            this.eventSink.success(stringEvent);
          }
          this.count++;
        } catch (error) {
          this.forceStop();
        }
      }, 1000);
    }, 2000);
  }
  stopSendingEvents() {
    this.forceStop();
  }

  private forceStop() {
    if (!this.isActive && !this.timer) {
      return;
    }

    this.isActive = false;

    if (this.timer) {
      clearInterval(this.timer);
      this.timer = null;
    }

    this.eventSink = null;
  }

  isRunning(): boolean {
    return this.isActive;
  }
}

export default class MessagePlugin implements FlutterPlugin {
  private hostApi: HostApiImp = new HostApiImp();
  private eventChannel: EventChannel | null = null;

  constructor() {
  }

  getUniqueClassName(): string {
    return 'MessagePlugin';
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {

    ExampleHostApi.setup(binding.getBinaryMessenger(), new HostApiImp());
    this.eventChannel = new EventChannel(
      binding.getBinaryMessenger(),
      'dev.flutter.pigeon.pigeon_example_package.EventChannelMethods.streamEvents',
      new StandardMethodCodec(PigeonCodec.INSTANCE)
    );
    this.eventChannel.setStreamHandler(new HostApiImp());
  }

  onDetachedFromEngine(binding: FlutterPluginBinding) {
    ExampleHostApi.setup(binding.getBinaryMessenger(), null);
    if (this.eventChannel) {
      this.eventChannel.setStreamHandler(null);
      this.eventChannel = null;
    }
  }
}