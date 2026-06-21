extension BoolUiExt on bool {
  T when<T>(T trueCase, T falseCase) {
    return this ? trueCase : falseCase;
  }
}
