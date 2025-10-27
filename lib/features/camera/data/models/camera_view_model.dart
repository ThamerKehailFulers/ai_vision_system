import '../../domain/entities/camera_stream.dart';

class CameraViewModel {
  final ViewConfigModel viewConfig;
  final List<CameraModel> cameras;
  final GridLayoutsModel gridLayouts;
  final ControlsModel controls;
  final OverlaysModel overlays;
  final StatisticsModel statistics;

  CameraViewModel({
    required this.viewConfig,
    required this.cameras,
    required this.gridLayouts,
    required this.controls,
    required this.overlays,
    required this.statistics,
  });

  factory CameraViewModel.fromJson(Map<String, dynamic> json) {
    return CameraViewModel(
      viewConfig: ViewConfigModel.fromJson(json['viewConfig'] as Map<String, dynamic>),
      cameras: (json['cameras'] as List)
          .map((c) => CameraModel.fromJson(c as Map<String, dynamic>))
          .toList(),
      gridLayouts: GridLayoutsModel.fromJson(json['gridLayouts'] as Map<String, dynamic>),
      controls: ControlsModel.fromJson(json['controls'] as Map<String, dynamic>),
      overlays: OverlaysModel.fromJson(json['overlays'] as Map<String, dynamic>),
      statistics: StatisticsModel.fromJson(json['statistics'] as Map<String, dynamic>),
    );
  }
}

class ViewConfigModel {
  final String id;
  final String name;
  final String description;
  final String type;
  final String layout;
  final int totalCameras;
  final int activeCameras;
  final int refreshRate;
  final bool autoRotate;
  final bool showDetectionOverlay;
  final bool showHealthMetrics;
  final bool fullscreenEnabled;

  ViewConfigModel({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.layout,
    required this.totalCameras,
    required this.activeCameras,
    required this.refreshRate,
    required this.autoRotate,
    required this.showDetectionOverlay,
    required this.showHealthMetrics,
    required this.fullscreenEnabled,
  });

  factory ViewConfigModel.fromJson(Map<String, dynamic> json) {
    return ViewConfigModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      type: json['type'] as String,
      layout: json['layout'] as String,
      totalCameras: json['totalCameras'] as int,
      activeCameras: json['activeCameras'] as int,
      refreshRate: json['refreshRate'] as int,
      autoRotate: json['autoRotate'] as bool,
      showDetectionOverlay: json['showDetectionOverlay'] as bool,
      showHealthMetrics: json['showHealthMetrics'] as bool,
      fullscreenEnabled: json['fullscreenEnabled'] as bool,
    );
  }
}

class CameraModel {
  final String id;
  final int position;
  final GridLocationModel gridLocation;
  final String name;
  final String location;
  final String zone;
  final String status;
  final bool isLive;
  final StreamModel stream;
  final HealthModel health;
  final CameraDetectionModel detection;
  final RecordingModel recording;

  CameraModel({
    required this.id,
    required this.position,
    required this.gridLocation,
    required this.name,
    required this.location,
    required this.zone,
    required this.status,
    required this.isLive,
    required this.stream,
    required this.health,
    required this.detection,
    required this.recording,
  });

  factory CameraModel.fromJson(Map<String, dynamic> json) {
    return CameraModel(
      id: json['id'] as String,
      position: json['position'] as int,
      gridLocation: GridLocationModel.fromJson(json['gridLocation'] as Map<String, dynamic>),
      name: json['name'] as String,
      location: json['location'] as String,
      zone: json['zone'] as String,
      status: json['status'] as String,
      isLive: json['isLive'] as bool,
      stream: StreamModel.fromJson(json['stream'] as Map<String, dynamic>),
      health: HealthModel.fromJson(json['health'] as Map<String, dynamic>),
      detection: CameraDetectionModel.fromJson(json['detection'] as Map<String, dynamic>),
      recording: RecordingModel.fromJson(json['recording'] as Map<String, dynamic>),
    );
  }

  CameraStream toEntity() {
    return CameraStream(
      id: id,
      name: name,
      url: stream.thumbnail ?? stream.snapshot ?? '',
      isLive: isLive,
      lastUpdate: health.lastHeartbeat != null
          ? DateTime.parse(health.lastHeartbeat!)
          : DateTime.now(),
      location: location,
      zone: zone,
      status: status,
      position: position,
      gridRow: gridLocation.row,
      gridCol: gridLocation.col,
      thumbnailUrl: stream.thumbnail,
      snapshotUrl: stream.snapshot,
      primaryStreamUrl: stream.primary.url,
      hlsUrl: stream.hls?.url,
      healthStatus: health.status,
      uptime: health.uptime,
      latency: health.latency,
      activeDetections: detection.activeDetections,
      totalDetectionsToday: detection.totalToday,
      isRecording: recording.status == 'recording',
    );
  }
}

class GridLocationModel {
  final int row;
  final int col;

  GridLocationModel({required this.row, required this.col});

  factory GridLocationModel.fromJson(Map<String, dynamic> json) {
    return GridLocationModel(
      row: json['row'] as int,
      col: json['col'] as int,
    );
  }
}

class StreamModel {
  final StreamInfoModel primary;
  final StreamInfoModel secondary;
  final SimpleStreamModel? hls;
  final SimpleStreamModel? webrtc;
  final String? thumbnail;
  final String? snapshot;

  StreamModel({
    required this.primary,
    required this.secondary,
    this.hls,
    this.webrtc,
    this.thumbnail,
    this.snapshot,
  });

  factory StreamModel.fromJson(Map<String, dynamic> json) {
    return StreamModel(
      primary: StreamInfoModel.fromJson(json['primary'] as Map<String, dynamic>),
      secondary: StreamInfoModel.fromJson(json['secondary'] as Map<String, dynamic>),
      hls: json['hls'] != null
          ? SimpleStreamModel.fromJson(json['hls'] as Map<String, dynamic>)
          : null,
      webrtc: json['webrtc'] != null
          ? SimpleStreamModel.fromJson(json['webrtc'] as Map<String, dynamic>)
          : null,
      thumbnail: json['thumbnail'] as String?,
      snapshot: json['snapshot'] as String?,
    );
  }
}

class StreamInfoModel {
  final String url;
  final String protocol;
  final String resolution;
  final int fps;
  final int bitrate;
  final String codec;

  StreamInfoModel({
    required this.url,
    required this.protocol,
    required this.resolution,
    required this.fps,
    required this.bitrate,
    required this.codec,
  });

  factory StreamInfoModel.fromJson(Map<String, dynamic> json) {
    return StreamInfoModel(
      url: json['url'] as String,
      protocol: json['protocol'] as String,
      resolution: json['resolution'] as String,
      fps: json['fps'] as int,
      bitrate: json['bitrate'] as int,
      codec: json['codec'] as String,
    );
  }
}

class SimpleStreamModel {
  final String url;
  final String protocol;

  SimpleStreamModel({required this.url, required this.protocol});

  factory SimpleStreamModel.fromJson(Map<String, dynamic> json) {
    return SimpleStreamModel(
      url: json['url'] as String,
      protocol: json['protocol'] as String,
    );
  }
}

class HealthModel {
  final String status;
  final double uptime;
  final int latency;
  final double packetLoss;
  final double bandwidth;
  final String? lastHeartbeat;
  final String? error;

  HealthModel({
    required this.status,
    required this.uptime,
    required this.latency,
    required this.packetLoss,
    required this.bandwidth,
    this.lastHeartbeat,
    this.error,
  });

  factory HealthModel.fromJson(Map<String, dynamic> json) {
    return HealthModel(
      status: json['status'] as String,
      uptime: (json['uptime'] as num).toDouble(),
      latency: json['latency'] as int,
      packetLoss: (json['packetLoss'] as num).toDouble(),
      bandwidth: (json['bandwidth'] as num).toDouble(),
      lastHeartbeat: json['lastHeartbeat'] as String?,
      error: json['error'] as String?,
    );
  }
}

class CameraDetectionModel {
  final bool enabled;
  final int activeDetections;
  final int totalToday;
  final String? lastDetection;
  final List<String> detectionTypes;

  CameraDetectionModel({
    required this.enabled,
    required this.activeDetections,
    required this.totalToday,
    this.lastDetection,
    required this.detectionTypes,
  });

  factory CameraDetectionModel.fromJson(Map<String, dynamic> json) {
    return CameraDetectionModel(
      enabled: json['enabled'] as bool,
      activeDetections: json['activeDetections'] as int,
      totalToday: json['totalToday'] as int,
      lastDetection: json['lastDetection'] as String?,
      detectionTypes: (json['detectionTypes'] as List).cast<String>(),
    );
  }
}

class RecordingModel {
  final bool enabled;
  final String status;
  final double storageUsed;
  final int storageLimit;
  final int retentionDays;

  RecordingModel({
    required this.enabled,
    required this.status,
    required this.storageUsed,
    required this.storageLimit,
    required this.retentionDays,
  });

  factory RecordingModel.fromJson(Map<String, dynamic> json) {
    return RecordingModel(
      enabled: json['enabled'] as bool,
      status: json['status'] as String,
      storageUsed: (json['storageUsed'] as num).toDouble(),
      storageLimit: json['storageLimit'] as int,
      retentionDays: json['retentionDays'] as int,
    );
  }
}

class GridLayoutsModel {
  final List<LayoutOptionModel> available;
  final String current;

  GridLayoutsModel({required this.available, required this.current});

  factory GridLayoutsModel.fromJson(Map<String, dynamic> json) {
    return GridLayoutsModel(
      available: (json['available'] as List)
          .map((l) => LayoutOptionModel.fromJson(l as Map<String, dynamic>))
          .toList(),
      current: json['current'] as String,
    );
  }
}

class LayoutOptionModel {
  final String id;
  final String name;
  final int? rows;
  final int? cols;
  final int maxCameras;
  final String? description;

  LayoutOptionModel({
    required this.id,
    required this.name,
    this.rows,
    this.cols,
    required this.maxCameras,
    this.description,
  });

  factory LayoutOptionModel.fromJson(Map<String, dynamic> json) {
    return LayoutOptionModel(
      id: json['id'] as String,
      name: json['name'] as String,
      rows: json['rows'] as int?,
      cols: json['cols'] as int?,
      maxCameras: json['maxCameras'] as int,
      description: json['description'] as String?,
    );
  }
}

class ControlsModel {
  final PlaybackControlModel playback;
  final ZoomControlModel zoom;
  final AudioControlModel audio;
  final FullscreenControlModel fullscreen;

  ControlsModel({
    required this.playback,
    required this.zoom,
    required this.audio,
    required this.fullscreen,
  });

  factory ControlsModel.fromJson(Map<String, dynamic> json) {
    return ControlsModel(
      playback: PlaybackControlModel.fromJson(json['playback'] as Map<String, dynamic>),
      zoom: ZoomControlModel.fromJson(json['zoom'] as Map<String, dynamic>),
      audio: AudioControlModel.fromJson(json['audio'] as Map<String, dynamic>),
      fullscreen: FullscreenControlModel.fromJson(json['fullscreen'] as Map<String, dynamic>),
    );
  }
}

class PlaybackControlModel {
  final bool enabled;
  final double speed;
  final List<double> availableSpeeds;

  PlaybackControlModel({
    required this.enabled,
    required this.speed,
    required this.availableSpeeds,
  });

  factory PlaybackControlModel.fromJson(Map<String, dynamic> json) {
    return PlaybackControlModel(
      enabled: json['enabled'] as bool,
      speed: (json['speed'] as num).toDouble(),
      availableSpeeds: (json['availableSpeeds'] as List)
          .map((s) => (s as num).toDouble())
          .toList(),
    );
  }
}

class ZoomControlModel {
  final bool enabled;
  final int level;
  final int min;
  final int max;

  ZoomControlModel({
    required this.enabled,
    required this.level,
    required this.min,
    required this.max,
  });

  factory ZoomControlModel.fromJson(Map<String, dynamic> json) {
    return ZoomControlModel(
      enabled: json['enabled'] as bool,
      level: json['level'] as int,
      min: json['min'] as int,
      max: json['max'] as int,
    );
  }
}

class AudioControlModel {
  final bool enabled;
  final double volume;
  final bool muted;

  AudioControlModel({
    required this.enabled,
    required this.volume,
    required this.muted,
  });

  factory AudioControlModel.fromJson(Map<String, dynamic> json) {
    return AudioControlModel(
      enabled: json['enabled'] as bool,
      volume: (json['volume'] as num).toDouble(),
      muted: json['muted'] as bool,
    );
  }
}

class FullscreenControlModel {
  final bool enabled;
  final bool active;

  FullscreenControlModel({required this.enabled, required this.active});

  factory FullscreenControlModel.fromJson(Map<String, dynamic> json) {
    return FullscreenControlModel(
      enabled: json['enabled'] as bool,
      active: json['active'] as bool,
    );
  }
}

class OverlaysModel {
  final DetectionBoxesModel detectionBoxes;
  final CameraInfoModel cameraInfo;
  final HealthMetricsModel healthMetrics;

  OverlaysModel({
    required this.detectionBoxes,
    required this.cameraInfo,
    required this.healthMetrics,
  });

  factory OverlaysModel.fromJson(Map<String, dynamic> json) {
    return OverlaysModel(
      detectionBoxes: DetectionBoxesModel.fromJson(json['detectionBoxes'] as Map<String, dynamic>),
      cameraInfo: CameraInfoModel.fromJson(json['cameraInfo'] as Map<String, dynamic>),
      healthMetrics: HealthMetricsModel.fromJson(json['healthMetrics'] as Map<String, dynamic>),
    );
  }
}

class DetectionBoxesModel {
  final bool enabled;
  final bool showConfidence;
  final bool showLabels;
  final Map<String, String> colors;

  DetectionBoxesModel({
    required this.enabled,
    required this.showConfidence,
    required this.showLabels,
    required this.colors,
  });

  factory DetectionBoxesModel.fromJson(Map<String, dynamic> json) {
    return DetectionBoxesModel(
      enabled: json['enabled'] as bool,
      showConfidence: json['showConfidence'] as bool,
      showLabels: json['showLabels'] as bool,
      colors: Map<String, String>.from(json['colors'] as Map),
    );
  }
}

class CameraInfoModel {
  final bool enabled;
  final bool showName;
  final bool showLocation;
  final bool showStatus;
  final bool showTime;

  CameraInfoModel({
    required this.enabled,
    required this.showName,
    required this.showLocation,
    required this.showStatus,
    required this.showTime,
  });

  factory CameraInfoModel.fromJson(Map<String, dynamic> json) {
    return CameraInfoModel(
      enabled: json['enabled'] as bool,
      showName: json['showName'] as bool,
      showLocation: json['showLocation'] as bool,
      showStatus: json['showStatus'] as bool,
      showTime: json['showTime'] as bool,
    );
  }
}

class HealthMetricsModel {
  final bool enabled;
  final bool showFPS;
  final bool showLatency;
  final bool showBitrate;

  HealthMetricsModel({
    required this.enabled,
    required this.showFPS,
    required this.showLatency,
    required this.showBitrate,
  });

  factory HealthMetricsModel.fromJson(Map<String, dynamic> json) {
    return HealthMetricsModel(
      enabled: json['enabled'] as bool,
      showFPS: json['showFPS'] as bool,
      showLatency: json['showLatency'] as bool,
      showBitrate: json['showBitrate'] as bool,
    );
  }
}

class StatisticsModel {
  final int totalCameras;
  final int onlineCameras;
  final int offlineCameras;
  final int recordingCameras;
  final int activeDetections;
  final int totalDetectionsToday;
  final double averageUptime;
  final int averageLatency;
  final double totalBandwidth;
  final int totalStorageUsed;
  final int totalStorageLimit;

  StatisticsModel({
    required this.totalCameras,
    required this.onlineCameras,
    required this.offlineCameras,
    required this.recordingCameras,
    required this.activeDetections,
    required this.totalDetectionsToday,
    required this.averageUptime,
    required this.averageLatency,
    required this.totalBandwidth,
    required this.totalStorageUsed,
    required this.totalStorageLimit,
  });

  factory StatisticsModel.fromJson(Map<String, dynamic> json) {
    return StatisticsModel(
      totalCameras: json['totalCameras'] as int,
      onlineCameras: json['onlineCameras'] as int,
      offlineCameras: json['offlineCameras'] as int,
      recordingCameras: json['recordingCameras'] as int,
      activeDetections: json['activeDetections'] as int,
      totalDetectionsToday: json['totalDetectionsToday'] as int,
      averageUptime: (json['averageUptime'] as num).toDouble(),
      averageLatency: json['averageLatency'] as int,
      totalBandwidth: (json['totalBandwidth'] as num).toDouble(),
      totalStorageUsed: json['totalStorageUsed'] as int,
      totalStorageLimit: json['totalStorageLimit'] as int,
    );
  }
}
