import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/camera_stream.dart';
import '../repositories/camera_repository.dart';

class GetCameraStreams implements UseCase<List<CameraStream>, NoParams> {
  final CameraRepository repository;

  GetCameraStreams(this.repository);

  @override
  Future<Either<Failure, List<CameraStream>>> call(NoParams params) async {
    return await repository.getCameraStreams();
  }
}

class GetCameraStream implements UseCase<CameraStream, String> {
  final CameraRepository repository;

  GetCameraStream(this.repository);

  @override
  Future<Either<Failure, CameraStream>> call(String params) async {
    return await repository.getCameraStream(params);
  }
}

class StartCameraStream implements UseCase<void, String> {
  final CameraRepository repository;

  StartCameraStream(this.repository);

  @override
  Future<Either<Failure, void>> call(String params) async {
    return await repository.startCameraStream(params);
  }
}

class StopCameraStream implements UseCase<void, String> {
  final CameraRepository repository;

  StopCameraStream(this.repository);

  @override
  Future<Either<Failure, void>> call(String params) async {
    return await repository.stopCameraStream(params);
  }
}
