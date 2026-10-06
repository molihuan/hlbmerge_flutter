import StandardMessageCodec from '@ohos/flutter_ohos/src/main/ets/plugin/common/StandardMessageCodec';
import BasicMessageChannel, { Reply } from '@ohos/flutter_ohos/src/main/ets/plugin/common/BasicMessageChannel';
import { BinaryMessenger } from '@ohos/flutter_ohos/src/main/ets/plugin/common/BinaryMessenger';
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

function wrapError(error: Error): Array<Object | null> {
  let errorList: Array<Object | null> = new Array<Object | null>(3);
  if (error instanceof FlutterError) {
    let err: FlutterError = error as FlutterError;
    errorList[0] = err.code;
    errorList[1] = err.name;
    errorList[2] = err.message;
  } else {
    errorList[0] = error.toString();
    errorList[1] = error.name;
    errorList[2] = "Cause: " + error.message + ", Stacktrace: " + error.stack;
  }
  return errorList;
}

/* Generated class from Pigeon that represents data sent in messages.*/
export class NativePageParams {
  private fromFlutter: boolean;

  public setFromFlutter(fromFlutter: boolean): void {
    this.fromFlutter = fromFlutter;
  }

  getFromFlutter(): boolean{
    return this.fromFlutter;
  }

  constructor(fromFlutter: boolean) {
    this.fromFlutter = fromFlutter;
  }

  toList(): Array<Object | null> {
    let arr: Array<Object | null> = new Array<Object | null>();
    if (this.fromFlutter === undefined || this.fromFlutter === null) {
      arr.push(null);
    } else {
      arr.push(this.fromFlutter);
    }
    return arr;
  }

  static fromList(arr: Object[]): NativePageParams {
    let fromFlutterObject: Object = arr[0];
    const fromFlutter: boolean = fromFlutterObject as boolean;
    return new NativePageParams(fromFlutter);
  }
}

/* Generated class from Pigeon that represents data sent in messages.*/
export class TupleBool {
  private code: number;

  public setCode(code: number): void {
    this.code = code;
  }

  getCode(): number{
    return this.code;
  }

  private msg: string;

  public setMsg(msg: string): void {
    this.msg = msg;
  }

  getMsg(): string{
    return this.msg;
  }

  private data: boolean;

  public setData(data: boolean): void {
    this.data = data;
  }

  getData(): boolean{
    return this.data;
  }

  constructor(code: number, msg: string, data: boolean) {
    this.code = code;
    this.msg = msg;
    this.data = data;
  }

  toList(): Array<Object | null> {
    let arr: Array<Object | null> = new Array<Object | null>();
    if (this.code === undefined || this.code === null) {
      arr.push(null);
    } else {
      arr.push(this.code);
    }
    if (this.msg === undefined || this.msg === null) {
      arr.push(null);
    } else {
      arr.push(this.msg);
    }
    if (this.data === undefined || this.data === null) {
      arr.push(null);
    } else {
      arr.push(this.data);
    }
    return arr;
  }

  static fromList(arr: Object[]): TupleBool {
    let codeObject: Object = arr[0];
    const code: number = codeObject as number;
    let msgObject: Object = arr[1];
    const msg: string = msgObject as string;
    let dataObject: Object = arr[2];
    const data: boolean = dataObject as boolean;
    return new TupleBool(code, msg, data);
  }
}

/* Generated class from Pigeon that represents data sent in messages.*/
export class TupleStr {
  private code: number;

  public setCode(code: number): void {
    this.code = code;
  }

  getCode(): number{
    return this.code;
  }

  private msg: string;

  public setMsg(msg: string): void {
    this.msg = msg;
  }

  getMsg(): string{
    return this.msg;
  }

  private data?: string;

  public setData(data: string | undefined): void {
    this.data = data;
  }

  getData(): string | undefined{
    return this.data;
  }

  constructor(code: number, msg: string, data?: string) {
    this.code = code;
    this.msg = msg;
    this.data = data;
  }

  toList(): Array<Object | null> {
    let arr: Array<Object | null> = new Array<Object | null>();
    if (this.code === undefined || this.code === null) {
      arr.push(null);
    } else {
      arr.push(this.code);
    }
    if (this.msg === undefined || this.msg === null) {
      arr.push(null);
    } else {
      arr.push(this.msg);
    }
    if (this.data === undefined || this.data === null) {
      arr.push(null);
    } else {
      arr.push(this.data);
    }
    return arr;
  }

  static fromList(arr: Object[]): TupleStr {
    let codeObject: Object = arr[0];
    const code: number = codeObject as number;
    let msgObject: Object = arr[1];
    const msg: string = msgObject as string;
    let data: string | undefined = undefined;
    if (arr[2] !== null && arr[2] !== undefined) {
      let dataObject: Object = arr[2];
      data = dataObject as string | undefined;
    }
    return new TupleStr(code, msg, data);
  }
}

/* Generated class from Pigeon that represents data sent in messages.*/
export class FlutterPageParams {
  private fromNative: boolean;

  public setFromNative(fromNative: boolean): void {
    this.fromNative = fromNative;
  }

  getFromNative(): boolean{
    return this.fromNative;
  }

  constructor(fromNative: boolean) {
    this.fromNative = fromNative;
  }

  toList(): Array<Object | null> {
    let arr: Array<Object | null> = new Array<Object | null>();
    if (this.fromNative === undefined || this.fromNative === null) {
      arr.push(null);
    } else {
      arr.push(this.fromNative);
    }
    return arr;
  }

  static fromList(arr: Object[]): FlutterPageParams {
    let fromNativeObject: Object = arr[0];
    const fromNative: boolean = fromNativeObject as boolean;
    return new FlutterPageParams(fromNative);
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
        return NativePageParams.fromList(super.readValue(buffer) as Object[]);
      case this.getByte(130):
        return TupleBool.fromList(super.readValue(buffer) as Object[]);
      case this.getByte(131):
        return TupleStr.fromList(super.readValue(buffer) as Object[]);
      case this.getByte(132):
        return FlutterPageParams.fromList(super.readValue(buffer) as Object[]);
      default:
        return super.readValueOfType(type, buffer);
    }
  }

  writeValue(stream: ByteBuffer , value: ESObject): ESObject{
    if (value instanceof NativePageParams) {
      stream.writeUint8(this.getByte(129));
      this.writeValue(stream, (value as NativePageParams).toList());
    } else if (value instanceof TupleBool) {
      stream.writeUint8(this.getByte(130));
      this.writeValue(stream, (value as TupleBool).toList());
    } else if (value instanceof TupleStr) {
      stream.writeUint8(this.getByte(131));
      this.writeValue(stream, (value as TupleStr).toList());
    } else if (value instanceof FlutterPageParams) {
      stream.writeUint8(this.getByte(132));
      this.writeValue(stream, (value as FlutterPageParams).toList());
    } else {
      super.writeValue(stream, value);
    }
  }
}


export interface Result<T> {
  success( result: T ): void;

  error( error: Error): void;
}
/* Generated abstract class from Pigeon that represents a handler of messages from Flutter.*/
export abstract class NativeApis {
  /* 跳转原生页面*/
  abstract goNativePage(router: string , params: NativePageParams | undefined ): TupleBool;
  /* 是否有读写权限*/
  abstract hasReadWritePermission(): TupleBool;
  /* 请求读写权限,需要异步*/
  abstract grantReadWritePermission(result: Result<TupleBool>): void;

  abstract getExternalStorageRootPath(): TupleStr;

  abstract getDefaultOutputDirPath(): TupleStr;

  abstract copyCacheAudioVideoFile(sufPath: string , result: Result<TupleBool>): void;

  abstract copyCacheStructureFile(result: Result<TupleBool>): void;

  abstract notifyExportComplete(result: Result<TupleBool>): void;
  /** The codec used by NativeApis. */
  static getCodec(): MessageCodec<Object>{
    return PigeonCodec.INSTANCE;
  }
  /*Sets up an instance of `NativeApis` to handle messages through the `binaryMessenger`.*/
  static setup(binaryMessenger: BinaryMessenger, api: NativeApis | null, messageChannelSuffix: string = ''): void {
    const separatedMessageChannelSuffix: string = messageChannelSuffix !== '' ? '.' + messageChannelSuffix : '';
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, 'dev.flutter.pigeon.hlbmerge.NativeApis.goNativePage' + separatedMessageChannelSuffix, NativeApis.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              if (!(Array.isArray(message))) {
                  reply.reply(wrapError(new Error('Invalid Pigeon message: expected List.')));
                  return;
              }
              let args: Array<Object> = message as Array<Object>;
              if (args.length < 2) {
                  reply.reply(wrapError(new Error('Invalid Pigeon message: expected at least 2 argument(s).')));
                  return;
              }
              let res: Array<Object | null> = [];
              try {
                let output: TupleBool = api!.goNativePage(args[0] as string, args[1] as NativePageParams | undefined);
                res.push(output);
              }
 catch (error) {
                let wrappedError: Array<Object | null> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, 'dev.flutter.pigeon.hlbmerge.NativeApis.hasReadWritePermission' + separatedMessageChannelSuffix, NativeApis.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let res: Array<Object | null> = [];
              try {
                let output: TupleBool = api!.hasReadWritePermission();
                res.push(output);
              }
 catch (error) {
                let wrappedError: Array<Object | null> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, 'dev.flutter.pigeon.hlbmerge.NativeApis.grantReadWritePermission' + separatedMessageChannelSuffix, NativeApis.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              class ResultImp implements Result<TupleBool>{
                    success(result: TupleBool): void {
                      let res: Array<Object | null> = [];
                      res.push(result);
                      reply.reply(res);
                    }

                    error(error: Error): void {
                      let wrappedError: Array<Object | null> = wrapError(error);
                      reply.reply(wrappedError);
                    }
              }
              let resultCallback: Result<TupleBool> = new ResultImp();

              api!.grantReadWritePermission(resultCallback);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, 'dev.flutter.pigeon.hlbmerge.NativeApis.getExternalStorageRootPath' + separatedMessageChannelSuffix, NativeApis.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let res: Array<Object | null> = [];
              try {
                let output: TupleStr = api!.getExternalStorageRootPath();
                res.push(output);
              }
 catch (error) {
                let wrappedError: Array<Object | null> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, 'dev.flutter.pigeon.hlbmerge.NativeApis.getDefaultOutputDirPath' + separatedMessageChannelSuffix, NativeApis.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let res: Array<Object | null> = [];
              try {
                let output: TupleStr = api!.getDefaultOutputDirPath();
                res.push(output);
              }
 catch (error) {
                let wrappedError: Array<Object | null> = wrapError(error);
                res = wrappedError;
              }
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, 'dev.flutter.pigeon.hlbmerge.NativeApis.copyCacheAudioVideoFile' + separatedMessageChannelSuffix, NativeApis.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              if (!(Array.isArray(message))) {
                  reply.reply(wrapError(new Error('Invalid Pigeon message: expected List.')));
                  return;
              }
              let args: Array<Object> = message as Array<Object>;
              if (args.length < 1) {
                  reply.reply(wrapError(new Error('Invalid Pigeon message: expected at least 1 argument(s).')));
                  return;
              }
              class ResultImp implements Result<TupleBool>{
                    success(result: TupleBool): void {
                      let res: Array<Object | null> = [];
                      res.push(result);
                      reply.reply(res);
                    }

                    error(error: Error): void {
                      let wrappedError: Array<Object | null> = wrapError(error);
                      reply.reply(wrappedError);
                    }
              }
              let resultCallback: Result<TupleBool> = new ResultImp();

              api!.copyCacheAudioVideoFile(args[0] as string, resultCallback);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, 'dev.flutter.pigeon.hlbmerge.NativeApis.copyCacheStructureFile' + separatedMessageChannelSuffix, NativeApis.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              class ResultImp implements Result<TupleBool>{
                    success(result: TupleBool): void {
                      let res: Array<Object | null> = [];
                      res.push(result);
                      reply.reply(res);
                    }

                    error(error: Error): void {
                      let wrappedError: Array<Object | null> = wrapError(error);
                      reply.reply(wrappedError);
                    }
              }
              let resultCallback: Result<TupleBool> = new ResultImp();

              api!.copyCacheStructureFile(resultCallback);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, 'dev.flutter.pigeon.hlbmerge.NativeApis.notifyExportComplete' + separatedMessageChannelSuffix, NativeApis.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              class ResultImp implements Result<TupleBool>{
                    success(result: TupleBool): void {
                      let res: Array<Object | null> = [];
                      res.push(result);
                      reply.reply(res);
                    }

                    error(error: Error): void {
                      let wrappedError: Array<Object | null> = wrapError(error);
                      reply.reply(wrappedError);
                    }
              }
              let resultCallback: Result<TupleBool> = new ResultImp();

              api!.notifyExportComplete(resultCallback);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
  }
}
/* Generated class from Pigeon that represents Flutter messages that can be called from ArkTS.*/
export class FlutterApis {
  binaryMessenger: BinaryMessenger;
  private messageChannelSuffix: string;

  constructor(binaryMessenger: BinaryMessenger, messageChannelSuffix: string = '') {
    this.binaryMessenger = binaryMessenger;
    this.messageChannelSuffix = messageChannelSuffix !== '' ? '.' + messageChannelSuffix : '';
  }

  /** The codec used by FlutterApis. */
  static getCodec(): MessageCodec<Object> {
    return PigeonCodec.INSTANCE;
  }

  backFlutterPageFromNativePage(paramsArg: FlutterPageParams | undefined, callback: Reply<void>) {
    const channelName: string = 'dev.flutter.pigeon.hlbmerge.FlutterApis.backFlutterPageFromNativePage' + this.messageChannelSuffix;
    let channel: BasicMessageChannel<Object> = 
        new BasicMessageChannel<Object>(
            this.binaryMessenger, channelName, FlutterApis.getCodec());
    channel.send(
        [paramsArg],
        channelReply => {
          if (Array.isArray(channelReply)) {
            let listReply: ESObject[] = channelReply as ESObject[] ;
            if (listReply.length > 1) {
              let arrFirst:string = listReply[0] as string;
              let arrSecond:string = listReply[1] as string;
              let arrThird:string = listReply[2] as string;
              let replyArr: ESObject = new FlutterError(arrFirst, arrSecond, arrThird);
              callback.reply(replyArr);
            } else {
              callback.reply();
            }
          }  else {
            let connErr: ESObject = new FlutterError('channel-error', 'Unable to establish connection on channel: ' + channelName + '.', '');
            callback.reply(connErr);
          } 
        });
  }
}
