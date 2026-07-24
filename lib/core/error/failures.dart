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

/// Tidak ada sesi, atau sesi yang ada sudah tidak berlaku.
///
/// Berbeda dari [ForbiddenFailure]: di sini sistem tidak tahu siapa yang
/// meminta, bukan tahu tapi menolak.
class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

/// Pengguna dikenali tetapi tidak berhak.
///
/// Padanan `42501 insufficient_privilege` dari Postgres saat kebijakan RLS
/// menolak sebuah mutasi.
class ForbiddenFailure extends Failure {
  const ForbiddenFailure(super.message);
}
