/*
* Copyright 2013 The Flutter Authors. All rights reserved.
* Use of this source code is governed by a BSD-style license that can be
* found in the LICENSE file.
*/
import StandardMessageCodec from '@ohos/flutter_ohos/src/main/ets/plugin/common/StandardMessageCodec';
import BasicMessageChannel, { Reply } from '@ohos/flutter_ohos/src/main/ets/plugin/common/BasicMessageChannel';
import { BinaryMessenger,TaskQueue } from '@ohos/flutter_ohos/src/main/ets/plugin/common/BinaryMessenger';
import MessageCodec from '@ohos/flutter_ohos/src/main/ets/plugin/common/MessageCodec';
import { ByteBuffer } from '@ohos/flutter_ohos/src/main/ets/util/ByteBuffer';


/** Error class for passing custom error details to Flutter via a thrown PlatformException. */
export class FlutterError implements Error {

  /** The error code. */
  public code: string;

  /** The error name. */
  public name: string;

  /** The error message. */
  public message: string;
  /** The error stack. */
  public stack?: string;

  constructor(code: string, name: string,  message: string, stack?: string) 
  {
    this.code = code;
    this.name = name;
    this.message = message;
    this.stack = stack;
  }
}

/* Generated class from Pigeon that represents data sent in messages.*/
export class PlatformEvent {
  constructor() {
  }

  toList(): Object[] {
    let arr: Object[] = new Array();
    return arr;
  }

  static fromList(arr: Object[]): PlatformEvent {
    let pigeonResult: PlatformEvent = new PlatformEvent();
    return pigeonResult;
  }
}

/* Generated class from Pigeon that represents data sent in messages.*/
export class IntEvent {
  private data?: number;

  public setData(data:number):void {
    this.data = data;
  }

  getData(): number | undefined{
    return this.data;
  }

  constructor(data?: number) {
    this.data = data;
  }

  toList(): Object[] {
    let arr: Object[] = new Array();
    if(this.data !==undefined){
      arr.push(this.data);
    }
    return arr;
  }

  static fromList(arr: Object[]): IntEvent {
    let pigeonResult: IntEvent = new IntEvent();
    let data: Object = arr[0];
    pigeonResult.setData(data as number);
    return pigeonResult;
  }
}

/* Generated class from Pigeon that represents data sent in messages.*/
export class StringEvent {
  private data?: string;

  public setData(data:string):void {
    this.data = data;
  }

  getData(): string | undefined{
    return this.data;
  }

  constructor(data?: string) {
    this.data = data;
  }

  toList(): Object[] {
    let arr: Object[] = new Array();
    if(this.data !==undefined){
      arr.push(this.data);
    }
    return arr;
  }

  static fromList(arr: Object[]): StringEvent {
    let pigeonResult: StringEvent = new StringEvent();
    let data: Object = arr[0];
    pigeonResult.setData(data as string);
    return pigeonResult;
  }
}

export class PigeonCodec extends StandardMessageCodec {
  static readonly INSTANCE: PigeonCodec  = new PigeonCodec();

  getByte(n: number): number {
    let byteArray = new Uint8Array(1);
    byteArray[0] = n;
    return byteArray[0] as number;
  }
  private constructor() {
    super();
  }

  readValueOfType(type: number,  buffer: ByteBuffer): ESObject {
    switch (type) {
      case this.getByte(129):
        return IntEvent.fromList(super.readValue(buffer) as Object[]);
      case this.getByte(130):
        return StringEvent.fromList(super.readValue(buffer) as Object[]);
      default:
        return super.readValueOfType(type, buffer);
    }
  }

  writeValue(stream: ByteBuffer , value: ESObject): ESObject{
    if (value instanceof IntEvent) {
      stream.writeUint8(this.getByte(129));
      this.writeValue(stream, (value as IntEvent).toList());
    } else if (value instanceof StringEvent) {
      stream.writeUint8(this.getByte(130));
      this.writeValue(stream, (value as StringEvent).toList());
    } else {
      super.writeValue(stream, value);
    }
  }
}

