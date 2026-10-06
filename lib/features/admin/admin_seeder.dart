import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// A helper class for one-time admin tasks
class AdminSeeder {
  // 1. THIS IS YOUR MASTER LIST
  // Add all your public sites here
  static final List<Map<String, dynamic>> _publicSites = [
    {
      'name': 'Rongai Huduma Centre',
      'description':
          'Official government services centre providing ID registration, KRA services, and more. Located next to the main post office.',
      'county': 'Nakuru',
      'subCounty': 'Rongai',
      'hours': 'Mon-Fri, 8:00 AM - 5:00 PM',
      'imageUrl':
          'https://placehold.co/600x400/005A34/FFFFFF?text=Huduma+Centre',
      // IMPORTANT: Create the GeoPoint
      'coordinates': const GeoPoint(-0.1706, 36.0632),
    },
    {
      'name': 'Nakuru County Library',
      'description':
          'Public library with free WiFi, study areas, and a digital learning hub. Open to all residents.',
      'county': 'Nakuru',
      'subCounty': 'Nakuru East',
      'hours': 'Mon-Sat, 9:00 AM - 6:00 PM',
      'imageUrl':
          'https://placehold.co/600x400/004A99/FFFFFF?text=County+Library',
      'coordinates': const GeoPoint(-0.2833, 36.0667),
    },
    {
      'name': 'Gilgil Public WiFi Hotspot',
      'description':
          'Free public WiFi hotspot provided by the county government, located at the main bus terminus.',
      'county': 'Nakuru',
      'subCounty': 'Gilgil',
      'hours': '24/7',
      'imageUrl': 'https://placehold.co/600x400/E87722/FFFFFF?text=Public+WiFi',
      'coordinates': const GeoPoint(-0.5333, 36.3167),
    },
    {
    "name": "",
    "category": "Stage",
    "region": "North Rift",
    "county": "West Pokot",
    "constituency": "Kapenguria"
  },
  {
    "name": "",
    "category": "Government Office",
    "region": "North Rift",
    "county": "Turkana",
    "constituency": "Turkana West"
  },
  {
    "name": "Aberdare (olkalau) Dcc",
    "category": "Government Office",
    "region": "Central & Nairobi",
    "county": "Nyandarua",
    "constituency": "Ol Kalou"
  },
  {
    "name": "Abogeta West Acc",
    "category": "Government Office",
    "region": "Eastern",
    "county": "Meru",
    "constituency": "South Imenti"
  },
  {
    "name": "Aboretum",
    "category": "Open Grounds",
    "region": "North Rift",
    "county": "Uasin Gishu",
    "constituency": "Moiben"
  },
  {
    "name": "Acc Kaiti Office",
    "category": "Government Office",
    "region": "Eastern",
    "county": "Makueni",
    "constituency": "Kaiti"
  },
  {
    "name": "Acc Office/nrb/children/s...",
    "category": "Government Office",
    "region": "Eastern",
    "county": "Makueni",
    "constituency": "Makueni"
  },
  {
    "name": "Ack Tegat Primary School",
    "category": "School",
    "region": "North Rift",
    "county": "Nandi",
    "constituency": "Emgwen"
  },
  {
    "name": "Adult Education",
    "category": "Government Office",
    "region": "South Rift",
    "county": "Narok",
    "constituency": "Narok North"
  },
  {
    "name": "Afya House Wifi",
    "category": "Government Office",
    "region": "Central & Nairobi",
    "county": "Nairobi",
    "constituency": "Starehe"
  },
  {
    "name": "Agricultural Mechanisatio...",
    "category": "Government Office",
    "region": "Eastern",
    "county": "Kitui",
    "constituency": "Kitui Central"
  },
  {
    "name": "Agricultural Office Migwa...",
    "category": "Government Office",
    "region": "Eastern",
    "county": "Kitui",
    "constituency": "Mwingi West"
  },
  {
    "name": "Agricultural Office Mwing...",
    "category": "Government Office",
    "region": "Eastern",
    "county": "Kitui",
    "constituency": "Mwingi Central"
  },
  {
    "name": "Agricultural Training Cen...",
    "category": "Tertiary Education",
    "region": "Eastern",
    "county": "Kitui",
    "constituency": "Kitui Central"
  },
  {
    "name": "Agriculture",
    "category": "Government Office",
    "region": "North Eastern",
    "county": "Marsabit",
    "constituency": "Saku"
  },
  {
    "name": "Agriculture   Livestock D...",
    "category": "Government Office",
    "region": "North Rift",
    "county": "Samburu",
    "constituency": "Samburu West"
  },
  {
    "name": "Agriculture   Locust And ...",
    "category": "Government Office",
    "region": "North Rift",
    "county": "Samburu",
    "constituency": "Samburu West"
  },
  {
    "name": "Agriculture And Vetinary",
    "category": "Government Office",
    "region": "North Eastern",
    "county": "Mandera",
    "constituency": "Mandera East"
  },
  {
    "name": "Agriculture Finance Coope...",
    "category": "Government Office",
    "region": "North Rift",
    "county": "Trans Nzoia",
    "constituency": "Saboti"
  },
  {
    "name": "Agriculture Office Msambw...",
    "category": "Government Office",
    "region": "Coast",
    "county": "Kwale",
    "constituency": "Msambweni"
  },
  {
    "name": "Agriculture Office Nzaui",
    "category": "Government Office",
    "region": "Eastern",
    "county": "Makueni",
    "constituency": "Kibwezi West"
  },
  {
    "name": "Agriculture Sector Develo...",
    "category": "Government Office",
    "region": "South Rift",
    "county": "Laikipia",
    "constituency": "Laikipia East"
  },
  {
    "name": "Ahero Market",
    "category": "Market",
    "region": "Nyanza",
    "county": "Kisumu",
    "constituency": "Nyando"
  },
  {
    "name": "Ahiti Ndomba",
    "category": "Constituency Innovation Hub",
    "region": "Central & Nairobi",
    "county": "Kirinyaga",
    "constituency": "Mwea"
  },
  {
    "name": "Aic Kithimani Primary Sch...",
    "category": "School",
    "region": "Eastern",
    "county": "Machakos",
    "constituency": "Yatta"
  },
  {
    "name": "Aic Lokichoggio Girls Pri...",
    "category": "School",
    "region": "North Rift",
    "county": "Turkana",
    "constituency": "Turkana West"
  },
  {
    "name": "Aic Lokichoggio Mixed Pri...",
    "category": "School",
    "region": "North Rift",
    "county": "Turkana",
    "constituency": "Turkana West"
  },
  {
    "name": "Aic Samoei Model Primary ...",
    "category": "School",
    "region": "North Rift",
    "county": "Uasin Gishu",
    "constituency": "Turbo"
  },
  {
    "name": "Aic Songot Secondary Scho...",
    "category": "School",
    "region": "North Rift",
    "county": "Turkana",
    "constituency": "Turkana West"
  },
  {
    "name": "Ainabkoi (kapsoya)",
    "category": "Government Office",
    "region": "North Rift",
    "county": "Uasin Gishu",
    "constituency": "Ainabkoi"
  },
  {
    "name": "Ajigo Market",
    "category": "Market",
    "region": "Nyanza",
    "county": "Siaya",
    "constituency": "Bondo"
  },
  {
    "name": "Akala",
    "category": "Government Office",
    "region": "Nyanza",
    "county": "Siaya",
    "constituency": "Gem"
  },
  {
    "name": "Amagoro Pri Sch",
    "category": "School",
    "region": "North Rift",
    "county": "Kakamega",
    "constituency": "Lukuyani"
  },
  {
    "name": "Amatu Primary School",
    "category": "School",
    "region": "Eastern",
    "county": "Meru",
    "constituency": "West Tigania"
  },
  {
    "name": "Amatu Scondary School",
    "category": "School",
    "region": "Eastern",
    "county": "Meru",
    "constituency": "West Tigania"
  },
  {
    "name": "Annex",
    "category": "Government Office",
    "region": "South Rift",
    "county": "Laikipia",
    "constituency": "Laikipia East"
  },
  {
    "name": "Ap Camp Nadapal",
    "category": "Government Office",
    "region": "North Rift",
    "county": "Turkana",
    "constituency": "Turkana West"
  },
  {
    "name": "Ap Offices   Mwingi",
    "category": "Government Office",
    "region": "Eastern",
    "county": "Kitui",
    "constituency": "Mwingi Central"
  },
  {
    "name": "Ardhi House",
    "category": "Government Office",
    "region": "North Rift",
    "county": "Uasin Gishu",
    "constituency": "Soy"
  },
  {
    "name": "Ardhi House & Huduma Cent...",
    "category": "Government Office",
    "region": "South Rift",
    "county": "Kericho",
    "constituency": "Ainamoi"
  },
  {
    "name": "As0701006 Huduma Centre G...",
    "category": "Government Office",
    "region": "North Eastern",
    "county": "Garissa",
    "constituency": "Garissa"
  },
  {
    "name": "As0701010 Tkl Public Wifi",
    "category": "Government Office",
    "region": "North Eastern",
    "county": "Garissa",
    "constituency": "Garissa"
  },
  {
    "name": "As3001001 National Regist...",
    "category": "Government Office",
    "region": "North Rift",
    "county": "Baringo",
    "constituency": "Baringo North"
  },
  {
    "name": "As3001003 Baringo North S...",
    "category": "Government Office",
    "region": "North Rift",
    "county": "Baringo",
    "constituency": "Baringo North"
  },
  {
    "name": "As3001004 Kabartonjo Post...",
    "category": "Government Office",
    "region": "North Rift",
    "county": "Baringo",
    "constituency": "Baringo North"
  },
  {
    "name": "As3002001 Mogotio Civil R...",
    "category": "Government Office",
    "region": "North Rift",
    "county": "Baringo",
    "constituency": "Mogotio Constituency"
  },
  {
    "name": "As3002002 Mogotio Posta",
    "category": "Government Office",
    "region": "North Rift",
    "county": "Baringo",
    "constituency": "Mogotio Constituency"
  },
  {
    "name": "As3002003 Mogotio Sub Cou...",
    "category": "Government Office",
    "region": "North Rift",
    "county": "Baringo",
    "constituency": "Mogotio Constituency"
  }
    // ... add all your other sites here
  ];

  // 2. THE SEEDING FUNCTION
  static Future<void> seedPublicSites(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      final firestore = FirebaseFirestore.instance;
      final collection = firestore.collection('public_sites');

      // --- IMPORTANT SAFETY CHECK ---
      // This checks if the collection is *already* seeded.
      // If it's not empty, we stop to prevent duplicates.
      final snapshot = await collection.limit(1).get();
      if (snapshot.docs.isNotEmpty) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('"public_sites" collection is already seeded.'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
      // --- END SAFETY CHECK ---

      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Seeding database... This may take a moment.'),
          backgroundColor: Colors.blue,
        ),
      );

      // Use a "batch write" to upload all sites in one go.
      // This is much faster and more efficient.
      final batch = firestore.batch();

      for (final siteData in _publicSites) {
        // Create a new document reference for each site
        final docRef = collection.doc();
        // Add the site data to the batch
        batch.set(docRef, siteData);
      }

      // Commit the batch to Firestore
      await batch.commit();

      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('SUCCESS: Database seeded with public sites!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('ERROR seeding database: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
