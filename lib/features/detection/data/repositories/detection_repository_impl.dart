import '../../domain/entities/detection.dart';
import '../../domain/repositories/detection_repository.dart';

class DetectionRepositoryImpl implements DetectionRepository {
  // Mock data for demonstration - in real app this would come from API/database
  final List<Detection> _mockDetections = [
    Detection(
      id: '1',
      type: DetectionType.person,
      camera: 'cam-1',
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      confidence: 0.89,
      className: 'person',
      status: DetectionStatus.acknowledged,
    ),
    Detection(
      id: '2',
      type: DetectionType.smoke,
      camera: 'cam-2',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      confidence: 0.94,
      className: 'smoke',
      status: DetectionStatus.acknowledged,
    ),
    Detection(
      id: '3',
      type: DetectionType.vehicle,
      camera: 'cam-3',
      timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
      confidence: 0.83,
      className: 'vehicle',
      status: DetectionStatus.acknowledged,
    ),
    Detection(
      id: '4',
      type: DetectionType.vehicle,
      camera: 'cam-3',
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      confidence: 0.76,
      className: 'vehicle',
      status: DetectionStatus.new_,
    ),
    Detection(
      id: '5',
      type: DetectionType.fire,
      camera: 'cam-10',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      confidence: 0.90,
      className: 'fire',
      status: DetectionStatus.new_,
    ),
    Detection(
      id: '6',
      type: DetectionType.smoke,
      camera: 'cam-9',
      timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
      confidence: 0.88,
      className: 'smoke',
      status: DetectionStatus.new_,
    ),
  ];

  @override
  Future<List<Detection>> getDetections() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_mockDetections);
  }

  @override
  Future<Detection> acknowledgeDetection(String detectionId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _mockDetections.indexWhere((d) => d.id == detectionId);
    if (index != -1) {
      _mockDetections[index] = _mockDetections[index].copyWith(
        status: DetectionStatus.acknowledged,
      );
      return _mockDetections[index];
    }

    throw Exception('Detection not found');
  }

  @override
  Future<List<Detection>> getDetectionsByType(DetectionType type) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockDetections.where((d) => d.type == type).toList();
  }

  @override
  Future<List<Detection>> getDetectionsByStatus(DetectionStatus status) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockDetections.where((d) => d.status == status).toList();
  }
}
