class Pair<T1, T2> {
  final T1 first;
  final T2 second;

  Pair(this.first, this.second);

  @override
  String toString() {
    return 'Pair{first: $first, second: $second}';
  }
}