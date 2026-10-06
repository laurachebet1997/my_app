import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../auth/models/feedback.model.dart';

class ReportDetailScreen extends StatelessWidget {
  final FeedbackModel feedback;

  const ReportDetailScreen({super.key, required this.feedback});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final reportLocation =
        LatLng(feedback.location.latitude, feedback.location.longitude);

    return Scaffold(
      appBar: AppBar(
        title: Text(feedback.subject),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Mini-Map View
          SizedBox(
            height: 250,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: reportLocation,
                  initialZoom: 15.0,
                  interactionOptions: const InteractionOptions(
                    // This disables all map interactions
                    flags: 0,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: const ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 40.0,
                        height: 40.0,
                        point: reportLocation,
                        child: Icon(
                          Icons.location_pin,
                          color: theme.colorScheme.error,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Report Details
          Text(
            feedback.subject,
            style: theme.textTheme.headlineMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Chip(
            label: Text(feedback.category),
            backgroundColor: theme.primaryColor.withOpacity(0.1),
            labelStyle: TextStyle(color: theme.primaryColorDark),
            avatar: Icon(Icons.category_outlined, color: theme.primaryColorDark),
          ),
          const SizedBox(height: 16),
          Text(
            feedback.message,
            style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16),
          ),
          const Divider(height: 40),

          // Submitted Info
          _buildDetailRow(
            context,
            icon: Icons.person_outline,
            title: 'Submitted by',
            value: feedback.submittedBy,
          ),
          _buildDetailRow(
            context,
            icon: Icons.email_outlined,
            title: 'Submitter Email',
            value: feedback.email,
          ),
          _buildDetailRow(
            context,
            icon: Icons.calendar_today_outlined,
            title: 'Submitted',
            value: timeago.format(feedback.timestamp),
          ),
          _buildDetailRow(
            context,
            icon: Icons.map_outlined,
            title: 'County',
            value: feedback.county,
          ),
          _buildDetailRow(
            context,
            icon: Icons.maps_home_work_outlined,
            title: 'Sub-County',
            value: feedback.subCounty,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context,
      {required IconData icon, required String title, required String value}) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.primaryColor, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.bodySmall),
                Text(value, style: theme.textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
