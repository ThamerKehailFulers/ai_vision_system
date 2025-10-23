import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/camera_cubit.dart';
import 'video_stream_widget.dart';

class CameraGridView extends StatelessWidget {
  const CameraGridView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CameraCubit, CameraState>(
      builder: (context, state) {
        if (state is CameraLoaded) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 16 / 9,
              ),
              itemCount: state.cameraStreams.length,
              itemBuilder: (context, index) {
                final stream = state.cameraStreams[index];
                return VideoStreamWidget(
                  videoUrl: stream.url,
                  cameraName: stream.name,
                  isSelected: state.selectedCameraId == stream.id,
                  isLive: stream.isLive,
                  onTap: () =>
                      context.read<CameraCubit>().selectCamera(stream.id),
                );
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
