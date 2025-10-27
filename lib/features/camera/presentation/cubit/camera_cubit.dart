import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/camera_stream.dart';
import '../../domain/repositories/camera_repository.dart';

part 'camera_state.dart';

class CameraCubit extends Cubit<CameraState> {
  final CameraRepository repository;

  CameraCubit(this.repository) : super(CameraInitial());

  Future<void> loadCameraStreams() async {
    emit(CameraLoading());
    try {
      final result = await repository.getCameraStreams();

      result.fold(
        (failure) {
          String message = 'Failed to load camera streams';
          if (failure is CameraFailure) {
            message = failure.message;
          }
          emit(CameraError(message));
        },
        (streams) {
          emit(CameraLoaded(streams));
        },
      );
    } catch (e) {
      emit(CameraError(e.toString()));
    }
  }

  void selectCamera(String cameraId) {
    if (state is CameraLoaded) {
      final currentState = state as CameraLoaded;
      emit(currentState.copyWith(selectedCameraId: cameraId));
    }
  }
}
