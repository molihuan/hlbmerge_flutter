import 'package:freezed_annotation/freezed_annotation.dart';

part 'main_state.freezed.dart';

@freezed
abstract class MainState with _$MainState {
  const MainState._();

  const factory MainState({
    String? inputAudio,
    String? inputVideo,
    @Default([]) List<String> inputVideos,
    String? outputFile,
  }) = _MainState;
}
