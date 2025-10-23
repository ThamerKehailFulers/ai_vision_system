import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/camera_stream.dart';

part 'camera_state.dart';

class CameraCubit extends Cubit<CameraState> {
  CameraCubit() : super(CameraInitial());

  void loadCameraStreams() {
    emit(CameraLoading());
    try {
      // Sample video URLs from the internet for demonstration
      final streams = [
        CameraStream(
          id: '1',
          name: 'Big Buck Bunny',
          url:
              'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
          isLive: true,
          lastUpdate: DateTime.now(),
        ),
        CameraStream(
          id: '2',
          name: 'Elephants Dream',
          url:
              'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
          isLive: true,
          lastUpdate: DateTime.now(),
        ),
        CameraStream(
          id: '3',
          name: 'For Bigger Blazes',
          url:
              'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
          isLive: true,
          lastUpdate: DateTime.now(),
        ),
        CameraStream(
          id: '4',
          name: 'Sintel Trailer',
          url:
              'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4',
          isLive: true,
          lastUpdate: DateTime.now(),
        ),
      ];
      emit(CameraLoaded(streams));
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
