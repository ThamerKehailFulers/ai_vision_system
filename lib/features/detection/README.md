# Detection Feature - API Integration

This document explains how the Detection feature fetches data from the external API.

## API Endpoint

**URL**: `https://v0-next-js-app-with-json-swart.vercel.app/api/detection`
**Method**: GET
**Response Format**: JSON

## Architecture

The detection feature follows Clean Architecture principles with three main layers:

### 1. Data Layer
- **Remote Data Source** ([detection_remote_data_source.dart](data/datasources/detection_remote_data_source.dart))
  - Makes HTTP GET requests to the API
  - Handles network errors and server responses
  - Returns `DetectionModel` objects

- **Models** ([detection_model.dart](data/models/detection_model.dart))
  - `DetectionModel`: Maps API JSON response to domain entities
  - `CameraModel`: Camera information from API
  - `DetectionInfoModel`: Detection-specific details (bounding box, motion, etc.)
  - `AiSummaryModel`: AI-generated summary and recommendations
  - `DetectionResponseModel`: Wraps the array of detections

- **Repository Implementation** ([detection_repository_impl.dart](data/repositories/detection_repository_impl.dart))
  - Implements the domain repository interface
  - Converts `DetectionModel` to `Detection` entities
  - Caches detections for filtering and offline access

### 2. Domain Layer
- **Entities** ([detection.dart](domain/entities/detection.dart))
  - Pure Dart classes with no dependencies
  - `Detection`: Core business object
  - `DetectionType`: Enum (person, vehicle, smoke, fire)
  - `DetectionStatus`: Enum (new, acknowledged, unacknowledged)

- **Repository Interface** ([detection_repository.dart](domain/repositories/detection_repository.dart))
  - Abstract contract for data operations
  - Defines methods: `getDetections()`, `acknowledgeDetection()`, etc.

### 3. Presentation Layer
- **Cubit** ([detection_cubit.dart](presentation/cubit/detection_cubit.dart))
  - Manages state for the detection page
  - Handles loading, filtering, and acknowledgment actions
  - Emits states: `DetectionLoading`, `DetectionLoaded`, `DetectionError`

- **Pages** ([detection_page.dart](presentation/pages/detection_page.dart))
  - Main UI for displaying detections
  - Filters by type and status
  - Shows detection cards with details

## API Response Structure

```json
{
  "detections": [
    {
      "id": "det_4628719",
      "type": "smoke",
      "status": "resolved",
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
        },
        "motionStatus": "Moving",
        "direction": "South-East",
        "speed": "1.7 m/s",
        "dwellTime": 26
      },
      "aiSummary": {
        "generated": true,
        "generatedAt": "2025-10-22T09:56:12Z",
        "summary": "A smoke was detected in Loading Dock with 82% confidence.",
        "severity": "Critical",
        "severityReason": "Smoke detected in restricted area",
        "riskLevel": "Low",
        "recommendations": [
          "Verify smoke detection accuracy",
          "Check area for additional threats"
        ],
        "keyFindings": [
          "High confidence detection (82%)",
          "Smoke detected in Loading Dock"
        ]
      }
    }
  ]
}
```

## How Data Flows

1. **User Opens Detection Page**
   ```
   DetectionPage → DetectionCubit.loadDetections()
   ```

2. **Cubit Requests Data**
   ```
   DetectionCubit → DetectionRepository.getDetections()
   ```

3. **Repository Fetches from API**
   ```
   DetectionRepository → DetectionRemoteDataSource.getDetections()
   ```

4. **Data Source Makes HTTP Request**
   ```
   DetectionRemoteDataSource → HTTP GET to API
   ```

5. **API Returns JSON**
   ```
   API → JSON Response
   ```

6. **Data is Parsed and Mapped**
   ```
   JSON → DetectionModel → Detection Entity
   ```

7. **UI Updates**
   ```
   Detection Entity → DetectionCubit → DetectionPage (displays cards)
   ```

## Dependency Injection

The dependencies are manually injected in [home_page.dart](../../home/presentation/pages/home_page.dart):

```dart
BlocProvider(
  create: (context) {
    final remoteDataSource = DetectionRemoteDataSourceImpl(
      client: http.Client(),
    );
    final repository = DetectionRepositoryImpl(
      remoteDataSource: remoteDataSource,
    );
    return DetectionCubit(repository)..loadDetections();
  },
  child: const DetectionPage(),
)
```

## Features

### 1. Automatic Data Fetching
- Data is fetched automatically when the Detection page is opened
- Loading indicator is shown while fetching

### 2. Filtering
- **By Type**: Filter detections by person, vehicle, smoke, or fire
- **By Status**: Filter by new, acknowledged, or all statuses

### 3. Real-time Updates
- Detections are cached locally for fast filtering
- Pull-to-refresh can be added to fetch latest data

### 4. Error Handling
- Network errors are caught and displayed to the user
- Server errors (404, 500, etc.) show appropriate messages

## Testing

Unit tests are available in:
- [detection_remote_data_source_test.dart](../../../../test/features/detection/data/datasources/detection_remote_data_source_test.dart)

Run tests with:
```bash
flutter test test/features/detection/
```

## Future Enhancements

1. **Pull-to-Refresh**: Add refresh functionality to get latest detections
2. **Pagination**: Implement pagination for large datasets
3. **Real-time Updates**: Use WebSockets for live detection updates
4. **Offline Support**: Store detections locally for offline access
5. **Push Notifications**: Alert users when critical detections occur
6. **Export Data**: Allow users to export detection data as CSV/PDF

## Error Handling

The data source handles these error scenarios:

1. **Network Errors**: No internet connection
   ```dart
   throw DetectionServerException('Failed to connect to the server');
   ```

2. **Server Errors**: 404, 500, etc.
   ```dart
   throw DetectionServerException('Failed to load detections. Status code: 404');
   ```

3. **Parse Errors**: Invalid JSON format
   ```dart
   throw DetectionServerException('Failed to parse response');
   ```

## API Integration Checklist

- [x] Create data models to parse API response
- [x] Create remote data source for HTTP requests
- [x] Update domain entities with new fields
- [x] Implement repository with remote data source
- [x] Update UI to display API data
- [x] Add error handling
- [x] Write unit tests
- [ ] Add pull-to-refresh
- [ ] Implement pagination
- [ ] Add offline caching with local database

## Contact

For questions about the API or this implementation, contact the development team.
