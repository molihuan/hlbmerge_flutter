// Copyright (c) 2025 Huawei Device Co., Ltd.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE_HW file.
// Based on Camera.java originally written by
// Copyright 2013 The Flutter Authors.

import '../ast.dart';
import '../functional.dart';
import '../generator.dart';
import '../generator_tools.dart';
import '../types/task_queue.dart' show TaskQueueType;

/// Documentation open symbol.
const String _docCommentPrefix = '/*';

/// Documentation continuation symbol.
const String _docCommentContinuation = '* ';

/// Documentation close symbol.
const String _docCommentSuffix = '*/';

/// The standard codec for Flutter, used for any non custom codecs and extended for custom codecs.
const String _codecName = 'PigeonCodec';
const String _overflowClassName = '${classNamePrefix}CodecOverflow';
// Used to create classes with type number rather than long.
const String _forceInt = '${varNamePrefix}forceInt';

///Enum companion suffix
const String _enumCompanionSuffix = 'Enum';
const String _string_Param_Suffix = 'Str';

/// Documentation comment spec.
const DocumentCommentSpecification _docCommentSpec =
    DocumentCommentSpecification(
  _docCommentPrefix,
  closeCommentToken: _docCommentSuffix,
  blockContinuationToken: _docCommentContinuation,
);

class ArkTSOptions {
  const ArkTSOptions({
    this.copyrightHeader,
  });

  final Iterable<String>? copyrightHeader;

  static ArkTSOptions fromMap(Map<String, Object> map) {
    final Iterable<dynamic>? copyrightHeader =
        map['copyrightHeader'] as Iterable<dynamic>?;
    return ArkTSOptions(copyrightHeader: copyrightHeader?.cast<String>());
  }

  Map<String, Object> toMap() {
    final Map<String, Object> result = <String, Object>{
      if (copyrightHeader != null) 'copyrightHeader': copyrightHeader!,
    };
    return result;
  }

  /// Overrides any non-null parameters from [options] into this to make a new
  /// [ArkTSOptions].
  ArkTSOptions merge(ArkTSOptions options) {
    return ArkTSOptions.fromMap(mergeMaps(toMap(), options.toMap()));
  }
}

/// Internal ArkTS options that extend InternalOptions.
class InternalArkTSOptions extends InternalOptions {
  const InternalArkTSOptions({
    required this.arkTSOut,
    this.copyrightHeader,
  });

  /// Path to the ArkTS file that will be generated.
  final String arkTSOut;

  final Iterable<String>? copyrightHeader;

  /// Creates [InternalArkTSOptions] from [ArkTSOptions].
  static InternalArkTSOptions fromArkTSOptions(
    ArkTSOptions options, {
    required String arkTSOut,
    Iterable<String>? copyrightHeader,
  }) {
    return InternalArkTSOptions(
      arkTSOut: arkTSOut,
      copyrightHeader: options.copyrightHeader ?? copyrightHeader,
    );
  }
}

/// arkts code generator
class ArkTSGenerator extends StructuredGenerator<InternalArkTSOptions> {
  /// Instantiates a ArkTS Generator.
  const ArkTSGenerator();

  @override
  void writeFilePrologue(
      InternalArkTSOptions generatorOptions, Root root, Indent indent,
      {required String dartPackageName}) {
    if (generatorOptions.copyrightHeader != null) {
      indent.writeln('/*');
      addLines(indent, generatorOptions.copyrightHeader!, linePrefix: '* ');
      indent.writeln('*/');
    }
  }

  @override
  void writeFileImports(
      InternalArkTSOptions generatorOptions, Root root, Indent indent,
      {required String dartPackageName}) {
    indent.writeln(
        "import StandardMessageCodec from '@ohos/flutter_ohos/src/main/ets/plugin/common/StandardMessageCodec';");
    indent.writeln(
        "import BasicMessageChannel, { Reply } from '@ohos/flutter_ohos/src/main/ets/plugin/common/BasicMessageChannel';");
    indent.writeln(
        "import { BinaryMessenger,TaskQueue } from '@ohos/flutter_ohos/src/main/ets/plugin/common/BinaryMessenger';");
    indent.writeln(
        "import MessageCodec from '@ohos/flutter_ohos/src/main/ets/plugin/common/MessageCodec';");
    indent.writeln(
        "import { ByteBuffer } from '@ohos/flutter_ohos/src/main/ets/util/ByteBuffer';");
    indent.newln();
  }

  @override
  void writeEnum(
    InternalArkTSOptions generatorOptions,
    Root root,
    Indent indent,
    Enum anEnum, {
    required String dartPackageName,
  }) {
    String camelToSnake(String camelCase) {
      final RegExp regex = RegExp('([a-z])([A-Z]+)');
      return camelCase
          .replaceAllMapped(regex, (Match m) => '${m[1]}_${m[2]}')
          .toUpperCase();
    }

    const List<String> generatedEnumMessages = <String>[
      ' Generated enum from Pigeon that represents data sent in messages.'
    ];
    indent.newln();
    addDocumentationComments(
        indent, anEnum.documentationComments, _docCommentSpec,
        generatorComments: generatedEnumMessages);
    indent.write('export enum ${anEnum.name} ');
    indent.addScoped('{', '}', () {
      enumerate(anEnum.members, (int index, final EnumMember member) {
        addDocumentationComments(
            indent, member.documentationComments, _docCommentSpec);
        indent.writeln(
            '${camelToSnake(member.name)}${index == anEnum.members.length - 1 ? '' : ','}');
      });
    });
    const List<String> generatedEnumCompanionMessages = <String>[
      '''
 Generated enum Companion class from Pigeon that represents data sent 
   in messages.Do not delete otherwise enum type data transfer will be failed'''
    ];
    indent.newln();
    addDocumentationComments(
        indent, anEnum.documentationComments, _docCommentSpec,
        generatorComments: generatedEnumCompanionMessages);
    indent.write('export class ${anEnum.name}$_enumCompanionSuffix ');
    indent.addScoped('{', '}', () {
      indent.writeln('index: string|null = null;');
      indent.addScoped('\tconstructor(index: string){', '}', () {
        indent.writeln('this.index = index;');
      });
    });
  }

  @override
  void writeDataClass(InternalArkTSOptions generatorOptions, Root root,
      Indent indent, Class klass,
      {required String dartPackageName}) {
    final Set<String> customClassNames =
        root.classes.map((Class x) => x.name).toSet();
    final Set<String> customEnumNames =
        root.enums.map((Enum x) => x.name).toSet();

    const List<String> generatedMessages = <String>[
      ' Generated class from Pigeon that represents data sent in messages.'
    ];
    indent.newln();
    addDocumentationComments(
        indent, klass.documentationComments, _docCommentSpec,
        generatorComments: generatedMessages);

    indent.write('export class ${klass.name} ');
    indent.addScoped('{', '}', () {
      for (final NamedType field in getFieldsInSerializationOrder(klass)) {
        //for里面这里不一样，可能需要改造
        _writeClassField(generatorOptions, indent, field);
        indent.newln();
      }

      _writeClassBuilder(generatorOptions, root, indent, klass);
      writeClassEncode(
        generatorOptions,
        root,
        indent,
        klass,
        dartPackageName: dartPackageName,
      );
      writeClassDecode(
        generatorOptions,
        root,
        indent,
        klass,
        dartPackageName: dartPackageName,
      );
    });
  }

  void _writeClassField(
    InternalArkTSOptions generatorOptions,
    Indent indent,
    NamedType field, {
    bool isPrimitive = false,
  }) {
    final HostDatatype hostDatatype = getFieldHostDatatype(
        field, (TypeDeclaration x) => _arkTSTypeForBuiltinDartType(x));
    if (field.type.isEnum) {
      indent.writeln('private ${field.name}?: ${hostDatatype.datatype};');
      indent.newln();
      indent.writeScoped(
          'public ${_makeSetter(field)}(${field.name}:${hostDatatype.datatype}):void {',
          '}', () {
        indent.writeln('this.${field.name} = ${field.name};');
      });
      indent.newln();
      indent.write(
          '${_makeGetter(field)}(): ${hostDatatype.datatype} | undefined');
      indent.addScoped('{', '}', () {
        indent.writeln('return this.${field.name};');
      });
    } else {
      indent.writeln('private ${field.name}?: ${hostDatatype.datatype};');
      indent.newln();
      indent.writeScoped(
          'public ${_makeSetter(field)}(${field.name}:${hostDatatype.datatype}):void {',
          '}', () {
        indent.writeln('this.${field.name} = ${field.name};');
      });
      indent.newln();
      indent.write(
          '${_makeGetter(field)}(): ${hostDatatype.datatype} | undefined');
      indent.addScoped('{', '}', () {
        indent.writeln('return this.${field.name};');
      });
    }
  }

  void _writeDataClassSignature(
    InternalArkTSOptions generatorOptions,
    Indent indent,
    Class classDefinition,
    void Function() dataClassBody, {
    bool private = false,
  }) {
    indent.write(
        '${private ? 'private' : 'public'} static final class ${classDefinition.name} ');
    indent.addScoped('{', '}', () {
      for (final NamedType field
          in getFieldsInSerializationOrder(classDefinition)) {
        _writeClassField(
          generatorOptions,
          indent,
          field,
          isPrimitive: field.type.baseName == _forceInt,
        );
        indent.newln();
      }
      dataClassBody();
    });
  }

  // 构造函数
  void _writeClassBuilder(
    InternalArkTSOptions generatorOptions,
    Root root,
    Indent indent,
    Class klass,
  ) {
    indent.write('constructor');
    final List<String> argSignature = <String>[];
    if (klass.fields.isNotEmpty) {
      for (final NamedType element in klass.fields) {
        final String type = _arkTSTypeForDartType(element.type);
        final String name = getSafeConstructorArgument(element.name);
        if (element.type.isEnum) {
          argSignature.add('$name?: $type');
        } else {
          argSignature.add('$name?: $type');
        }
      }
    }
    indent.add('(${argSignature.join(', ')}) ');
    indent.addScoped('{', '}', () {
      for (final NamedType field in getFieldsInSerializationOrder(klass)) {
        final String value = getSafeConstructorArgument(field.name);
        indent.writeln('this.${field.name} = $value;');
      }
    });
  }

  @override
  void writeClassEncode(
    InternalArkTSOptions generatorOptions,
    Root root,
    Indent indent,
    Class klass, {
    required String dartPackageName,
  }) {
    indent.newln();
    indent.write('toList(): Object[] ');
    indent.addScoped('{', '}', () {
      indent.writeln('let arr: Object[] = new Array();');
      for (final NamedType field in getFieldsInSerializationOrder(klass)) {
        final String fieldName = field.name;
        if (field.type.isEnum) {
          indent.writeScoped('if(this.$fieldName !==undefined){', '}', () {
            indent.writeln(
                'const $fieldName$_string_Param_Suffix = ${field.type.baseName}[this.$fieldName as number];');
            indent.writeln(
                'arr.push(new ${field.type.baseName}$_enumCompanionSuffix($fieldName$_string_Param_Suffix));');
          });
        } else {
          indent.writeScoped('if(this.$fieldName !==undefined){', '}', () {
            indent.writeln('arr.push(this.$fieldName);');
          });
        }
      }
      indent.writeln('return arr;');
    });
  }

  @override
  void writeClassDecode(
    InternalArkTSOptions generatorOptions,
    Root root,
    Indent indent,
    Class klass, {
    required String dartPackageName,
  }) {
    indent.newln();
    indent.write('static fromList(arr: Object[]): ${klass.name} ');
    indent.addScoped('{', '}', () {
      const String result = 'pigeonResult';
      indent.writeln('let $result: ${klass.name} = new ${klass.name}();');

      enumerate(getFieldsInSerializationOrder(klass),
          (int index, final NamedType field) {
        final String fieldVariable = field.name;
        final String setter = _makeSetter(field);
        if (field.type.isEnum) {
          indent.writeln(
              'const $fieldVariable$_string_Param_Suffix: string = arr[$index]! as string;');
          indent.writeln(
              '$result.$setter(${field.type.baseName}[$fieldVariable$_string_Param_Suffix]);');
        } else {
          indent.writeln('let $fieldVariable: Object = arr[$index];');
          indent.writeln(
              '$result.$setter(${_castObject(field, fieldVariable)});');
        }
      });
      indent.writeln('return ${result};');
    });
  }

  String _makeSetter(NamedType field) {
    final String uppercased =
        field.name.substring(0, 1).toUpperCase() + field.name.substring(1);
    return 'set$uppercased';
  }

  /// Casts variable named [varName] to the correct host datatype for [field].
  /// This is for use in codecs where we may have a map representation of an
  /// object.
  String _castObject(NamedType field, String varName) {
    final HostDatatype hostDatatype = getFieldHostDatatype(
        field, (TypeDeclaration x) => _arkTSTypeForDartType(x));
    return _cast(varName, artTSType: hostDatatype.datatype);
  }

  @override
  void writeFlutterApi(
      InternalArkTSOptions generatorOptions, Root root, Indent indent, Api api,
      {required String dartPackageName}) {
    String getSafeArgumentExpression(int count, NamedType argument) {
      return '${_getArgumentName(count, argument)}Arg';
    }

    const List<String> generatedMessages = <String>[
      ' Generated class from Pigeon that represents Flutter messages that can be called from ArkTS.'
    ];
    addDocumentationComments(indent, api.documentationComments, _docCommentSpec,
        generatorComments: generatedMessages);

    indent.write('export class ${api.name} ');

    ///MessageFlutterApi
    indent.addScoped('{', '}', () {
      indent.writeln('binaryMessenger: BinaryMessenger;');
      indent.newln();

      indent.write('constructor(binaryMessenger: BinaryMessenger) ');
      indent.addScoped('{', '}', () {
        indent.writeln('this.binaryMessenger = binaryMessenger;');
      });

      indent.newln();

      ///final String codecName = _getCodecName(api);
      indent.writeln('/** The codec used by ${api.name}. */');
      indent.write('static getCodec(): MessageCodec<Object> ');
      indent.addScoped('{', '}', () {
        indent.writeln('return $_codecName.INSTANCE;');
      });

      indent.newln();

      for (final Method func in api.methods) {
        final String returnType = func.returnType.isVoid
            ? 'void'
            : _arkTSTypeForDartType(func.returnType);
        String sendArgument;
        addDocumentationComments(
            indent, func.documentationComments, _docCommentSpec);
        if (func.parameters.isEmpty) {
          indent.write('${func.name}(callback: Reply<$returnType>):void ');
          sendArgument = 'null';
        } else {
          final Iterable<String> argTypes = func.parameters
              .map((NamedType e) => _arkTSTypeForDartType(e.type));
          final Iterable<String> argNames =
              indexMap(func.parameters, _getSafeArgumentName);
          final Iterable<String> enumSafeArgNames =
              indexMap(func.parameters, getSafeArgumentExpression);

          if (func.parameters.length == 1) {
            sendArgument = '[${enumSafeArgNames.first}]';
          } else {
            sendArgument = '[${enumSafeArgNames.join(', ')}]';
          }

          final String argsSignature =
              map2(argTypes, argNames, (String x, String y) => '$y: $x')
                  .join(',');
          indent.write(
              '${func.name}($argsSignature, callback: Reply<$returnType>) ');
        }
        indent.addScoped('{', '}', () {
          const String channel = 'channel';
          indent.writeln(
              'const channelName: string = \'${makeChannelName(api, func, dartPackageName)}\';');
          indent.writeln('let $channel: BasicMessageChannel<Object> = ');
          indent.nest(2, () {
            indent.writeln('new BasicMessageChannel<Object>(');
            indent.nest(2, () {
              indent.writeln(
                  'this.binaryMessenger, channelName, ${api.name}.getCodec());');
            });
          });
          indent.writeln('$channel.send(');

          indent.nest(2, () {
            indent.writeln('$sendArgument,');
            indent.write('channelReply => ');

            indent.addScoped('{', '});', () {
              indent.writeScoped('if (Array.isArray(channelReply)) {', '} ',
                  () {
                const String output = 'output';

                indent.writeln(
                    'let listReply: ESObject[] = channelReply as ESObject[] ;');
                indent.writeScoped('if (listReply.length > 1) {', '} ', () {
                  indent
                      .writeln('let arrFirst:string = listReply[0] as string;');
                  indent.writeln(
                      'let arrSecond:string = listReply[1] as string;');
                  indent
                      .writeln('let arrThird:string = listReply[2] as string;');
                  String replyArr =
                      '\'FlutterError:{"code":\'+arrFirst+\',"name":\'+arrSecond+\',"message":\'+arrThird+\'}\';';
                  if (func.returnType.isVoid) {
                    indent.writeln('let replyArr:ESObject = new FlutterError(arrFirst, arrSecond, arrThird)');
                  } else {
                    indent.writeln('let replyArr:$returnType = $replyArr');
                  }
                  indent.writeln('callback.reply(replyArr);');
                }, addTrailingNewline: false);

                if (!func.returnType.isVoid) {
                  indent.addScoped('else if (listReply[0] == null) {', '} ',
                      () {
                    String replyNull =
                        'FlutterError:{"code":null-error,"name":Flutter api returned null value for non-null return value.,"message":}';
                    indent
                        .writeln('let replyNull:$returnType = \'$replyNull\'');
                    indent.writeln('callback.reply(replyNull);');
                  }, addTrailingNewline: false);
                }

                indent.addScoped('else {', '}', () {
                  if (func.returnType.isVoid) {
                    indent.writeln('callback.reply();');
                  } else {
                    const String output = 'output';
                    final String outputExpression;
                    if (func.returnType.baseName == 'number') {
                      outputExpression =
                          'listReply[0] == null ? null : (listReply[0] as number).valueOf();';
                    } else {
                      outputExpression =
                          '${_cast('listReply[0]', artTSType: returnType)};';
                    }
                    indent
                        .writeln('let $output:$returnType = $outputExpression');
                    indent.writeln('callback.reply($output);');
                  }
                });
              }, addTrailingNewline: false);
              indent.addScoped(' else {', '} ', () {
                if (func.returnType.isVoid) {
                  String connErr = 'let connErr:ESObject = new FlutterError('+"'channel-error'" + ', "Unable to establish connection on channel: " + channelName + ".", "")';
                  indent.writeln(connErr);
                } else {
                  String connErr = 'FlutterError:{"code":channel-error,"name":Unable to establish connection on channel:channelName,"message":.}';
                  indent.writeln('let connErr:$returnType = \'$connErr\'');
                }
                indent.writeln('callback.reply(connErr);');
              });
            });
          });
        });
      }
    });
  }

  @override
  void writeApis(
    InternalArkTSOptions generatorOptions,
    Root root,
    Indent indent, {
    required String dartPackageName,
  }) {
    if (root.apis.any((Api api) =>
        api is AstHostApi &&
            api.methods.any((Method it) => it.isAsynchronous) ||
        api is AstFlutterApi)) {
      indent.newln();
      _writeResultInterface(indent);
    }
    super.writeApis(generatorOptions, root, indent,
        dartPackageName: dartPackageName);
  }

  /// public interface ExampleHostApi
  @override
  void writeHostApi(
      InternalArkTSOptions generatorOptions, Root root, Indent indent, Api api,
      {required String dartPackageName}) {
    const List<String> generatedMessages = <String>[
      ' Generated abstract class from Pigeon that represents a handler of messages from Flutter.'
    ];
    addDocumentationComments(indent, api.documentationComments, _docCommentSpec,
        generatorComments: generatedMessages);

    indent.write('export abstract class ${api.name} ');
    indent.addScoped('{', '}', () {
      for (final Method method in api.methods) {
        _writeInterfaceMethod(generatorOptions, root, indent, api, method);
      }

      ///final String codecName = _getCodecName(api);
      indent.writeln('/** The codec used by ${api.name}. */');
      indent.write('static getCodec(): MessageCodec<Object>');
      indent.addScoped('{', '}', () {
        indent.writeln('return $_codecName.INSTANCE;');
      });

      indent.writeln(
          '${_docCommentPrefix}Sets up an instance of `${api.name}` to handle messages through the `binaryMessenger`.$_docCommentSuffix');

      indent.write(
          'static setup(binaryMessenger: BinaryMessenger, api: ${api.name} | null): void ');
      indent.addScoped('{', '}', () {
        for (final Method method in api.methods) {
          _writeMethodSetup(
            generatorOptions,
            root,
            indent,
            api,
            method,
            dartPackageName: dartPackageName,
          );
        }
      });
    });
  }

  /// Write a static setup function in the interface.
  /// Example:
  ///   static void setup(BinaryMessenger binaryMessenger, Foo api) {...}
  void _writeMethodSetup(
    InternalArkTSOptions generatorOptions,
    Root root,
    Indent indent,
    Api api,
    final Method method, {
    required String dartPackageName,
  }) {
    final String channelName = makeChannelName(api, method, dartPackageName);
    indent.write('');
    indent.addScoped('{', '}', () {
      indent.writeln('let channel: BasicMessageChannel<Object> =');
      indent.nest(2, () {
        indent.writeln('new BasicMessageChannel(');
        indent.nest(2, () {
          indent
              .write('binaryMessenger, "$channelName", ${api.name}.getCodec()');
          indent.addln(');');
        });
      });
      indent.write('if (api != null) ');
      indent.addScoped('{', '} else {', () {
        indent.writeln('channel.setMessageHandler({');
        indent.nest(2, () {
          indent.write('onMessage(message: Object ,reply: Reply<Object> ) ');
          indent.addScoped('{', '} });', () {
            final String returnType = method.returnType.isVoid
                ? 'void'
                : _arkTSTypeForDartType(method.returnType);
            final List<String> methodArgument = <String>[];
            if (method.parameters.isNotEmpty) {
              indent.writeln(
                  'let args: Array<Object> = message as Array<Object>;');
              enumerate(method.parameters, (int index, NamedType arg) {
                String argExpression =
                    'args[$index] as ${_arkTSTypeForDartType(arg.type)}';
                if (method.returnType.isEnum) {
                  argExpression =
                      'new ${_arkTSTypeForDartType(arg.type)}$_enumCompanionSuffix'
                      '${'(args[$index] as string)'}';
                }
                methodArgument.add(argExpression);
              });
            }
            if (method.isAsynchronous) {
              final String resultValue =
                  method.returnType.isVoid ? 'null' : 'result';
              const String resultName = 'resultCallback';
              indent.format('''
class ResultImp implements Result<$returnType>{
\t\t\tsuccess(result: $returnType): void {
\t\t\t\tlet res: Array<Object> = [];
\t\t\t\tres.push($resultValue);
\t\t\t\treply.reply(res);
\t\t\t}

\t\t\terror(error: Error): void {
\t\t\t\tlet wrappedError: Array<Object> = wrapError(error);
\t\t\t\treply.reply(wrappedError);
\t\t\t}
}
let $resultName: Result<$returnType> = new ResultImp();
''');
              methodArgument.add(resultName);
            }
            final String call =
                'api!.${method.name}(${methodArgument.join(', ')})';
            // indent.writeln('$call;');
            if (method.isAsynchronous) {
              indent.writeln('$call;');
            } else {
              indent.writeln('let res: Array<Object> = [];');
              indent.write('try ');
              indent.addScoped('{', '}', () {
                if (method.returnType.isVoid) {
                  indent.writeln('$call;');
                  indent.writeln('res.push(null);');
                } else {
                  if (method.returnType.isEnum) {
                    final String newCall =
                        'api!.${method.name}(args[0] as $returnType).toString()';
                    indent.writeln(
                        'let output: $returnType$_enumCompanionSuffix = new $returnType$_enumCompanionSuffix($newCall);');
                  } else {
                    indent.writeln('let output: $returnType = $call;');
                  }
                  indent.writeln('res.push(output);');
                }
              });
              indent.add(' catch (error) ');
              indent.addScoped('{', '}', () {
                indent.writeln(
                    'let wrappedError: Array<Object> = wrapError(error);');
                if (method.isAsynchronous) {
                  indent.writeln('reply.reply(wrappedError);');
                } else {
                  indent.writeln('res = wrappedError;');
                }
              });
              indent.writeln('reply.reply(res);');
            }
          });
        });
      });
      indent.addScoped(null, '}', () {
        indent.writeln('channel.setMessageHandler(null);');
      });
    });
  }

  void _writeInterfaceMethod(InternalArkTSOptions generatorOptions, Root root,
      Indent indent, Api api, final Method method) {
    final String returnType = method.isAsynchronous
        ? 'void'
        : _arkTSTypeForDartType(method.returnType);

    final List<String> argSignature = <String>[];
    if (method.parameters.isNotEmpty) {
      final Iterable<String> argTypes =
          method.parameters.map((NamedType e) => _arkTSTypeForDartType(e.type));
      final Iterable<String> argNames =
          method.parameters.map((NamedType e) => e.name);
      argSignature
          .addAll(map2(argTypes, argNames, (String argType, String argName) {
        return '$argName: $argType ';
      }));
    }
    if (method.isAsynchronous) {
      final String resultType = method.returnType.isVoid
          ? 'void'
          : _arkTSTypeForDartType(method.returnType);
      argSignature.add('result: Result<$resultType>');
    }
    if (method.documentationComments.isNotEmpty) {
      addDocumentationComments(
          indent, method.documentationComments, _docCommentSpec);
    } else {
      indent.newln();
    }
    indent.writeln(
        'abstract ${method.name}(${argSignature.join(', ')}): $returnType;');
  }

  void _writeResultInterface(Indent indent) {
    indent.write('export interface Result<T> ');
    indent.addScoped('{', '}', () {
      indent.writeln('success( result: T ): void;');
      indent.newln();
      indent.writeln('error( error: Error): void;');
    });
  }

  void _writeErrorClass(Indent indent) {
    indent.writeln(
        '/** Error class for passing custom error details to Flutter via a thrown PlatformException. */');
    indent.write('export class FlutterError implements Error ');
    indent.addScoped('{', '}', () {
      indent.newln();
      indent.writeln('/** The error code. */');
      indent.writeln('public code: string;');
      indent.newln();
      indent.writeln('/** The error name. */');
      indent.writeln('public name: string;');
      indent.newln();
      indent.writeln('/** The error message. */');
      indent.writeln('public message: string;');
      indent.writeln('/** The error stack. */');
      indent.writeln('public stack?: string;');
      indent.newln();
      indent.writeln(
          'constructor(code: string, name: string,  message: string, stack?: string) ');
      indent.writeScoped('{', '}', () {
        indent.writeln('this.code = code;');
        indent.writeln('this.name = name;');
        indent.writeln('this.message = message;');
        indent.writeln('this.stack = stack;');
      });
    });
  }

  void _writeWrapError(Indent indent) {
    indent.format('''
function wrapError(error: Error): Array<Object> {
\tlet errorList: Array<Object> = new Array<Object>(3);
\tif (error instanceof FlutterError) {
\t\tlet err: FlutterError = error as FlutterError;
\t\terrorList[0] = err.code;
\t\terrorList[1] = err.name;
\t\terrorList[2] = err.message;
\t} else {
\t\terrorList[0] = error.toString();
\t\terrorList[1] = error.name;
\t\terrorList[2] = "Cause: " + error.message + ", Stacktrace: " + error.stack;
\t}
\treturn errorList;
}''');
  }

  void _writeCreateConnectionError(Indent indent) {
    indent.writeScoped(
        'function createConnectionError(channelName: string ): FlutterError {',
        '}', () {
      indent.writeln(
          'return new FlutterError("channel-error",  "Unable to establish connection on channel: " + channelName + ".", "");');
    });
  }

  void _writeGetByteMethoe(Indent indent) {
    indent.format('''
getByte(n: number): number {
\tlet byteArray = new Uint8Array(1);
\tbyteArray[0] = n;
\treturn byteArray[0] as number;
}''');
  }

  @override
  void writeGeneralUtilities(
    InternalArkTSOptions generatorOptions,
    Root root,
    Indent indent, {
    required String dartPackageName,
  }) {
    final bool hasHostApi = root.apis
        .whereType<AstHostApi>()
        .any((Api api) => api.methods.isNotEmpty);
    final bool hasFlutterApi = root.apis
        .whereType<AstFlutterApi>()
        .any((Api api) => api.methods.isNotEmpty);

    indent.newln();
    _writeErrorClass(indent);

    if (hasHostApi) {
      indent.newln();
      _writeWrapError(indent);
    }
    if (hasFlutterApi) {
      indent.newln();

      ///_writeCreateConnectionError(indent);
    }
  }

  /// Converts an expression that evaluates to an nullable int to an expression
  /// that evaluates to a nullable enum.
  String _intToEnum(String expression, String enumName, bool nullable) =>
      nullable
          ? '$expression == null ? null : $enumName[$expression as number]'
          : '$enumName[$expression as number]';

  String _getArgumentName(int count, NamedType argument) =>
      argument.name.isEmpty ? 'arg$count' : argument.name;

  String _getSafeArgumentName(int count, NamedType argument) =>
      '${_getArgumentName(count, argument)}Arg';
  String getSafeConstructorArgument(String argument) {
    return (argument == 'arguments') ? 'argumentsArg' : argument;
  }

// get函数
  String _makeGetter(NamedType field) {
    final String uppercased =
        field.name.substring(0, 1).toUpperCase() + field.name.substring(1);
    return 'get$uppercased';
  }

  /// Returns an expression to cast [variable] to [artTSType].
  String _cast(String variable, {required String artTSType}) {
    // Special-case object, since casting to object doesn't do anything, and
    // causes a warning.
    return artTSType == 'Object' ? variable : '$variable as $artTSType';
  }

  String _arkTSTypeForDartType(TypeDeclaration type) {
    return _arkTSTypeForBuiltinDartType(type) ?? type.baseName;
  }

  /// Converts a [List] of [TypeDeclaration]s to a comma separated [String] to be
  String _flattenTypeArguments(List<TypeDeclaration> args) {
    return args.map<String>(_arkTSTypeForDartType).join(', ');
  }

  String _arkTSTypeForBuiltinGenericDartType(
    TypeDeclaration type,
    int numberTypeArguments,
  ) {
    final String typeName = type.baseName == 'List' ? 'Array' : type.baseName;
    if (type.typeArguments.isEmpty) {
      return '$typeName<${repeat('Object', numberTypeArguments).join(', ')}>';
    } else {
      return '$typeName<${_flattenTypeArguments(type.typeArguments)}>';
    }
  }

  String? _arkTSTypeForBuiltinDartType(TypeDeclaration type) {
    const Map<String, String> arkTSTypeForDartTypeMap = <String, String>{
      'bool': 'boolean',
      'int': 'number',
      'String': 'string',
      'double': 'number',
      'Uint8List': 'number[]',
      'Int32List': 'number[]',
      'Int64List': 'number[]',
      'Float64List': 'number[]',
      'Object': 'Object',
      _forceInt: 'number',
    };
    if (arkTSTypeForDartTypeMap.containsKey(type.baseName)) {
      return arkTSTypeForDartTypeMap[type.baseName];
    } else if (type.baseName == 'List') {
      return _arkTSTypeForBuiltinGenericDartType(type, 1);
    } else if (type.baseName == 'Map') {
      return _arkTSTypeForBuiltinGenericDartType(type, 2);
    } else {
      return null;
    }
  }

  @override
  void writeGeneralCodec(
      InternalArkTSOptions generatorOptions, Root root, Indent indent,
      {required String dartPackageName}) {
    final List<EnumeratedType> enumeratedTypes =
        getEnumeratedTypes(root).toList();
    void writeEncodeLogic(EnumeratedType customType) {
      bool isEnum = customType.type == CustomTypes.customEnum;
      final String nullCheck = customType.type == CustomTypes.customEnum
          ? 'value == null ? null : '
          : '';
      String valueString = '';
      if (isEnum) {
        valueString = customType.enumeration < maximumCodecFieldKey
            ? '$nullCheck${customType.name}[value.index as string]'
            : 'wrap.toList()';
      } else {
        valueString = customType.enumeration < maximumCodecFieldKey
            ? '$nullCheck(value as ${customType.name}).toList()'
            : 'wrap.toList()';
      }

      final int enumeration = customType.enumeration < maximumCodecFieldKey
          ? customType.enumeration
          : maximumCodecFieldKey;
      final bool isCustom = customType.type == CustomTypes.customClass;
      if (isCustom) {
        indent.add('if (value instanceof ${customType.name}) ');
        indent.addScoped('{', '} else ', () {
          if (customType.enumeration >= maximumCodecFieldKey) {
            indent.writeln(
                'let wrap:$_overflowClassName = new $_overflowClassName();');
            indent.writeln(
                'wrap.setType(${customType.enumeration - maximumCodecFieldKey});');

            indent.writeln(
                'wrap.setWrapped($nullCheck(value as ${customType.name}).toList());');
          }
          indent.writeln('stream.writeUint8(this.getByte(${enumeration}));');
          indent.writeln('this.writeValue(stream, $valueString);');
        }, addTrailingNewline: false);
      } else {
        indent.add(
            'if (value instanceof ${customType.name}$_enumCompanionSuffix) ');
        indent.addScoped('{', '} else ', () {
          if (customType.enumeration >= maximumCodecFieldKey) {
            indent.writeln(
                'let wrap:$_overflowClassName = new $_overflowClassName();');
            indent.writeln(
                'wrap.setType(${customType.enumeration - maximumCodecFieldKey});');
            indent.writeln(
                'wrap.setWrapped($nullCheck(value as ${customType.name}).toList());');
          }
          indent.writeln('stream.writeUint8(this.getByte($enumeration));');
          indent.writeln('this.writeValue(stream, $valueString);');
        }, addTrailingNewline: false);
      }
    }

    void writeDecodeLogic(EnumeratedType customType) {
      indent.write('case this.getByte(${customType.enumeration}):');
      if (customType.type == CustomTypes.customClass) {
        indent.newln();
        indent.nest(1, () {
          indent.writeln(
              'return ${customType.name}.fromList(super.readValue(buffer) as Object[]);');
        });
      } else if (customType.type == CustomTypes.customEnum) {
        indent.addScoped(' {', '}', () {
          indent.writeln('let value: Object= super.readValue(buffer);');
          indent
              .writeln('return ${_intToEnum('value', customType.name, true)};');
        });
      }
    }

    final EnumeratedType overflowClass = EnumeratedType(
        _overflowClassName, maximumCodecFieldKey, CustomTypes.customClass);

    if (root.requiresOverflowClass) {
      _writeCodecOverflowUtilities(
        generatorOptions,
        root,
        indent,
        enumeratedTypes,
        dartPackageName: dartPackageName,
      );
    }
    indent.newln();
    indent.write('class $_codecName extends StandardMessageCodec ');
    indent.addScoped('{', '}', () {
      indent.writeln(
          'static readonly INSTANCE: $_codecName  = new $_codecName();');
      indent.newln();
      _writeGetByteMethoe(indent);

      ///构造
      indent.writeScoped('private constructor() {', '}', () {
        indent.writeln('super();');
      });
      indent.newln();
      indent.writeScoped(
          'readValueOfType(type: number,  buffer: ByteBuffer): ESObject {', '}',
          () {
        indent.writeScoped('switch (type) {', '}', () {
          for (final EnumeratedType customType in enumeratedTypes) {
            if (customType.enumeration < maximumCodecFieldKey) {
              writeDecodeLogic(customType);
            }
          }
          if (root.requiresOverflowClass) {
            writeDecodeLogic(overflowClass);
          }
          indent.writeln('default:');
          indent.nest(1, () {
            indent.writeln('return super.readValueOfType(type, buffer);');
          });
        });
      });
      indent.newln();
      indent
          .write('writeValue(stream: ByteBuffer , value: ESObject): ESObject');
      indent.addScoped('{', '}', () {
        indent.write('');
        enumeratedTypes.forEach(writeEncodeLogic);
        indent.addScoped('{', '}', () {
          indent.writeln('super.writeValue(stream, value);');
        });
      });
    });
    indent.newln();
  }

  void _writeCodecOverflowUtilities(
    InternalArkTSOptions generatorOptions,
    Root root,
    Indent indent,
    List<EnumeratedType> types, {
    required String dartPackageName,
  }) {
    final NamedType overflowInteration = NamedType(
        name: 'type',
        type: const TypeDeclaration(baseName: _forceInt, isNullable: false));
    final NamedType overflowObject = NamedType(
        name: 'wrapped',
        type: const TypeDeclaration(baseName: 'Object', isNullable: true));
    final List<NamedType> overflowFields = <NamedType>[
      overflowInteration,
      overflowObject,
    ];
    final Class overflowClass =
        Class(name: _overflowClassName, fields: overflowFields);

    _writeDataClassSignature(
      generatorOptions,
      indent,
      overflowClass,
      () {
        writeClassEncode(
          generatorOptions,
          root,
          indent,
          overflowClass,
          dartPackageName: dartPackageName,
        );

        indent.format('''
static @Nullable Object fromList(@NonNull ArrayList<Object> ${varNamePrefix}list) {
  $_overflowClassName wrapper = new $_overflowClassName();
  wrapper.setType((int) ${varNamePrefix}list.get(0));
  wrapper.setWrapped(${varNamePrefix}list.get(1));
  return wrapper.unwrap();
}
''');

        indent.writeScoped('@Nullable Object unwrap() {', '}', () {
          indent.format('''
if (wrapped == null) {
  return null;
}
    ''');
          indent.writeScoped('switch (type) {', '}', () {
            for (int i = totalCustomCodecKeysAllowed; i < types.length; i++) {
              indent.writeln('case ${i - totalCustomCodecKeysAllowed}:');
              indent.nest(1, () {
                if (types[i].type == CustomTypes.customClass) {
                  indent.writeln(
                      'return ${types[i].name}.fromList((ArrayList<Object>) wrapped);');
                } else if (types[i].type == CustomTypes.customEnum) {
                  indent.writeln(
                      'return ${types[i].name}.values()[(int) wrapped];');
                }
              });
            }
          });
          indent.writeln('return null;');
        });
      },
      private: true,
    );
  }
}
