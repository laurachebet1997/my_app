

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/models/public_sites_model.dart';
import '../../auth/providers/public_site_provider.dart';
import 'site_detail_screen.dart';
import 'package:google_fonts/google_fonts.dart';

// This is our new landing page, converted to a ConsumerWidget to read the provider.
class PublicSitesScreen extends ConsumerWidget {
  const PublicSitesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch our new provider. This will rebuild the UI when the data loads.
    final sitesAsyncValue = ref.watch(publicSiteProvider);

    return Scaffold(
      // We don't need an AppBar here, as it's handled by MainAppShell
      body: sitesAsyncValue.when(
        // 1. Loading State
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),

        // 2. Error State
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Failed to load public sites.\n\nError: $error',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),

        // 3. Data Loaded State
        data: (sites) {
          if (sites.isEmpty) {
            return const Center(
              child: Text(
                'No public sites found in the database.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          // This is the "Box Format" (GridView) you wanted!
          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            // Sane defaults for a responsive grid
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200, // Each box can be up to 200px wide
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
              childAspectRatio: 0.8, // Adjust for a nice box shape (Width / Height)
            ),
            itemCount: sites.length,
            itemBuilder: (context, index) {
              final site = sites[index];
              // We pass this individual site to our new card widget
              return PublicSiteCard(site: site);
            },
          );
        },
      ),
    );
  }
}

// I've created a separate widget for the "Box" or "Card"
// This keeps the code much cleaner.
class PublicSiteCard extends StatelessWidget {
  const PublicSiteCard({
    super.key,
    required this.site,
  });

  final PublicSiteModel site;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // When tapped, navigate to the SiteDetailScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SiteDetailScreen(site: site),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12.0),
      child: Card(
        elevation: 2,
        clipBehavior: Clip.antiAlias, // Ensures the image respects the border
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. The Image
            // We wrap the image in a Hero widget for a beautiful
            // page transition animation. The "tag" must be unique.
            Expanded(
              child: Hero(
                tag: site.id, // Must match the tag on the detail page
                child: Container(
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: Image.network(
                    site.imageUrl,
                    fit: BoxFit.cover,
                    // Handle loading and errors for the image
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.location_city, color: Colors.grey[400], size: 40);
                    },
                  ),
                ),
              ),
            ),
            
            // 2. The Text Content
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Site Name
                  Text(
                    site.name,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Site Location
                  Text(
                    site.subCounty,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.normal,
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


