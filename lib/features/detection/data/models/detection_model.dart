import '../../domain/entities/detection.dart';

class DetectionModel {
  final String id;
  final String type;
  final String status;
  final String severity;
  final double confidence;
  final String timestamp;
  final int duration;
  final CameraModel camera;
  final DetectionInfoModel detection;
  final AiSummaryModel? aiSummary;

  DetectionModel({
    required this.id,
    required this.type,
    required this.status,
    required this.severity,
    required this.confidence,
    required this.timestamp,
    required this.duration,
    required this.camera,
    required this.detection,
    this.aiSummary,
  });

  factory DetectionModel.fromJson(Map<String, dynamic> json) {
    return DetectionModel(
      id: json['id'] as String,
      type: json['type'] as String,
      status: json['status'] as String,
      severity: json['severity'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      timestamp: json['timestamp'] as String,
      duration: json['duration'] as int,
      camera: CameraModel.fromJson(json['camera'] as Map<String, dynamic>),
      detection: DetectionInfoModel.fromJson(
        json['detection'] as Map<String, dynamic>,
      ),
      aiSummary: json['aiSummary'] != null
          ? AiSummaryModel.fromJson(json['aiSummary'] as Map<String, dynamic>)
          : null,
    );
  }

  Detection toEntity() {
    return Detection(
      id: id,
      type: _parseType(type),
      camera: camera.name,
      timestamp: DateTime.parse(timestamp),
      confidence: confidence,
      className: detection.subClass ?? detection.objectClass,
      status: _parseStatus(status),
      description: aiSummary?.summary,
      severity: severity,
      duration: duration,
      location: camera.location,
      zone: camera.zone,
    );
  }

  DetectionType _parseType(String type) {
    switch (type.toLowerCase()) {
      case 'person':
        return DetectionType.person;
      case 'vehicle':
        return DetectionType.vehicle;
      case 'smoke':
        return DetectionType.smoke;
      case 'fire':
        return DetectionType.fire;
      default:
        return DetectionType.person;
    }
  }

  DetectionStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'new':
        return DetectionStatus.new_;
      case 'acknowledged':
        return DetectionStatus.acknowledged;
      case 'resolved':
      case 'escalated':
        return DetectionStatus.acknowledged;
      default:
        return DetectionStatus.unacknowledged;
    }
  }
}

class CameraModel {
  final String id;
  final String name;
  final String location;
  final String zone;
  final CoordinatesModel? coordinates;

  CameraModel({
    required this.id,
    required this.name,
    required this.location,
    required this.zone,
    this.coordinates,
  });

  factory CameraModel.fromJson(Map<String, dynamic> json) {
    return CameraModel(
      id: json['id'] as String,
      name: json['name'] as String,
      location: json['location'] as String,
      zone: json['zone'] as String,
      coordinates: json['coordinates'] != null
          ? CoordinatesModel.fromJson(
              json['coordinates'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class CoordinatesModel {
  final double latitude;
  final double longitude;

  CoordinatesModel({
    required this.latitude,
    required this.longitude,
  });

  factory CoordinatesModel.fromJson(Map<String, dynamic> json) {
    return CoordinatesModel(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }
}

class DetectionInfoModel {
  final String objectClass;
  final String? subClass;
  final BoundingBoxModel? boundingBox;
  final String? motionStatus;
  final String? direction;
  final String? speed;
  final int? dwellTime;

  DetectionInfoModel({
    required this.objectClass,
    this.subClass,
    this.boundingBox,
    this.motionStatus,
    this.direction,
    this.speed,
    this.dwellTime,
  });

  factory DetectionInfoModel.fromJson(Map<String, dynamic> json) {
    return DetectionInfoModel(
      objectClass: json['objectClass'] as String,
      subClass: json['subClass'] as String?,
      boundingBox: json['boundingBox'] != null
          ? BoundingBoxModel.fromJson(
              json['boundingBox'] as Map<String, dynamic>,
            )
          : null,
      motionStatus: json['motionStatus'] as String?,
      direction: json['direction'] as String?,
      speed: json['speed'] as String?,
      dwellTime: json['dwellTime'] as int?,
    );
  }
}

class BoundingBoxModel {
  final int x;
  final int y;
  final int width;
  final int height;

  BoundingBoxModel({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  factory BoundingBoxModel.fromJson(Map<String, dynamic> json) {
    return BoundingBoxModel(
      x: json['x'] as int,
      y: json['y'] as int,
      width: json['width'] as int,
      height: json['height'] as int,
    );
  }
}

class AiSummaryModel {
  final bool generated;
  final String? generatedAt;
  final String summary;
  final String severity;
  final String? severityReason;
  final String? riskLevel;
  final List<String>? recommendations;
  final List<String>? keyFindings;

  AiSummaryModel({
    required this.generated,
    this.generatedAt,
    required this.summary,
    required this.severity,
    this.severityReason,
    this.riskLevel,
    this.recommendations,
    this.keyFindings,
  });

  factory AiSummaryModel.fromJson(Map<String, dynamic> json) {
    return AiSummaryModel(
      generated: json['generated'] as bool,
      generatedAt: json['generatedAt'] as String?,
      summary: json['summary'] as String,
      severity: json['severity'] as String,
      severityReason: json['severityReason'] as String?,
      riskLevel: json['riskLevel'] as String?,
      recommendations: json['recommendations'] != null
          ? List<String>.from(json['recommendations'] as List)
          : null,
      keyFindings: json['keyFindings'] != null
          ? List<String>.from(json['keyFindings'] as List)
          : null,
    );
  }
}

class DetectionResponseModel {
  final List<DetectionModel> detections;

  DetectionResponseModel({required this.detections});

  factory DetectionResponseModel.fromJson(Map<String, dynamic> json) {
    final detectionsJson = json['detections'] as List;
    final detections = detectionsJson
        .map((d) => DetectionModel.fromJson(d as Map<String, dynamic>))
        .toList();

    return DetectionResponseModel(detections: detections);
  }
}
