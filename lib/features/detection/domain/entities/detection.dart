import 'package:equatable/equatable.dart';

enum DetectionType { person, vehicle, smoke, fire }

enum DetectionStatus { acknowledged, unacknowledged, new_ }

class Detection extends Equatable {
  final String id;
  final DetectionType type;
  final String camera;
  final DateTime timestamp;
  final double confidence;
  final String className;
  final DetectionStatus status;
  final String? description;
  final String? severity;
  final int? duration;
  final String? location;
  final String? zone;

  const Detection({
    required this.id,
    required this.type,
    required this.camera,
    required this.timestamp,
    required this.confidence,
    required this.className,
    required this.status,
    this.description,
    this.severity,
    this.duration,
    this.location,
    this.zone,
  });

  @override
  List<Object?> get props => [
    id,
    type,
    camera,
    timestamp,
    confidence,
    className,
    status,
    description,
    severity,
    duration,
    location,
    zone,
  ];

  Detection copyWith({
    String? id,
    DetectionType? type,
    String? camera,
    DateTime? timestamp,
    double? confidence,
    String? className,
    DetectionStatus? status,
    String? description,
    String? severity,
    int? duration,
    String? location,
    String? zone,
  }) {
    return Detection(
      id: id ?? this.id,
      type: type ?? this.type,
      camera: camera ?? this.camera,
      timestamp: timestamp ?? this.timestamp,
      confidence: confidence ?? this.confidence,
      className: className ?? this.className,
      status: status ?? this.status,
      description: description ?? this.description,
      severity: severity ?? this.severity,
      duration: duration ?? this.duration,
      location: location ?? this.location,
      zone: zone ?? this.zone,
    );
  }

  String get displayType {
    switch (type) {
      case DetectionType.person:
        return 'Person Detected';
      case DetectionType.vehicle:
        return 'Vehicle Detected';
      case DetectionType.smoke:
        return 'Smoke Detected';
      case DetectionType.fire:
        return 'Fire Detected';
    }
  }

  String get statusLabel {
    switch (status) {
      case DetectionStatus.acknowledged:
        return 'Acknowledged';
      case DetectionStatus.unacknowledged:
        return 'Unacknowledged';
      case DetectionStatus.new_:
        return 'New';
    }
  }
}
