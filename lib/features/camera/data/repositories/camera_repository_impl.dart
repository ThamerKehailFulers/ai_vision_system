import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/camera_stream.dart';
import '../../domain/repositories/camera_repository.dart';
import '../datasources/camera_remote_data_source.dart';
import '../models/camera_view_model.dart';

class CameraRepositoryImpl implements CameraRepository {
  final CameraRemoteDataSource remoteDataSource;

  // Cache for camera data
  CameraViewModel? _cachedCameraView;
  List<CameraStream> _cachedStreams = [];

  CameraRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<CameraStream>>> getCameraStreams() async {
    try {
      _cachedCameraView = await remoteDataSource.getCameraView();
      _cachedStreams = _cachedCameraView!.cameras
          .map((model) => model.toEntity())
          .toList();
      return Right(_cachedStreams);
    } catch (e) {
      return Left(CameraFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CameraStream>> getCameraStream(String id) async {
    try {
      // If cache is empty, fetch from API first
      if (_cachedStreams.isEmpty) {
        await getCameraStreams();
      }

      final camera = _cachedStreams.firstWhere(
        (c) => c.id == id,
        orElse: () => throw Exception('Camera not found'),
      );

      return Right(camera);
    } catch (e) {
      return Left(CameraFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> startCameraStream(String id) async {
    // This would typically make an API call to start the camera stream
    // For now, we'll just return success
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return const Right(null);
    } catch (e) {
      return Left(CameraFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> stopCameraStream(String id) async {
    // This would typically make an API call to stop the camera stream
    // For now, we'll just return success
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return const Right(null);
    } catch (e) {
      return Left(CameraFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Detection>>> getDetections(String cameraId) async {
    try {
      // If cache is empty, fetch from API first
      if (_cachedStreams.isEmpty) {
        await getCameraStreams();
      }

      final camera = _cachedStreams.firstWhere(
        (c) => c.id == cameraId,
        orElse: () => throw Exception('Camera not found'),
      );

      return Right(camera.detections);
    } catch (e) {
      return Left(CameraFailure(e.toString()));
    }
  }

  // Additional helper method to get camera view config and statistics
  CameraViewModel? get cachedCameraView => _cachedCameraView;
}
