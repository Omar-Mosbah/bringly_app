import 'dart:async';
import 'dart:io';

import 'package:bringly_app/core/network/backend_connectivity_client.dart';
import 'package:bringly_app/features/foundation/domain/entities/environment_profile.dart';

class SupabaseConnectivityClient extends BackendConnectivityClient {
  const SupabaseConnectivityClient({
    required this.publishableAnonKey,
    this.timeout = const Duration(seconds: 5),
  });

  static const String healthPath = '/auth/v1/health';

  final String publishableAnonKey;
  final Duration timeout;

  @override
  Future<BackendConnectivityStatus> checkConnectivity(
    EnvironmentProfile profile,
  ) async {
    final client = HttpClient();
    try {
      final endpoint = Uri.parse('${profile.supabaseUrl}$healthPath');
      final request = await client.getUrl(endpoint).timeout(timeout);
      request.headers.set('apikey', publishableAnonKey);
      request.headers.set('Authorization', 'Bearer $publishableAnonKey');
      final response = await request.close().timeout(timeout);
      return mapHealthResponseStatus(response.statusCode);
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

  static BackendConnectivityStatus mapHealthResponseStatus(int statusCode) {
    if (statusCode == HttpStatus.ok) {
      return BackendConnectivityStatus.success;
    }
    if (statusCode == HttpStatus.unauthorized ||
        statusCode == HttpStatus.forbidden ||
        statusCode == HttpStatus.notFound) {
      return BackendConnectivityStatus.failed;
    }
    return BackendConnectivityStatus.unavailable;
  }
}
