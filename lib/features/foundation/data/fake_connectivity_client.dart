import 'package:bringly_app/core/network/backend_connectivity_client.dart';
import 'package:bringly_app/features/foundation/domain/entities/environment_profile.dart';

class FakeConnectivityClient extends BackendConnectivityClient {
  const FakeConnectivityClient({required this.nextStatus, this.throwError});

  final BackendConnectivityStatus nextStatus;
  final Object? throwError;

  @override
  Future<BackendConnectivityStatus> checkConnectivity(
    EnvironmentProfile profile,
  ) async {
    if (throwError != null) {
      throw throwError!;
    }
    return nextStatus;
  }
}
