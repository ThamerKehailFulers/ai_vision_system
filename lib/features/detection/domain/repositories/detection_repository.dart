import '../entities/detection.dart';

abstract class DetectionRepository {
  Future<List<Detection>> getDetections();
  Future<Detection> acknowledgeDetection(String detectionId);
  Future<List<Detection>> getDetectionsByType(DetectionType type);
  Future<List<Detection>> getDetectionsByStatus(DetectionStatus status);
}
