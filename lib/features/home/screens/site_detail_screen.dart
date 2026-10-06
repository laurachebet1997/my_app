import 'package:flutter/material.dart';
import '../../auth/models/public_sites_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class SiteDetailScreen extends StatelessWidget {
  final PublicSiteModel site;

  const SiteDetailScreen({super.key, required this.site});

  @override
  Widget build(BuildContext context) {
    // Get the primary color from the theme
    final Color primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Text(site.name),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Image
            // The Hero widget provides a smooth animation from the grid page.
            Hero(
              tag: site.id, // Must match the tag in the grid
              child: Image.network(
                site.imageUrl,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                // Placeholder while loading
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 250,
                    color: Colors.grey[200],
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
                // Error placeholder
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 250,
                    color: Colors.grey[200],
                    child: Icon(Icons.broken_image,
                        color: Colors.grey[400], size: 50),
                  );
                },
              ),
            ),
            
            // 2. Content Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Site Name
                  Text(
                    site.name,
                    style: GoogleFonts.inter(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Location Info
                  _buildInfoRow(
                    context,
                    icon: Icons.location_on_outlined,
                    text: '${site.subCounty}, ${site.county}',
                    color: primaryColor,
                  ),
                  const SizedBox(height: 8),

                  // Hours Info
                  _buildInfoRow(
                    context,
                    icon: Icons.access_time_outlined,
                    text: site.hours,
                    color: primaryColor,
                  ),
                  const SizedBox(height: 24),

                  // Description
                  Text(
                    'About this site',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    site.description,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      height: 1.5,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 3. Mini-Map
                  Text(
                    'Location on Map',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 250,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: LatLng(
                          site.coordinates.latitude,
                          site.coordinates.longitude,
                        ),
                        initialZoom: 15.0,
                        keepAlive: true,
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
                              width: 80.0,
                              height: 80.0,
                              point: LatLng(
                                site.coordinates.latitude,
                                site.coordinates.longitude,
                              ),
                              child: Icon(
                                Icons.location_pin,
                                color: primaryColor,
                                size: 40.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget to build consistent info rows
  Widget _buildInfoRow(BuildContext context,
      {required IconData icon, required String text, required Color color}) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 15,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }
}

