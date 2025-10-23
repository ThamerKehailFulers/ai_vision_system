import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/detection.dart';
import '../cubit/detection_cubit.dart';
import '../cubit/detection_state.dart';
import '../widgets/detection_details_bottom_sheet.dart';

class DetectionPage extends StatelessWidget {
  const DetectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Detections',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'View and manage all detection events',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            ),

            // Filters
            const _FilterSection(),

            // Detection count
            const _DetectionCount(),

            // Detection list
            Expanded(
              child: BlocBuilder<DetectionCubit, DetectionState>(
                builder: (context, state) {
                  if (state is DetectionLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.blue),
                    );
                  }

                  if (state is DetectionError) {
                    return Center(
                      child: Text(
                        'Error: ${state.message}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  if (state is DetectionLoaded) {
                    if (state.detections.isEmpty) {
                      return const Center(
                        child: Text(
                          'No detections found',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.all(24),
                      itemCount: state.detections.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        return _DetectionCard(
                          detection: state.detections[index],
                        );
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterSection extends StatelessWidget {
  const _FilterSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          const Icon(Icons.filter_list, color: Colors.grey, size: 20),
          const SizedBox(width: 8),
          const Text(
            'Filters:',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(width: 16),
          _FilterDropdown(
            label: 'All Types',
            onChanged: (dynamic type) {
              context.read<DetectionCubit>().filterByType(
                type as DetectionType?,
              );
            },
          ),
          const SizedBox(width: 16),
          _FilterDropdown(
            label: 'All Status',
            isStatus: true,
            onChanged: (dynamic status) {
              context.read<DetectionCubit>().filterByStatus(
                status as DetectionStatus?,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  final String label;
  final bool isStatus;
  final Function(dynamic) onChanged;

  const _FilterDropdown({
    required this.label,
    required this.onChanged,
    this.isStatus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: DropdownButton<dynamic>(
        value: null,
        hint: Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
        icon: const Icon(
          Icons.keyboard_arrow_down,
          color: Colors.grey,
          size: 16,
        ),
        dropdownColor: const Color(0xFF1A1A1A),
        underline: const SizedBox.shrink(),
        items: isStatus ? _getStatusItems() : _getTypeItems(),
        onChanged: onChanged,
      ),
    );
  }

  List<DropdownMenuItem> _getTypeItems() {
    return [
      const DropdownMenuItem(
        value: null,
        child: Text('All Types', style: TextStyle(color: Colors.white)),
      ),
      ...DetectionType.values.map((type) {
        return DropdownMenuItem(
          value: type,
          child: Text(
            type.name.capitalize(),
            style: const TextStyle(color: Colors.white),
          ),
        );
      }),
    ];
  }

  List<DropdownMenuItem> _getStatusItems() {
    return [
      const DropdownMenuItem(
        value: null,
        child: Text('All Status', style: TextStyle(color: Colors.white)),
      ),
      ...DetectionStatus.values.map((status) {
        return DropdownMenuItem(
          value: status,
          child: Text(
            status.name.capitalize(),
            style: const TextStyle(color: Colors.white),
          ),
        );
      }),
    ];
  }
}

class _DetectionCount extends StatelessWidget {
  const _DetectionCount();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetectionCubit, DetectionState>(
      builder: (context, state) {
        if (state is DetectionLoaded) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
            child: Text(
              'Showing ${state.detections.length} of 100 detections',
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _DetectionCard extends StatelessWidget {
  final Detection detection;

  const _DetectionCard({required this.detection});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _getCardColor(),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getBorderColor(), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(_getDetectionIcon(), color: _getIconColor(), size: 20),
                  const SizedBox(width: 8),
                  Text(
                    detection.displayType,
                    style: TextStyle(
                      color: _getIconColor(),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (detection.status == DetectionStatus.new_)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'New',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      DetectionDetailsBottomSheet.show(context, detection);
                    },
                    style: TextButton.styleFrom(foregroundColor: Colors.blue),
                    child: const Text('View Details'),
                  ),
                  if (detection.status == DetectionStatus.new_) ...[
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        context.read<DetectionCubit>().acknowledgeDetection(
                          detection.id,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      child: const Text('Acknowledge'),
                    ),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _InfoItem('Camera:', detection.camera),
              const SizedBox(width: 24),
              _InfoItem('Time:', _formatTime(detection.timestamp)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _InfoItem(
                'Confidence:',
                '${(detection.confidence * 100).toInt()}%',
              ),
              const SizedBox(width: 24),
              _InfoItem('Class:', detection.className),
            ],
          ),
          if (detection.status == DetectionStatus.acknowledged) ...[
            const SizedBox(height: 12),
            Text(
              'Acknowledged by AlertDataVault on ${_formatTime(detection.timestamp)}',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  Color _getCardColor() {
    switch (detection.type) {
      case DetectionType.person:
        return const Color(0xFF1A2332);
      case DetectionType.vehicle:
        return const Color(0xFF2A1A32);
      case DetectionType.smoke:
        return const Color(0xFF332A1A);
      case DetectionType.fire:
        return const Color(0xFF331A1A);
    }
  }

  Color _getBorderColor() {
    switch (detection.type) {
      case DetectionType.person:
        return Colors.blue.withOpacity(0.3);
      case DetectionType.vehicle:
        return Colors.purple.withOpacity(0.3);
      case DetectionType.smoke:
        return Colors.orange.withOpacity(0.3);
      case DetectionType.fire:
        return Colors.red.withOpacity(0.3);
    }
  }

  Color _getIconColor() {
    switch (detection.type) {
      case DetectionType.person:
        return Colors.blue;
      case DetectionType.vehicle:
        return Colors.purple;
      case DetectionType.smoke:
        return Colors.orange;
      case DetectionType.fire:
        return Colors.red;
    }
  }

  IconData _getDetectionIcon() {
    switch (detection.type) {
      case DetectionType.person:
        return Icons.person;
      case DetectionType.vehicle:
        return Icons.directions_car;
      case DetectionType.smoke:
        return Icons.cloud;
      case DetectionType.fire:
        return Icons.local_fire_department;
    }
  }

  String _formatTime(DateTime dateTime) {
    return DateFormat('MM/dd/yyyy, h:mm:ss a').format(dateTime);
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _InfoItem(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: label,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const TextSpan(text: ' '),
          TextSpan(
            text: value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
