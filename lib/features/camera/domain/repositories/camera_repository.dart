import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/camera_stream.dart';

abstract class CameraRepository {
  Future<Either<Failure, List<CameraStream>>> getCameraStreams();
  Future<Either<Failure, CameraStream>> getCameraStream(String id);
  Future<Either<Failure, void>> startCameraStream(String id);
  Future<Either<Failure, void>> stopCameraStream(String id);
  Future<Either<Failure, List<Detection>>> getDetections(String cameraId);
}
