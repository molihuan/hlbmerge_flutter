// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_home_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SyncHomeNotifier)
final syncHomeProvider = SyncHomeNotifierProvider._();

final class SyncHomeNotifierProvider
    extends $NotifierProvider<SyncHomeNotifier, SyncHomeState> {
  SyncHomeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncHomeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncHomeNotifierHash();

  @$internal
  @override
  SyncHomeNotifier create() => SyncHomeNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncHomeState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncHomeState>(value),
    );
  }
}

String _$syncHomeNotifierHash() => r'0073f60a01cb522c09947eaddbfa83a55999ec90';

abstract class _$SyncHomeNotifier extends $Notifier<SyncHomeState> {
  SyncHomeState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SyncHomeState, SyncHomeState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SyncHomeState, SyncHomeState>,
              SyncHomeState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
