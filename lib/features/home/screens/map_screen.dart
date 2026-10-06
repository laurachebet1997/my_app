

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../auth/providers/feedback_stream_provider.dart'; // Import your stream
// ignore: unused_import
import '../../auth/models/feedback.model.dart'; // Import our model

/*class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Watch the same stream
    final feedbackAsync = ref.watch(feedbackStreamProvider);

    // 2. Handle loading, error, and data states
    return feedbackAsync.when(
      // --- LOADING STATE ---
      loading: () => const Center(child: CircularProgressIndicator()),
      
      // --- ERROR STATE ---
      error: (err, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Error loading map data: $err'),
        ),
      ),
      
      // --- DATA STATE ---
      data: (feedbackList) {
        
        if (feedbackList.isEmpty) {
          // Show the map centered, but with a message
          return Stack(
            children: [
              FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(-1.286389, 36.817223), // Center on Nairobi
                  initialZoom: 6.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: const ['a', 'b', 'c'],
                  ),
                ],
              ),
              const Center(
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('No feedback markers to display.'),
                  ),
                ),
              ),
            ],
          );
        }

        // 3. Process the data to create map markers
        final markers = feedbackList.map((feedback) {
          // --- IMPORTANT ---
          // We don't have real coordinates yet.
          // We'll default to Nairobi for now.
          // TODO: Add real LatLng to feedback or use a county-to-LatLng converter
          final position = LatLng(-1.286389, 36.817223);

          return Marker(
            width: 80.0,
            height: 80.0,
            point: position,
            child: Tooltip(
              message: '${feedback.county}: ${feedback.message}',
              child: Icon(
                Icons.location_on,
                color: Colors.red[700],
                size: 40,
              ),
            ),
          );
        }).toList();

        // --- Build the Map UI ---
        return FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(-1.286389, 36.817223), // Center on Nairobi
            initialZoom: 6.0,
            minZoom: 5.0,
            maxZoom: 18.0,
          ),
          children: [
            // Base map tile layer
            TileLayer(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: const ['a', 'b', 'c'],
            ),
            
            // Layer for all our feedback markers
            MarkerLayer(markers: markers),
          ],
        );
      },
    );
  }
}*/

/*import 'package.flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:bilawaya_app/features/home/models/feedback_model.dart';
import 'package:bilawaya_app/features/home/providers/feedback_stream_provider.dart';*/
// Import the new detail screen
import 'report_detail_screen.dart';

// Convert to a ConsumerStatefulWidget to manage the selected marker state
class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  // This will hold the feedback item for the marker we've tapped
  FeedbackModel? _selectedFeedback;

  // We need a MapController to deselect the marker when the map is tapped
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    final feedbackStream = ref.watch(feedbackStreamProvider);
    final theme = Theme.of(context);

    return feedbackStream.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: ${err.toString()}')),
      data: (feedbackList) {
        // Build the list of markers from our feedback data
        final markers = feedbackList.map((feedback) {
          return Marker(
            width: 40.0,
            height: 40.0,
            point:
                LatLng(feedback.location.latitude, feedback.location.longitude),
            child: GestureDetector(
              onTap: () {
                // When tapped, set this as the selected feedback
                setState(() {
                  _selectedFeedback = feedback;
                });
              },
              child: Icon(
                Icons.location_pin,
                // Make the selected marker stand out
                color: _selectedFeedback == feedback
                    ? theme.colorScheme.secondary
                    : theme.primaryColor,
                size: 40.0,
                shadows: [
                  Shadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 5,
                      offset: const Offset(0, 3))
                ],
              ),
            ),
          );
        }).toList();

        // Use a Stack to place the pop-up on top of the map
        return Stack(
          children: [
            // The Map
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: const LatLng(-0.303099,
                    36.080025), // Centered on Nakuru (approx)
                initialZoom: 9.0,
                onTap: (tapPosition, point) {
                  // When the map itself is tapped, deselect any marker
                  setState(() {
                    _selectedFeedback = null;
                  });
                },
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c'],
                ),
                MarkerLayer(markers: markers),
              ],
            ),

            // The Pop-up Card (This is the new part!)
            if (_selectedFeedback != null)
              Align(
                alignment: Alignment.bottomCenter,
                child: Card(
                  margin: const EdgeInsets.all(20.0),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    width: double.infinity,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Row with Title and Close Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                _selectedFeedback!.subject,
                                style: theme.textTheme.titleLarge,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                setState(() {
                                  _selectedFeedback = null;
                                });
                              },
                            )
                          ],
                        ),
                        Text(
                          _selectedFeedback!.category,
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(color: theme.primaryColor),
                        ),
                        const Divider(height: 24),
                        // The "Level Up" button!
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.article_outlined),
                            label: const Text('View Full Report'),
                            onPressed: () {
                              // Navigate to the new detail screen
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ReportDetailScreen(
                                    feedback: _selectedFeedback!,
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}




