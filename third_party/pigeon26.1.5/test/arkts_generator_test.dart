// Copyright 2013 The Flutter Authors
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:pigeon/src/ast.dart';
import 'package:pigeon/src/arkts/arkts_generator.dart';
import 'package:test/test.dart';

const String DEFAULT_PACKAGE_NAME = 'test_package';

final Class emptyClass = Class(
  name: 'className',
  fields: <NamedType>[
    NamedType(
      name: 'namedTypeName',
      type: const TypeDeclaration(baseName: 'baseName', isNullable: false),
    ),
  ],
);

final Enum emptyEnum = Enum(
  name: 'enumName',
  members: <EnumMember>[EnumMember(name: 'enumMemberName')],
);

void main() {
  test('gen one class', () {
    final classDefinition = Class(
      name: 'Foobar',
      fields: <NamedType>[
        NamedType(
          type: const TypeDeclaration(baseName: 'int', isNullable: true),
          name: 'field1',
        ),
      ],
    );
    final root = Root(
      apis: <Api>[],
      classes: <Class>[classDefinition],
      enums: <Enum>[],
    );
    final sink = StringBuffer();
    const arkTSOptions = InternalArkTSOptions(arkTSOut: '');
    const generator = ArkTSGenerator();
    generator.generate(
      arkTSOptions,
      root,
      sink,
      dartPackageName: DEFAULT_PACKAGE_NAME,
    );
    final code = sink.toString();
    expect(code, contains('export class Foobar'));
    expect(code, contains('private field1?: number;'));
    expect(code, contains('toList(): Object[]'));
    expect(code, contains('static fromList(arr: Object[]): Foobar'));
  });

  test('gen one enum', () {
    final anEnum = Enum(
      name: 'Foobar',
      members: <EnumMember>[
        EnumMember(name: 'one'),
        EnumMember(name: 'twoThreeFour'),
        EnumMember(name: 'remoteDB'),
      ],
    );
    final root = Root(apis: <Api>[], classes: <Class>[], enums: <Enum>[anEnum]);
    final sink = StringBuffer();
    const arkTSOptions = InternalArkTSOptions(arkTSOut: '');
    const generator = ArkTSGenerator();
    generator.generate(
      arkTSOptions,
      root,
      sink,
      dartPackageName: DEFAULT_PACKAGE_NAME,
    );
    final code = sink.toString();
    expect(code, contains('export enum Foobar'));
    expect(code, contains('ONE,'));
    expect(code, contains('TWO_THREE_FOUR,'));
    expect(code, contains('REMOTE_DB'));
    expect(code, contains('export class FoobarEnum'));
    expect(code, contains('index: string|null = null;'));
  });

  test('gen one host api', () {
    final root = Root(
      apis: <Api>[
        AstHostApi(
          name: 'Api',
          methods: <Method>[
            Method(
              name: 'doSomething',
              location: ApiLocation.host,
              parameters: <Parameter>[
                Parameter(
                  type: TypeDeclaration(
                    baseName: 'Input',
                    associatedClass: emptyClass,
                    isNullable: false,
                  ),
                  name: '',
                ),
              ],
              returnType: TypeDeclaration(
                baseName: 'Output',
                associatedClass: emptyClass,
                isNullable: false,
              ),
            ),
          ],
        ),
      ],
      classes: <Class>[
        Class(
          name: 'Input',
          fields: <NamedType>[
            NamedType(
              type: const TypeDeclaration(baseName: 'String', isNullable: true),
              name: 'input',
            ),
          ],
        ),
        Class(
          name: 'Output',
          fields: <NamedType>[
            NamedType(
              type: const TypeDeclaration(baseName: 'String', isNullable: true),
              name: 'output',
            ),
          ],
        ),
      ],
      enums: <Enum>[],
      containsHostApi: true,
    );
    final sink = StringBuffer();
    const arkTSOptions = InternalArkTSOptions(arkTSOut: '');
    const generator = ArkTSGenerator();
    generator.generate(
      arkTSOptions,
      root,
      sink,
      dartPackageName: DEFAULT_PACKAGE_NAME,
    );
    final code = sink.toString();
    expect(code, contains('export abstract class Api'));
    expect(code, contains('abstract doSomething(: Input ): Output;'));
    expect(code, contains('static setup(binaryMessenger: BinaryMessenger, api: Api | null): void'));
    expect(code, contains('channel.setMessageHandler(null)'));
    expect(code, contains('class PigeonCodec extends StandardMessageCodec'));
  });

  test('gen one flutter api', () {
    final root = Root(
      apis: <Api>[
        AstFlutterApi(
          name: 'Api',
          methods: <Method>[
            Method(
              name: 'doSomething',
              location: ApiLocation.flutter,
              parameters: <Parameter>[
                Parameter(
                  type: TypeDeclaration(
                    baseName: 'Input',
                    associatedClass: emptyClass,
                    isNullable: false,
                  ),
                  name: 'input',
                ),
              ],
              returnType: TypeDeclaration(
                baseName: 'Output',
                associatedClass: emptyClass,
                isNullable: false,
              ),
            ),
          ],
        ),
      ],
      classes: <Class>[
        Class(
          name: 'Input',
          fields: <NamedType>[
            NamedType(
              type: const TypeDeclaration(baseName: 'String', isNullable: true),
              name: 'input',
            ),
          ],
        ),
        Class(
          name: 'Output',
          fields: <NamedType>[
            NamedType(
              type: const TypeDeclaration(baseName: 'String', isNullable: true),
              name: 'output',
            ),
          ],
        ),
      ],
      enums: <Enum>[],
    );
    final sink = StringBuffer();
    const arkTSOptions = InternalArkTSOptions(arkTSOut: '');
    const generator = ArkTSGenerator();
    generator.generate(
      arkTSOptions,
      root,
      sink,
      dartPackageName: DEFAULT_PACKAGE_NAME,
    );
    final code = sink.toString();
    expect(code, contains('export class Api'));
    expect(code, contains('binaryMessenger: BinaryMessenger;'));
    expect(code, contains('constructor(binaryMessenger: BinaryMessenger)'));
    expect(code, contains('doSomething'));
    expect(code, contains('Input'));
    expect(code, contains('Output'));
    expect(code, contains('static getCodec(): MessageCodec<Object>'));
  });

  test('gen host void api', () {
    final root = Root(
      apis: <Api>[
        AstHostApi(
          name: 'Api',
          methods: <Method>[
            Method(
              name: 'doSomething',
              location: ApiLocation.host,
              parameters: <Parameter>[],
              returnType: const TypeDeclaration.voidDeclaration(),
            ),
          ],
        ),
      ],
      classes: <Class>[],
      enums: <Enum>[],
      containsHostApi: true,
    );
    final sink = StringBuffer();
    const arkTSOptions = InternalArkTSOptions(arkTSOut: '');
    const generator = ArkTSGenerator();
    generator.generate(
      arkTSOptions,
      root,
      sink,
      dartPackageName: DEFAULT_PACKAGE_NAME,
    );
    final code = sink.toString();
    expect(code, contains('abstract doSomething(): void;'));
  });

  test('gen flutter void return api', () {
    final root = Root(
      apis: <Api>[
        AstFlutterApi(
          name: 'Api',
          methods: <Method>[
            Method(
              name: 'doSomething',
              location: ApiLocation.flutter,
              parameters: <Parameter>[
                Parameter(
                  type: const TypeDeclaration(baseName: 'String', isNullable: false),
                  name: 'input',
                ),
              ],
              returnType: const TypeDeclaration.voidDeclaration(),
            ),
          ],
        ),
      ],
      classes: <Class>[],
      enums: <Enum>[],
    );
    final sink = StringBuffer();
    const arkTSOptions = InternalArkTSOptions(arkTSOut: '');
    const generator = ArkTSGenerator();
    generator.generate(
      arkTSOptions,
      root,
      sink,
      dartPackageName: DEFAULT_PACKAGE_NAME,
    );
    final code = sink.toString();
    expect(code, contains('doSomething'));
    expect(code, contains('callback: Reply<void>'));
  });

  test('gen host void argument api', () {
    final root = Root(
      apis: <Api>[
        AstHostApi(
          name: 'Api',
          methods: <Method>[
            Method(
              name: 'doSomething',
              location: ApiLocation.host,
              parameters: <Parameter>[],
              returnType: const TypeDeclaration(baseName: 'String', isNullable: false),
            ),
          ],
        ),
      ],
      classes: <Class>[],
      enums: <Enum>[],
      containsHostApi: true,
    );
    final sink = StringBuffer();
    const arkTSOptions = InternalArkTSOptions(arkTSOut: '');
    const generator = ArkTSGenerator();
    generator.generate(
      arkTSOptions,
      root,
      sink,
      dartPackageName: DEFAULT_PACKAGE_NAME,
    );
    final code = sink.toString();
    expect(code, contains('abstract doSomething(): string;'));
  });

  test('gen flutter void argument api', () {
    final root = Root(
      apis: <Api>[
        AstFlutterApi(
          name: 'Api',
          methods: <Method>[
            Method(
              name: 'doSomething',
              location: ApiLocation.flutter,
              parameters: <Parameter>[],
              returnType: const TypeDeclaration(baseName: 'String', isNullable: false),
            ),
          ],
        ),
      ],
      classes: <Class>[],
      enums: <Enum>[],
    );
    final sink = StringBuffer();
    const arkTSOptions = InternalArkTSOptions(arkTSOut: '');
    const generator = ArkTSGenerator();
    generator.generate(
      arkTSOptions,
      root,
      sink,
      dartPackageName: DEFAULT_PACKAGE_NAME,
    );
    final code = sink.toString();
    expect(code, contains('doSomething(callback: Reply<string>)'));
  });

  test('gen list', () {
    final root = Root(
      apis: <Api>[],
      classes: <Class>[
        Class(
          name: 'Foobar',
          fields: <NamedType>[
            NamedType(
              type: const TypeDeclaration(baseName: 'List', isNullable: true),
              name: 'field1',
            ),
          ],
        ),
      ],
      enums: <Enum>[],
    );
    final sink = StringBuffer();
    const arkTSOptions = InternalArkTSOptions(arkTSOut: '');
    const generator = ArkTSGenerator();
    generator.generate(
      arkTSOptions,
      root,
      sink,
      dartPackageName: DEFAULT_PACKAGE_NAME,
    );
    final code = sink.toString();
    expect(code, contains('export class Foobar'));
    expect(code, contains('private field1?: Array<Object>;'));
  });

  test('gen map', () {
    final root = Root(
      apis: <Api>[],
      classes: <Class>[
        Class(
          name: 'Foobar',
          fields: <NamedType>[
            NamedType(
              type: const TypeDeclaration(baseName: 'Map', isNullable: true),
              name: 'field1',
            ),
          ],
        ),
      ],
      enums: <Enum>[],
    );
    final sink = StringBuffer();
    const arkTSOptions = InternalArkTSOptions(arkTSOut: '');
    const generator = ArkTSGenerator();
    generator.generate(
      arkTSOptions,
      root,
      sink,
      dartPackageName: DEFAULT_PACKAGE_NAME,
    );
    final code = sink.toString();
    expect(code, contains('export class Foobar'));
    expect(code, contains('private field1?: Map<Object, Object>;'));
  });

  test('gen nested', () {
    final classDefinition = Class(
      name: 'Outer',
      fields: <NamedType>[
        NamedType(
          type: TypeDeclaration(
            baseName: 'Nested',
            associatedClass: emptyClass,
            isNullable: true,
          ),
          name: 'nested',
        ),
      ],
    );
    final nestedClass = Class(
      name: 'Nested',
      fields: <NamedType>[
        NamedType(
          type: const TypeDeclaration(baseName: 'int', isNullable: true),
          name: 'data',
        ),
      ],
    );
    final root = Root(
      apis: <Api>[],
      classes: <Class>[classDefinition, nestedClass],
      enums: <Enum>[],
    );
    final sink = StringBuffer();
    const arkTSOptions = InternalArkTSOptions(arkTSOut: '');
    const generator = ArkTSGenerator();
    generator.generate(
      arkTSOptions,
      root,
      sink,
      dartPackageName: DEFAULT_PACKAGE_NAME,
    );
    final code = sink.toString();
    expect(code, contains('export class Outer'));
    expect(code, contains('export class Nested'));
    expect(code, contains('private nested?: Nested;'));
    expect(code, contains('private data?: number;'));
  });

  test('gen one async Host Api', () {
    final root = Root(
      apis: <Api>[
        AstHostApi(
          name: 'Api',
          methods: <Method>[
            Method(
              name: 'doSomething',
              location: ApiLocation.host,
              parameters: <Parameter>[
                Parameter(
                  type: TypeDeclaration(
                    baseName: 'Input',
                    associatedClass: emptyClass,
                    isNullable: false,
                  ),
                  name: '',
                ),
              ],
              returnType: TypeDeclaration(
                baseName: 'Output',
                associatedClass: emptyClass,
                isNullable: false,
              ),
              isAsynchronous: true,
            ),
          ],
        ),
      ],
      classes: <Class>[
        Class(
          name: 'Input',
          fields: <NamedType>[
            NamedType(
              type: const TypeDeclaration(baseName: 'String', isNullable: true),
              name: 'input',
            ),
          ],
        ),
        Class(
          name: 'Output',
          fields: <NamedType>[
            NamedType(
              type: const TypeDeclaration(baseName: 'String', isNullable: true),
              name: 'output',
            ),
          ],
        ),
      ],
      enums: <Enum>[],
      containsHostApi: true,
    );
    final sink = StringBuffer();
    const arkTSOptions = InternalArkTSOptions(arkTSOut: '');
    const generator = ArkTSGenerator();
    generator.generate(
      arkTSOptions,
      root,
      sink,
      dartPackageName: DEFAULT_PACKAGE_NAME,
    );
    final code = sink.toString();
    expect(code, contains('export interface Result<T>'));
    expect(code, contains('abstract doSomething(: Input , result: Result<Output>): void;'));
    expect(code, contains('success( result: T ): void;'));
    expect(code, contains('error( error: Error): void;'));
  });

  test('gen one async Flutter Api', () {
    final root = Root(
      apis: <Api>[
        AstFlutterApi(
          name: 'Api',
          methods: <Method>[
            Method(
              name: 'doSomething',
              location: ApiLocation.flutter,
              parameters: <Parameter>[
                Parameter(
                  type: TypeDeclaration(
                    baseName: 'Input',
                    associatedClass: emptyClass,
                    isNullable: false,
                  ),
                  name: 'input',
                ),
              ],
              returnType: TypeDeclaration(
                baseName: 'Output',
                associatedClass: emptyClass,
                isNullable: false,
              ),
              isAsynchronous: true,
            ),
          ],
        ),
      ],
      classes: <Class>[
        Class(
          name: 'Input',
          fields: <NamedType>[
            NamedType(
              type: const TypeDeclaration(baseName: 'String', isNullable: true),
              name: 'input',
            ),
          ],
        ),
        Class(
          name: 'Output',
          fields: <NamedType>[
            NamedType(
              type: const TypeDeclaration(baseName: 'String', isNullable: true),
              name: 'output',
            ),
          ],
        ),
      ],
      enums: <Enum>[],
    );
    final sink = StringBuffer();
    const arkTSOptions = InternalArkTSOptions(arkTSOut: '');
    const generator = ArkTSGenerator();
    generator.generate(
      arkTSOptions,
      root,
      sink,
      dartPackageName: DEFAULT_PACKAGE_NAME,
    );
    final code = sink.toString();
    expect(code, contains('doSomething'));
    expect(code, contains('callback: Reply<Output>'));
  });

  test('gen one enum class', () {
    final anEnum = Enum(
      name: 'Foo',
      members: <EnumMember>[
        EnumMember(name: 'one'),
        EnumMember(name: 'two'),
      ],
    );
    final root = Root(
      apis: <Api>[],
      classes: <Class>[
        Class(
          name: 'Bar',
          fields: <NamedType>[
            NamedType(
              name: 'field1',
              type: TypeDeclaration(
                baseName: 'Foo',
                isNullable: false,
                associatedEnum: anEnum,
              ),
            ),
          ],
        ),
      ],
      enums: <Enum>[anEnum],
    );
    final sink = StringBuffer();
    const arkTSOptions = InternalArkTSOptions(arkTSOut: '');
    const generator = ArkTSGenerator();
    generator.generate(
      arkTSOptions,
      root,
      sink,
      dartPackageName: DEFAULT_PACKAGE_NAME,
    );
    final code = sink.toString();
    expect(code, contains('export enum Foo'));
    expect(code, contains('export class Bar'));
    expect(code, contains('private field1?: Foo;'));
    expect(code, contains('export class FooEnum'));
  });

  test('primitive enum host', () {
    final root = Root(
      apis: <Api>[
        AstHostApi(
          name: 'Bar',
          methods: <Method>[
            Method(
              name: 'bar',
              location: ApiLocation.host,
              returnType: const TypeDeclaration.voidDeclaration(),
              parameters: <Parameter>[
                Parameter(
                  name: 'foo',
                  type: TypeDeclaration(
                    baseName: 'Foo',
                    isNullable: false,
                    associatedEnum: emptyEnum,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
      classes: <Class>[],
      enums: <Enum>[emptyEnum],
      containsHostApi: true,
    );
    final sink = StringBuffer();
    const arkTSOptions = InternalArkTSOptions(arkTSOut: '');
    const generator = ArkTSGenerator();
    generator.generate(
      arkTSOptions,
      root,
      sink,
      dartPackageName: DEFAULT_PACKAGE_NAME,
    );
    final code = sink.toString();
    expect(code, contains('abstract bar'));
    expect(code, contains('foo:'));
  });

  test('all the simple datatypes', () {
    final root = Root(
      apis: <Api>[],
      classes: <Class>[
        Class(
          name: 'Foobar',
          fields: <NamedType>[
            NamedType(
              type: const TypeDeclaration(baseName: 'bool', isNullable: true),
              name: 'aBool',
            ),
            NamedType(
              type: const TypeDeclaration(baseName: 'int', isNullable: true),
              name: 'aInt',
            ),
            NamedType(
              type: const TypeDeclaration(baseName: 'double', isNullable: true),
              name: 'aDouble',
            ),
            NamedType(
              type: const TypeDeclaration(baseName: 'String', isNullable: true),
              name: 'aString',
            ),
            NamedType(
              type: const TypeDeclaration(
                baseName: 'Uint8List',
                isNullable: true,
              ),
              name: 'aUint8List',
            ),
            NamedType(
              type: const TypeDeclaration(
                baseName: 'Int32List',
                isNullable: true,
              ),
              name: 'aInt32List',
            ),
            NamedType(
              type: const TypeDeclaration(
                baseName: 'Int64List',
                isNullable: true,
              ),
              name: 'aInt64List',
            ),
            NamedType(
              type: const TypeDeclaration(
                baseName: 'Float64List',
                isNullable: true,
              ),
              name: 'aFloat64List',
            ),
          ],
        ),
      ],
      enums: <Enum>[],
    );

    final sink = StringBuffer();
    const arkTSOptions = InternalArkTSOptions(arkTSOut: '');
    const generator = ArkTSGenerator();
    generator.generate(
      arkTSOptions,
      root,
      sink,
      dartPackageName: DEFAULT_PACKAGE_NAME,
    );
    final code = sink.toString();
    expect(code, contains('private aBool?: boolean;'));
    expect(code, contains('private aInt?: number;'));
    expect(code, contains('private aDouble?: number;'));
    expect(code, contains('private aString?: string;'));
    expect(code, contains('private aUint8List?: number[];'));
    expect(code, contains('private aInt32List?: number[];'));
    expect(code, contains('private aInt64List?: number[];'));
    expect(code, contains('private aFloat64List?: number[];'));
  });

  test('host multiple args', () {
    final root = Root(
      apis: <Api>[
        AstHostApi(
          name: 'Api',
          methods: <Method>[
            Method(
              name: 'doSomething',
              location: ApiLocation.host,
              parameters: <Parameter>[
                Parameter(
                  type: const TypeDeclaration(baseName: 'String', isNullable: false),
                  name: 'arg1',
                ),
                Parameter(
                  type: const TypeDeclaration(baseName: 'int', isNullable: false),
                  name: 'arg2',
                ),
                Parameter(
                  type: const TypeDeclaration(baseName: 'bool', isNullable: false),
                  name: 'arg3',
                ),
              ],
              returnType: const TypeDeclaration(baseName: 'String', isNullable: false),
            ),
          ],
        ),
      ],
      classes: <Class>[],
      enums: <Enum>[],
      containsHostApi: true,
    );
    final sink = StringBuffer();
    const arkTSOptions = InternalArkTSOptions(arkTSOut: '');
    const generator = ArkTSGenerator();
    generator.generate(
      arkTSOptions,
      root,
      sink,
      dartPackageName: DEFAULT_PACKAGE_NAME,
    );
    final code = sink.toString();
    expect(code, contains('abstract doSomething(arg1: string'));
    expect(code, contains('arg2: number'));
    expect(code, contains('arg3: boolean'));
    expect(code, contains(': string;'));
  });

  test('flutter multiple args', () {
    final root = Root(
      apis: <Api>[
        AstFlutterApi(
          name: 'Api',
          methods: <Method>[
            Method(
              name: 'doSomething',
              location: ApiLocation.flutter,
              parameters: <Parameter>[
                Parameter(
                  type: const TypeDeclaration(baseName: 'String', isNullable: false),
                  name: 'arg1',
                ),
                Parameter(
                  type: const TypeDeclaration(baseName: 'int', isNullable: false),
                  name: 'arg2',
                ),
              ],
              returnType: const TypeDeclaration(baseName: 'String', isNullable: false),
            ),
          ],
        ),
      ],
      classes: <Class>[],
      enums: <Enum>[],
    );
    final sink = StringBuffer();
    const arkTSOptions = InternalArkTSOptions(arkTSOut: '');
    const generator = ArkTSGenerator();
    generator.generate(
      arkTSOptions,
      root,
      sink,
      dartPackageName: DEFAULT_PACKAGE_NAME,
    );
    final code = sink.toString();
    expect(code, contains('doSomething'));
    expect(code, contains('arg1'));
    expect(code, contains('arg2'));
    expect(code, contains('callback: Reply<string>'));
  });

  test('copyright header', () {
    final classDefinition = Class(
      name: 'Foobar',
      fields: <NamedType>[],
    );
    final root = Root(
      apis: <Api>[],
      classes: <Class>[classDefinition],
      enums: <Enum>[],
    );
    final sink = StringBuffer();
    const arkTSOptions = InternalArkTSOptions(
      arkTSOut: '',
      copyrightHeader: <String>['Copyright 2023', 'Test Header'],
    );
    const generator = ArkTSGenerator();
    generator.generate(
      arkTSOptions,
      root,
      sink,
      dartPackageName: DEFAULT_PACKAGE_NAME,
    );
    final code = sink.toString();
    expect(code, contains('/*'));
    expect(code, contains('* Copyright 2023'));
    expect(code, contains('* Test Header'));
    expect(code, contains('*/'));
  });

  test('imports', () {
    final root = Root(
      apis: <Api>[],
      classes: <Class>[],
      enums: <Enum>[],
    );
    final sink = StringBuffer();
    const arkTSOptions = InternalArkTSOptions(arkTSOut: '');
    const generator = ArkTSGenerator();
    generator.generate(
      arkTSOptions,
      root,
      sink,
      dartPackageName: DEFAULT_PACKAGE_NAME,
    );
    final code = sink.toString();
    expect(code, contains("import StandardMessageCodec from '@ohos/flutter_ohos/src/main/ets/plugin/common/StandardMessageCodec';"));
    expect(code, contains("import BasicMessageChannel, { Reply } from '@ohos/flutter_ohos/src/main/ets/plugin/common/BasicMessageChannel';"));
    expect(code, contains("import { BinaryMessenger,TaskQueue } from '@ohos/flutter_ohos/src/main/ets/plugin/common/BinaryMessenger';"));
    expect(code, contains("import MessageCodec from '@ohos/flutter_ohos/src/main/ets/plugin/common/MessageCodec';"));
    expect(code, contains("import { ByteBuffer } from '@ohos/flutter_ohos/src/main/ets/util/ByteBuffer';"));
  });

  test('codec class', () {
    final root = Root(
      apis: <Api>[
        AstHostApi(
          name: 'Api',
          methods: <Method>[],
        ),
      ],
      classes: <Class>[],
      enums: <Enum>[],
      containsHostApi: true,
    );
    final sink = StringBuffer();
    const arkTSOptions = InternalArkTSOptions(arkTSOut: '');
    const generator = ArkTSGenerator();
    generator.generate(
      arkTSOptions,
      root,
      sink,
      dartPackageName: DEFAULT_PACKAGE_NAME,
    );
    final code = sink.toString();
    expect(code, contains('class PigeonCodec extends StandardMessageCodec'));
    expect(code, contains('static readonly INSTANCE: PigeonCodec  = new PigeonCodec();'));
    expect(code, contains('readValueOfType(type: number,  buffer: ByteBuffer): ESObject'));
    expect(code, contains('writeValue(stream: ByteBuffer , value: ESObject): ESObject'));
  });

  test('error class', () {
    final root = Root(
      apis: <Api>[
        AstHostApi(
          name: 'Api',
          methods: <Method>[
            Method(
              name: 'test',
              location: ApiLocation.host,
              returnType: const TypeDeclaration(baseName: 'String', isNullable: false),
              parameters: <Parameter>[],
            ),
          ],
        ),
      ],
      classes: <Class>[],
      enums: <Enum>[],
      containsHostApi: true,
    );
    final sink = StringBuffer();
    const arkTSOptions = InternalArkTSOptions(arkTSOut: '');
    const generator = ArkTSGenerator();
    generator.generate(
      arkTSOptions,
      root,
      sink,
      dartPackageName: DEFAULT_PACKAGE_NAME,
    );
    final code = sink.toString();
    expect(code, contains('export class FlutterError implements Error'));
    expect(code, contains('public code: string;'));
    expect(code, contains('public name: string;'));
    expect(code, contains('public message: string;'));
    expect(code, contains('function wrapError(error: Error): Array<Object>'));
  });
}
