import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/services/notification_service.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  final NotificationService _notificationService = NotificationService();

  // Notification preferences
  bool _detectionsEnabled = true;
  bool _camerasEnabled = true;
  bool _systemAlertsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: const Text(
          'Notification Settings',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF0A0A0A),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // FCM Token Section
          _buildTokenSection(),
          const SizedBox(height: 24),

          // Notification Topics
          _buildSectionTitle('Notification Topics'),
          _buildTopicTile(
            'Detections',
            'Receive alerts for new detections',
            _detectionsEnabled,
            (value) async {
              setState(() => _detectionsEnabled = value);
              if (value) {
                await _notificationService.subscribeToTopic('detections');
              } else {
                await _notificationService.unsubscribeFromTopic('detections');
              }
            },
            Icons.security,
            Colors.red,
          ),
          _buildTopicTile(
            'Cameras',
            'Receive alerts about camera status',
            _camerasEnabled,
            (value) async {
              setState(() => _camerasEnabled = value);
              if (value) {
                await _notificationService.subscribeToTopic('cameras');
              } else {
                await _notificationService.unsubscribeFromTopic('cameras');
              }
            },
            Icons.videocam,
            Colors.blue,
          ),
          _buildTopicTile(
            'System Alerts',
            'Receive system status updates',
            _systemAlertsEnabled,
            (value) async {
              setState(() => _systemAlertsEnabled = value);
              if (value) {
                await _notificationService.subscribeToTopic('system_alerts');
              } else {
                await _notificationService.unsubscribeFromTopic('system_alerts');
              }
            },
            Icons.notifications,
            Colors.orange,
          ),

          const SizedBox(height: 24),

          // Notification Settings
          _buildSectionTitle('Notification Preferences'),
          _buildPreferenceTile(
            'Sound',
            'Play sound for notifications',
            _soundEnabled,
            (value) => setState(() => _soundEnabled = value),
            Icons.volume_up,
          ),
          _buildPreferenceTile(
            'Vibration',
            'Vibrate for notifications',
            _vibrationEnabled,
            (value) => setState(() => _vibrationEnabled = value),
            Icons.vibration,
          ),

          const SizedBox(height: 24),

          // Test Notification
          _buildSectionTitle('Test Notifications'),
          const SizedBox(height: 8),
          _buildTestButton(
            'Test Detection Alert',
            'Send a test detection notification',
            Icons.security,
            Colors.red,
            () => _sendTestNotification(
              'New Detection Alert',
              'Smoke detected in Loading Dock - Camera 6',
              {'type': 'detection', 'id': 'det_test_001'},
            ),
          ),
          const SizedBox(height: 8),
          _buildTestButton(
            'Test Camera Alert',
            'Send a test camera notification',
            Icons.videocam,
            Colors.blue,
            () => _sendTestNotification(
              'Camera Status Alert',
              'Camera 5 is offline - Last seen 2 hours ago',
              {'type': 'camera', 'id': 'cam_005'},
            ),
          ),
          const SizedBox(height: 8),
          _buildTestButton(
            'Test System Alert',
            'Send a test system notification',
            Icons.info,
            Colors.orange,
            () => _sendTestNotification(
              'System Update',
              'AI Vision System has been updated to v1.0.1',
              {'type': 'system', 'action': 'update'},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTokenSection() {
    final token = _notificationService.fcmToken;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.phone_android, color: Colors.blue, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Device FCM Token',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    token ?? 'Loading...',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                      fontFamily: 'monospace',
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (token != null)
                  IconButton(
                    icon: const Icon(Icons.copy, size: 18),
                    color: Colors.blue,
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: token));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Token copied to clipboard'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Use this token to send notifications to this device',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTopicTile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
    IconData icon,
    Color iconColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value
              ? iconColor.withValues(alpha: 0.3)
              : Colors.grey.withValues(alpha: 0.2),
        ),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(left: 48, top: 4),
          child: Text(
            subtitle,
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ),
        activeThumbColor: iconColor,
      ),
    );
  }

  Widget _buildPreferenceTile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
    IconData icon,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        title: Row(
          children: [
            Icon(icon, color: Colors.blue, size: 20),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(left: 32, top: 4),
          child: Text(
            subtitle,
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ),
        activeThumbColor: Colors.blue,
      ),
    );
  }

  Widget _buildTestButton(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
        trailing: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          child: const Text('Send'),
        ),
      ),
    );
  }

  void _sendTestNotification(
    String title,
    String body,
    Map<String, String> data,
  ) {
    _notificationService.showLocalNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      payload: data.toString(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Test notification sent: $title'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }
}
