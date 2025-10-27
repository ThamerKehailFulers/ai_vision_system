import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:ai_vision_system/features/detection/data/datasources/detection_remote_data_source.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late DetectionRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = DetectionRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('getDetections', () {
    test('should return list of DetectionModel when the response code is 200',
        () async {
      // arrange
      const mockResponseBody = '''
      {
        "detections": [
          {
            "id": "det_123",
            "type": "smoke",
            "status": "new",
            "severity": "high",
            "confidence": 0.82,
            "timestamp": "2025-10-22T09:56:00Z",
            "duration": 26,
            "camera": {
              "id": "cam_006",
              "name": "Camera 6",
              "location": "Warehouse - Section 2",
              "zone": "Loading Dock",
              "coordinates": {
                "latitude": 25.2924,
                "longitude": 55.2472
              }
            },
            "detection": {
              "objectClass": "smoke",
              "subClass": "Toxic Smoke",
              "boundingBox": {
                "x": 486,
                "y": 247,
                "width": 248,
                "height": 282
              }
            },
            "aiSummary": {
              "generated": true,
              "summary": "Smoke detected in warehouse",
              "severity": "Critical"
            }
          }
        ]
      }
      ''';

      when(() => mockHttpClient.get(
            Uri.parse(
                'https://v0-next-js-app-with-json-swart.vercel.app/api/detection'),
            headers: any(named: 'headers'),
          )).thenAnswer(
        (_) async => http.Response(mockResponseBody, 200),
      );

      // act
      final result = await dataSource.getDetections();

      // assert
      expect(result, isNotEmpty);
      expect(result.first.id, 'det_123');
      expect(result.first.type, 'smoke');
      expect(result.first.confidence, 0.82);
    });

    test('should throw DetectionServerException when the response code is 404',
        () async {
      // arrange
      when(() => mockHttpClient.get(
            Uri.parse(
                'https://v0-next-js-app-with-json-swart.vercel.app/api/detection'),
            headers: any(named: 'headers'),
          )).thenAnswer(
        (_) async => http.Response('Not found', 404),
      );

      // act & assert
      expect(
        () => dataSource.getDetections(),
        throwsA(isA<DetectionServerException>()),
      );
    });
  });
}
