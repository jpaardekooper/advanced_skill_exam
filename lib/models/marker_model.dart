class MarkerModel {
  final String name;
  final bool isClosed;

  const MarkerModel({this.name, this.isClosed = false});

  @override
  String toString() {
    return 'Place $name (closed : $isClosed)';
  }
}
