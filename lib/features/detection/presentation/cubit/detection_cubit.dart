import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/detection.dart';
import '../../domain/repositories/detection_repository.dart';
import 'detection_state.dart';

class DetectionCubit extends Cubit<DetectionState> {
  final DetectionRepository _repository;

  DetectionCubit(this._repository) : super(DetectionInitial());

  Future<void> loadDetections() async {
    try {
      emit(DetectionLoading());
      final detections = await _repository.getDetections();
      emit(DetectionLoaded(detections: detections));
    } catch (e) {
      emit(DetectionError(e.toString()));
    }
  }

  Future<void> filterByType(DetectionType? type) async {
    final currentState = state;
    if (currentState is DetectionLoaded) {
      try {
        emit(DetectionLoading());
        List<Detection> detections;

        if (type == null) {
          detections = await _repository.getDetections();
        } else {
          detections = await _repository.getDetectionsByType(type);
        }

        emit(
          DetectionLoaded(
            detections: detections,
            selectedType: type,
            selectedStatus: currentState.selectedStatus,
          ),
        );
      } catch (e) {
        emit(DetectionError(e.toString()));
      }
    }
  }

  Future<void> filterByStatus(DetectionStatus? status) async {
    final currentState = state;
    if (currentState is DetectionLoaded) {
      try {
        emit(DetectionLoading());
        List<Detection> detections;

        if (status == null) {
          detections = await _repository.getDetections();
        } else {
          detections = await _repository.getDetectionsByStatus(status);
        }

        emit(
          DetectionLoaded(
            detections: detections,
            selectedType: currentState.selectedType,
            selectedStatus: status,
          ),
        );
      } catch (e) {
        emit(DetectionError(e.toString()));
      }
    }
  }

  Future<void> acknowledgeDetection(String detectionId) async {
    final currentState = state;
    if (currentState is DetectionLoaded) {
      try {
        await _repository.acknowledgeDetection(detectionId);
        // Reload detections to get updated status
        await loadDetections();
      } catch (e) {
        emit(DetectionError(e.toString()));
      }
    }
  }

  void clearFilters() {
    loadDetections();
  }
}
