import 'package:equatable/equatable.dart';

class CameraStream extends Equatable {
  final String id;
  final String name;
  final String url;
  final bool isLive;
  final DateTime lastUpdate;
  final List<Detection> detections;
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

  const CameraStream({
    required this.id,
    required this.name,
    required this.url,
    required this.isLive,
    required this.lastUpdate,
    this.detections = const [],
    this.location,
    this.zone,
    this.status,
    this.position,
    this.gridRow,
    this.gridCol,
    this.thumbnailUrl,
    this.snapshotUrl,
    this.primaryStreamUrl,
    this.hlsUrl,
    this.healthStatus,
    this.uptime,
    this.latency,
    this.activeDetections,
    this.totalDetectionsToday,
    this.isRecording,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        url,
        isLive,
        lastUpdate,
        detections,
        location,
        zone,
        status,
        position,
        gridRow,
        gridCol,
        thumbnailUrl,
        snapshotUrl,
        primaryStreamUrl,
        hlsUrl,
        healthStatus,
        uptime,
        latency,
        activeDetections,
        totalDetectionsToday,
        isRecording,
      ];
}

class Detection extends Equatable {
  final String id;
  final String type;
  final double confidence;
  final BoundingBox boundingBox;
  final DateTime timestamp;

  const Detection({
    required this.id,
    required this.type,
    required this.confidence,
    required this.boundingBox,
    required this.timestamp,
  });

  @override
  List<Object> get props => [id, type, confidence, boundingBox, timestamp];
}

class BoundingBox extends Equatable {
  final double x;
  final double y;
  final double width;
  final double height;

  const BoundingBox({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  @override
  List<Object> get props => [x, y, width, height];
}
