import 'package:bringly_app/features/foundation/domain/entities/environment_profile.dart';

enum BackendConnectivityStatus {
  success,
  unavailable,
  timeout,
  offline,
  failed,
}

abstract class BackendConnectivityClient {
  const BackendConnectivityClient();

  Future<BackendConnectivityStatus> checkConnectivity(
    EnvironmentProfile profile,
  );
}
