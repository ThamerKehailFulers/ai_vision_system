import 'package:equatable/equatable.dart';
import '../../domain/entities/detection.dart';

abstract class DetectionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DetectionInitial extends DetectionState {}

class DetectionLoading extends DetectionState {}

class DetectionLoaded extends DetectionState {
  final List<Detection> detections;
  final DetectionType? selectedType;
  final DetectionStatus? selectedStatus;

  DetectionLoaded({
    required this.detections,
    this.selectedType,
    this.selectedStatus,
  });

  @override
  List<Object?> get props => [detections, selectedType, selectedStatus];

  DetectionLoaded copyWith({
    List<Detection>? detections,
    DetectionType? selectedType,
    DetectionStatus? selectedStatus,
  }) {
    return DetectionLoaded(
      detections: detections ?? this.detections,
      selectedType: selectedType ?? this.selectedType,
      selectedStatus: selectedStatus ?? this.selectedStatus,
    );
  }
}

class DetectionError extends DetectionState {
  final String message;

  DetectionError(this.message);

  @override
  List<Object> get props => [message];
}
