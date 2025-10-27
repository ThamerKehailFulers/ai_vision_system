import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/camera_view_model.dart';

abstract class CameraRemoteDataSource {
  /// Fetches camera view data from the API
  Future<CameraViewModel> getCameraView();
}

class CameraRemoteDataSourceImpl implements CameraRemoteDataSource {
  final http.Client client;
  static const String baseUrl =
      'https://v0-next-js-app-with-json-swart.vercel.app/api/camera-view';

  CameraRemoteDataSourceImpl({required this.client});

  @override
  Future<CameraViewModel> getCameraView() async {
    try {
      final response = await client.get(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        return CameraViewModel.fromJson(jsonData);
      } else {
        throw CameraServerException(
          'Failed to load camera view. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is CameraServerException) {
        rethrow;
      }
      throw CameraServerException(
        'Failed to connect to the server: ${e.toString()}',
      );
    }
  }
}

class CameraServerException implements Exception {
  final String message;

  CameraServerException(this.message);

  @override
  String toString() => message;
}
