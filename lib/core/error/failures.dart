import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class LocalFailure extends Failure {
  const LocalFailure(super.message);
}

class RemoteFailure extends Failure {
  const RemoteFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class SyncFailure extends Failure {
  const SyncFailure(super.message);
}
