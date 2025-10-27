import '../../domain/entities/detection.dart';
import '../../domain/repositories/detection_repository.dart';
import '../datasources/detection_remote_data_source.dart';

class DetectionRepositoryImpl implements DetectionRepository {
  final DetectionRemoteDataSource remoteDataSource;

  // Cache for detections to support filtering and acknowledgment
  List<Detection> _cachedDetections = [];

  DetectionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Detection>> getDetections() async {
    try {
      final detectionModels = await remoteDataSource.getDetections();
      _cachedDetections = detectionModels.map((model) => model.toEntity()).toList();
      return _cachedDetections;
    } catch (e) {
      throw Exception('Failed to fetch detections: ${e.toString()}');
    }
  }

  @override
  Future<Detection> acknowledgeDetection(String detectionId) async {
    // In a real app, this would make an API call to acknowledge the detection
    // For now, we'll update the local cache
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _cachedDetections.indexWhere((d) => d.id == detectionId);
    if (index != -1) {
      _cachedDetections[index] = _cachedDetections[index].copyWith(
        status: DetectionStatus.acknowledged,
      );
      return _cachedDetections[index];
    }

    throw Exception('Detection not found');
  }

  @override
  Future<List<Detection>> getDetectionsByType(DetectionType type) async {
    // If cache is empty, fetch from API first
    if (_cachedDetections.isEmpty) {
      await getDetections();
    }

    return _cachedDetections.where((d) => d.type == type).toList();
  }

  @override
  Future<List<Detection>> getDetectionsByStatus(DetectionStatus status) async {
    // If cache is empty, fetch from API first
    if (_cachedDetections.isEmpty) {
      await getDetections();
    }

    return _cachedDetections.where((d) => d.status == status).toList();
  }
}
