# Camera Feature - API Integration

This document explains how the Camera feature fetches data from the external API.

## API Endpoint

**URL**: `https://v0-next-js-app-with-json-swart.vercel.app/api/camera-view`
**Method**: GET
**Response Format**: JSON

## Architecture

The camera feature follows Clean Architecture principles with three main layers:

### 1. Data Layer

#### Remote Data Source
**File**: [camera_remote_data_source.dart](data/datasources/camera_remote_data_source.dart)
- Makes HTTP GET requests to the camera view API
- Handles network errors and server responses
- Returns `CameraViewModel` object with complete camera grid configuration

#### Models
**File**: [camera_view_model.dart](data/models/camera_view_model.dart)

Complex data models that parse the comprehensive API response:

- **`CameraViewModel`**: Main wrapper containing all camera view data
- **`ViewConfigModel`**: Grid configuration (layout, refresh rate, overlays)
- **`CameraModel`**: Individual camera information with:
  - Grid position and location
  - Stream URLs (RTSP, HLS, WebRTC, thumbnails)
  - Health metrics (uptime, latency, bandwidth)
  - Detection statistics
  - Recording status
- **`GridLayoutsModel`**: Available and current grid layouts (2x2, 3x3, 4x4, etc.)
- **`ControlsModel`**: Playback, zoom, audio, and fullscreen controls
- **`OverlaysModel`**: Detection boxes, camera info, and health metrics overlays
- **`StatisticsModel`**: System-wide camera statistics

#### Repository Implementation
**File**: [camera_repository_impl.dart](data/repositories/camera_repository_impl.dart)
- Implements the domain repository interface
- Converts API models to domain entities
- Caches camera data for quick access
- Uses Either monad for error handling (Left = Failure, Right = Success)

### 2. Domain Layer

#### Entities
**File**: [camera_stream.dart](domain/entities/camera_stream.dart)

Pure Dart classes representing business objects:

```dart
class CameraStream {
  final String id;
  final String name;
  final String url;
  final bool isLive;
  final DateTime lastUpdate;
  final String? location;
  final String? zone;
  final String? status;
  final int? position;
  final int? gridRow;
  final int? gridCol;
  final String? thumbnailUrl;
  final String? snapshotUrl;
  final String? primaryStreamUrl;
  final String? hlsUrl;
  final String? healthStatus;
  final double? uptime;
  final int? latency;
  final int? activeDetections;
  final int? totalDetectionsToday;
  final bool? isRecording;
  // ... and more
}
```

#### Repository Interface
**File**: [camera_repository.dart](domain/repositories/camera_repository.dart)

Abstract contract defining camera operations:
- `getCameraStreams()` - Get all cameras
- `getCameraStream(id)` - Get specific camera
- `startCameraStream(id)` - Start streaming
- `stopCameraStream(id)` - Stop streaming
- `getDetections(cameraId)` - Get camera detections

### 3. Presentation Layer

#### Cubit
**File**: [camera_cubit.dart](presentation/cubit/camera_cubit.dart)

State management for camera view:
- Manages loading, loaded, and error states
- Handles camera selection
- Emits states: `CameraInitial`, `CameraLoading`, `CameraLoaded`, `CameraError`

#### Page
**File**: [camera_page.dart](presentation/pages/camera_page.dart)

Main UI displaying the C4 camera grid:
- Shows loading indicator while fetching
- Displays camera grid when loaded
- Shows error with retry button on failure
- Includes refresh button in AppBar

## API Response Structure

The API returns a comprehensive camera view configuration:

```json
{
  "viewConfig": {
    "id": "c4_view_001",
    "name": "C4 Camera View",
    "layout": "3x3",
    "totalCameras": 9,
    "activeCameras": 8,
    "refreshRate": 30,
    "showDetectionOverlay": true
  },
  "cameras": [
    {
      "id": "cam_001",
      "position": 1,
      "gridLocation": { "row": 1, "col": 1 },
      "name": "Camera 1",
      "location": "Building A - Floor 1",
      "zone": "Entrance Lobby",
      "status": "online",
      "isLive": true,
      "stream": {
        "primary": {
          "url": "rtsp://192.168.1.101:554/stream1",
          "resolution": "1920x1080",
          "fps": 30
        },
        "thumbnail": "https://storage.example.com/cameras/cam_001/thumbnail.jpg",
        "snapshot": "https://storage.example.com/cameras/cam_001/snapshot.jpg",
        "hls": {
          "url": "https://stream.example.com/camera1/index.m3u8"
        }
      },
      "health": {
        "status": "healthy",
        "uptime": 99.8,
        "latency": 45,
        "bandwidth": 4.2
      },
      "detection": {
        "enabled": true,
        "activeDetections": 0,
        "totalToday": 23
      },
      "recording": {
        "enabled": true,
        "status": "recording"
      }
    }
    // ... more cameras
  ],
  "gridLayouts": {
    "available": [
      { "id": "layout_2x2", "name": "2x2 Grid", "maxCameras": 4 },
      { "id": "layout_3x3", "name": "3x3 Grid", "maxCameras": 9 },
      { "id": "layout_4x4", "name": "4x4 Grid", "maxCameras": 16 }
    ],
    "current": "layout_3x3"
  },
  "statistics": {
    "totalCameras": 9,
    "onlineCameras": 8,
    "offlineCameras": 1,
    "activeDetections": 8,
    "totalDetectionsToday": 259,
    "averageUptime": 98.9
  }
}
```

## Data Flow

1. **User Opens Camera Page**
   ```
   CameraPage → CameraCubit.loadCameraStreams()
   ```

2. **Cubit Requests Data**
   ```
   CameraCubit → CameraRepository.getCameraStreams()
   ```

3. **Repository Fetches from API**
   ```
   CameraRepository → CameraRemoteDataSource.getCameraView()
   ```

4. **Data Source Makes HTTP Request**
   ```
   CameraRemoteDataSource → HTTP GET to API
   ```

5. **API Returns JSON**
   ```
   API → CameraViewModel JSON Response
   ```

6. **Data is Parsed and Mapped**
   ```
   JSON → CameraModel → CameraStream Entity
   ```

7. **UI Updates**
   ```
   CameraStream Entities → CameraCubit → CameraPage (displays grid)
   ```

## Dependency Injection

Dependencies are manually injected in [camera_page.dart](presentation/pages/camera_page.dart):

```dart
BlocProvider(
  create: (context) {
    final remoteDataSource = CameraRemoteDataSourceImpl(
      client: http.Client(),
    );
    final repository = CameraRepositoryImpl(
      remoteDataSource: remoteDataSource,
    );
    return CameraCubit(repository)..loadCameraStreams();
  },
  child: const _CameraPageContent(),
)
```

## Features

### 1. Automatic Data Fetching
- Camera data is fetched automatically when the page loads
- Loading indicator shown during fetch
- Refresh button to manually reload data

### 2. Comprehensive Camera Information
Each camera includes:
- **Basic Info**: Name, location, zone, status
- **Stream URLs**: RTSP, HLS, WebRTC, thumbnails, snapshots
- **Health Metrics**: Uptime percentage, latency, bandwidth
- **Detection Stats**: Active detections, daily total
- **Recording Status**: Whether camera is recording

### 3. Grid Layout Information
- Multiple layout options (2x2, 3x3, 4x4, 1+5, 1+7)
- Current active layout
- Grid position for each camera (row, col)

### 4. System Statistics
- Total cameras count
- Online/offline cameras
- Active detections across all cameras
- Average uptime and latency
- Total bandwidth usage

### 5. Error Handling
- Network errors caught and displayed
- Server errors (404, 500) show appropriate messages
- Retry button to attempt reload

## Camera Status Indicators

Cameras can have different statuses:
- **online**: Camera is live and streaming
- **offline**: Camera is not reachable (shows error in health)
- **healthy**: Camera operating normally
- **warning**: Camera has performance issues

## Stream Types

The API provides multiple stream URLs:
1. **Primary RTSP**: High quality (1920x1080 @ 30fps)
2. **Secondary RTSP**: Lower quality (640x480 @ 15fps)
3. **HLS**: HTTP Live Streaming for web
4. **WebRTC**: Real-time communication protocol
5. **Thumbnail**: Quick preview image
6. **Snapshot**: Current frame capture

## Future Enhancements

1. **Grid Layout Switching**: Allow users to change grid layout (2x2, 3x3, 4x4)
2. **Camera Controls**: PTZ controls for supported cameras
3. **Fullscreen Mode**: View single camera in fullscreen
4. **Detection Overlays**: Show real-time detection bounding boxes
5. **Health Monitoring**: Display live health metrics (FPS, latency, bitrate)
6. **Recording Controls**: Start/stop recording for individual cameras
7. **Playback Controls**: Video playback speed control
8. **Audio Support**: Enable/disable audio for cameras
9. **Zoom Controls**: Digital zoom for camera views
10. **Export**: Download snapshots or video clips

## Testing

Unit tests can be created following the pattern used for detections:

```dart
test('should return list of CameraStream when API call succeeds', () async {
  // arrange
  when(() => mockHttpClient.get(...))
    .thenAnswer((_) async => http.Response(mockResponseBody, 200));

  // act
  final result = await dataSource.getCameraView();

  // assert
  expect(result.cameras, isNotEmpty);
  expect(result.cameras.first.id, 'cam_001');
});
```

## Error Handling

The data source handles these scenarios:

1. **Network Errors**: No internet connection
   ```dart
   throw CameraServerException('Failed to connect to the server');
   ```

2. **Server Errors**: 404, 500, etc.
   ```dart
   throw CameraServerException('Failed to load camera view. Status code: 404');
   ```

3. **Parse Errors**: Invalid JSON format
   ```dart
   throw CameraServerException('Failed to parse response');
   ```

## Integration Checklist

- [x] Create comprehensive data models for API response
- [x] Create remote data source for HTTP requests
- [x] Update domain entities with all camera fields
- [x] Implement repository with remote data source
- [x] Update CameraCubit to use repository
- [x] Update CameraPage with dependency injection
- [x] Add error handling
- [x] Test compilation (no errors)
- [ ] Add unit tests
- [ ] Implement grid layout switching
- [ ] Add camera controls (PTZ, zoom, etc.)
- [ ] Implement detection overlays
- [ ] Add health metrics display

## Camera Grid Widget

The [camera_grid_view.dart](presentation/widgets/camera_grid_view.dart) widget displays cameras in a responsive grid based on the layout configuration from the API.

## Contact

For questions about the camera API or this implementation, contact the development team.
