// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preset_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PresetNotifier)
final presetProvider = PresetNotifierProvider._();

final class PresetNotifierProvider
    extends $AsyncNotifierProvider<PresetNotifier, PresetState> {
  PresetNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'presetProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$presetNotifierHash();

  @$internal
  @override
  PresetNotifier create() => PresetNotifier();
}

String _$presetNotifierHash() => r'ea4f73b9148d86be28f46b898c6c77a36927e5ab';

abstract class _$PresetNotifier extends $AsyncNotifier<PresetState> {
  FutureOr<PresetState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<PresetState>, PresetState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PresetState>, PresetState>,
              AsyncValue<PresetState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
