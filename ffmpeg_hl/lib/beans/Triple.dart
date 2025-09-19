class Triple<T1, T2, T3> {
  final T1 first;
  final T2 second;
  final T3 third;

  Triple(this.first, this.second, this.third);

  @override
  String toString() {
    return 'Triple{first: $first, second: $second, third: $third}';
  }
}