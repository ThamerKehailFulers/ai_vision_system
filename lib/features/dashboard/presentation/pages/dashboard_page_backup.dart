import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dashboard',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'AI Vision System - Real-time Fire and Object Detection',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Top metrics row
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.22,
                              child: _buildMetricCard(
                                'Active Cameras',
                                '9',
                                '10',
                                Icons.videocam,
                                Colors.green,
                                '1 offline',
                              ),
                            ),
                            const SizedBox(width: 16),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.22,
                              child: _buildMetricCard(
                                'Fire Detections',
                                '18',
                                '',
                                Icons.local_fire_department,
                                Colors.red,
                                'Last 60 detections',
                              ),
                            ),
                            const SizedBox(width: 16),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.22,
                              child: _buildMetricCard(
                                'Smoke Detections',
                                '21',
                                '',
                                Icons.cloud,
                                Colors.orange,
                                'Last 60 detections',
                              ),
                            ),
                            const SizedBox(width: 16),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.22,
                              child: _buildMetricCard(
                                'Unacknowledged Alerts',
                                '424',
                                '',
                                Icons.warning,
                                Colors.grey,
                                'Requires attention',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Top charts row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Detection Trends Chart
                          Expanded(
                            flex: 2,
                            child: _buildDetectionTrendsChart(),
                          ),
                          const SizedBox(width: 16),
                          // Camera Status Chart
                          Expanded(flex: 1, child: _buildCameraStatusChart()),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Bottom charts row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top Detection Types
                          Expanded(
                            flex: 1,
                            child: _buildTopDetectionTypesChart(),
                          ),
                          const SizedBox(width: 16),
                          // Alert Severity Chart
                          Expanded(flex: 1, child: _buildAlertSeverityChart()),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Weekly heatmap
                      _buildWeeklyHeatmap(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    String subValue,
    IconData icon,
    Color color,
    String subtitle,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (subValue.isNotEmpty) ...[
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    '/ $subValue',
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildDetectionTrendsChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Detection Trends',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '7-day detection patterns',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 10,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withValues(alpha: 0.2),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        const days = [
                          'Mon',
                          'Tue',
                          'Wed',
                          'Thu',
                          'Fri',
                          'Sat',
                          'Sun',
                        ];
                        if (value.toInt() < days.length) {
                          return Text(
                            days[value.toInt()],
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 10),
                      const FlSpot(1, 15),
                      const FlSpot(2, 25),
                      const FlSpot(3, 35),
                      const FlSpot(4, 45),
                    ],
                    isCurved: true,
                    color: Colors.red,
                    barWidth: 3,
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.red.withValues(alpha: 0.1),
                    ),
                    dotData: const FlDotData(show: false),
                  ),
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 20),
                      const FlSpot(1, 30),
                      const FlSpot(2, 40),
                      const FlSpot(3, 50),
                      const FlSpot(4, 60),
                    ],
                    isCurved: true,
                    color: Colors.orange,
                    barWidth: 3,
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.orange.withValues(alpha: 0.1),
                    ),
                    dotData: const FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            children: [
              _buildLegendItem('Fire', Colors.red),
              _buildLegendItem('Smoke', Colors.orange),
              _buildLegendItem('Person', Colors.blue),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildCameraStatusChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Camera Status',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Operational status',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 120,
            width: 30,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    color: const Color.fromARGB(255, 33, 16, 133),
                    value: 40,
                    title: '90%',
                    radius: 50,
                    titleStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    color: Colors.red,
                    value: 10,
                    title: '10%',
                    radius: 20,
                    titleStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
                centerSpaceRadius: 40,
                sectionsSpace: 2,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            children: [
              _buildLegendItem('Online', Colors.green),
              _buildLegendItem('Error', Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopDetectionTypesChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Detection Types',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Most frequent detections',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 24),
          _buildHorizontalBarItem('Vehicle', 75, Colors.purple),
          const SizedBox(height: 12),
          _buildHorizontalBarItem('Person', 65, Colors.blue),
          const SizedBox(height: 12),
          _buildHorizontalBarItem('Fire', 85, Colors.red),
          const SizedBox(height: 12),
          _buildHorizontalBarItem('Smoke', 55, Colors.orange),
        ],
      ),
    );
  }

  Widget _buildHorizontalBarItem(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${value.toInt()}',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: value / 100,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAlertSeverityChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Alert Severity',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Priority levels breakdown',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 24),
          _buildHorizontalBarItem('Critical', 95, Colors.red),
          const SizedBox(height: 12),
          _buildHorizontalBarItem('High', 70, Colors.orange),
          const SizedBox(height: 12),
          _buildHorizontalBarItem('Medium', 45, Colors.yellow),
          const SizedBox(height: 12),
          _buildHorizontalBarItem('Low', 25, Colors.green),
        ],
      ),
    );
  }

  Widget _buildWeeklyHeatmap() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weekly Detection Heatmap',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Detection patterns by day and time',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              // Days labels
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  ...['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].map(
                    (day) => Container(
                      height: 30,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        day,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              // Heatmap grid
              Expanded(
                child: Column(
                  children: [
                    // Hours labels
                    Row(
                      children: [
                        for (int i = 0; i < 24; i += 4)
                          Expanded(
                            child: Text(
                              '${i.toString().padLeft(2, '0')}:00',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Heatmap cells
                    Column(
                      children: [
                        for (int day = 0; day < 7; day++)
                          Container(
                            height: 30,
                            margin: const EdgeInsets.only(bottom: 2),
                            child: Row(
                              children: [
                                for (int hour = 0; hour < 24; hour++)
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 1),
                                      decoration: BoxDecoration(
                                        color: _getHeatmapColor(day, hour),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getHeatmapColor(int day, int hour) {
    // Simulate some detection intensity data
    final intensity = ((day + 1) * (hour + 1) % 100) / 100.0;
    if (intensity > 0.8) return Colors.red.withValues(alpha: 0.8);
    if (intensity > 0.6) return Colors.orange.withValues(alpha: 0.8);
    if (intensity > 0.4) return Colors.yellow.withValues(alpha: 0.8);
    if (intensity > 0.2) return Colors.green.withValues(alpha: 0.8);
    return Colors.grey.withValues(alpha: 0.2);
  }
}
