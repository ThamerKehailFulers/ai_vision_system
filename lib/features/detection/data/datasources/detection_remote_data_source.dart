import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/detection_model.dart';

abstract class DetectionRemoteDataSource {
  /// Fetches all detections from the API
  Future<List<DetectionModel>> getDetections();
}

class DetectionRemoteDataSourceImpl implements DetectionRemoteDataSource {
  final http.Client client;
  static const String baseUrl =
      'https://v0-next-js-app-with-json-swart.vercel.app/api/detection';

  DetectionRemoteDataSourceImpl({required this.client});

  @override
  Future<List<DetectionModel>> getDetections() async {
    try {
      final response = await client.get(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        final detectionResponse = DetectionResponseModel.fromJson(jsonData);
        return detectionResponse.detections;
      } else {
        throw DetectionServerException(
          'Failed to load detections. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is DetectionServerException) {
        rethrow;
      }
      throw DetectionServerException(
        'Failed to connect to the server: ${e.toString()}',
      );
    }
  }
}

class DetectionServerException implements Exception {
  final String message;

  DetectionServerException(this.message);

  @override
  String toString() => message;
}
