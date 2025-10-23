part of 'camera_cubit.dart';

abstract class CameraState extends Equatable {
  const CameraState();

  @override
  List<Object?> get props => [];
}

class CameraInitial extends CameraState {}

class CameraLoading extends CameraState {}

class CameraLoaded extends CameraState {
  final List<CameraStream> cameraStreams;
  final String? selectedCameraId;

  const CameraLoaded(this.cameraStreams, {this.selectedCameraId});

  CameraLoaded copyWith({
    List<CameraStream>? cameraStreams,
    String? selectedCameraId,
  }) {
    return CameraLoaded(
      cameraStreams ?? this.cameraStreams,
      selectedCameraId: selectedCameraId ?? this.selectedCameraId,
    );
  }

  @override
  List<Object?> get props => [cameraStreams, selectedCameraId];
}

class CameraError extends CameraState {
  final String message;

  const CameraError(this.message);

  @override
  List<Object> get props => [message];
}
