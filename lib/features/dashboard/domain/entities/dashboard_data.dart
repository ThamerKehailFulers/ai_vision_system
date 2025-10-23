import 'package:equatable/equatable.dart';

class DashboardData extends Equatable {
  final int totalCameras;
  final int activeCameras;
  final int totalDetections;
  final int alertsCount;
  final List<AlertItem> recentAlerts;
  final Map<String, int> detectionStats;
  final DateTime lastUpdate;

  const DashboardData({
    required this.totalCameras,
    required this.activeCameras,
    required this.totalDetections,
    required this.alertsCount,
    this.recentAlerts = const [],
    this.detectionStats = const {},
    required this.lastUpdate,
  });

  @override
  List<Object> get props => [
    totalCameras,
    activeCameras,
    totalDetections,
    alertsCount,
    recentAlerts,
    detectionStats,
    lastUpdate,
  ];
}

class AlertItem extends Equatable {
  final String id;
  final String message;
  final String severity;
  final String cameraId;
  final DateTime timestamp;
  final bool isRead;

  const AlertItem({
    required this.id,
    required this.message,
    required this.severity,
    required this.cameraId,
    required this.timestamp,
    this.isRead = false,
  });

  @override
  List<Object> get props => [
    id,
    message,
    severity,
    cameraId,
    timestamp,
    isRead,
  ];
}
