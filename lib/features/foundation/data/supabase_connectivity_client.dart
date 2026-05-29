import 'dart:async';
import 'dart:io';

import 'package:bringly_app/core/network/backend_connectivity_client.dart';
import 'package:bringly_app/features/foundation/domain/entities/environment_profile.dart';

class SupabaseConnectivityClient extends BackendConnectivityClient {
  const SupabaseConnectivityClient({this.timeout = const Duration(seconds: 5)});

  final Duration timeout;

  @override
  Future<BackendConnectivityStatus> checkConnectivity(
    EnvironmentProfile profile,
  ) async {
    final client = HttpClient();
    try {
      final endpoint = Uri.parse('${profile.supabaseUrl}/auth/v1/settings');
      final request = await client.getUrl(endpoint).timeout(timeout);
      final response = await request.close().timeout(timeout);
      if (response.statusCode >= 200 && response.statusCode < 500) {
        return BackendConnectivityStatus.success;
      }
      return BackendConnectivityStatus.unavailable;
    } on TimeoutException {
      return BackendConnectivityStatus.timeout;
    } on SocketException {
      return BackendConnectivityStatus.offline;
    } catch (_) {
      return BackendConnectivityStatus.failed;
    } finally {
      client.close(force: true);
    }
  }
}
