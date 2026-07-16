class LocalException implements Exception {
  final String message;
  const LocalException(this.message);

  @override
  String toString() => 'LocalException: $message';
}

class RemoteException implements Exception {
  final String message;
  const RemoteException(this.message);

  @override
  String toString() => 'RemoteException: $message';
}

class NetworkException implements Exception {
  final String message;
  const NetworkException(this.message);

  @override
  String toString() => 'NetworkException: $message';
}
