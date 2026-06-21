// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_preset_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SyncPresetNotifier)
final syncPresetProvider = SyncPresetNotifierProvider._();

final class SyncPresetNotifierProvider
    extends $NotifierProvider<SyncPresetNotifier, SyncPresetState> {
  SyncPresetNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncPresetProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncPresetNotifierHash();

  @$internal
  @override
  SyncPresetNotifier create() => SyncPresetNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncPresetState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncPresetState>(value),
    );
  }
}

String _$syncPresetNotifierHash() =>
    r'e92816c5c4d536828023e73b543ea9498d448e6e';

abstract class _$SyncPresetNotifier extends $Notifier<SyncPresetState> {
  SyncPresetState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SyncPresetState, SyncPresetState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SyncPresetState, SyncPresetState>,
              SyncPresetState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
