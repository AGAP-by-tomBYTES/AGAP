import 'dart:convert';

import 'package:http/http.dart' as http;

class EarthquakeService {
  Future<List<Map<String, String>>> getEarthquakeReports() async {
    final url = Uri.parse(
      'https://earthquake.usgs.gov/fdsnws/event/1/query'
      '?format=geojson'
      '&minlatitude=4'
      '&maxlatitude=22'
      '&minlongitude=116'
      '&maxlongitude=127'
      '&minmagnitude=4.5'
      '&limit=3'
      '&orderby=time',
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to load earthquake data');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final features = (data['features'] as List<dynamic>? ?? []);

    return features.map((feature) {
      final item = feature as Map<String, dynamic>;
      final properties = item['properties'] as Map<String, dynamic>? ?? {};
      final magnitude = properties['mag'];
      final place = properties['place'] as String? ?? 'Unknown location';
      final time = properties['time'] as int?;

      return {
        'title': 'Earthquake M${_formatMagnitude(magnitude)} near $place',
        'subtitle': '${_formatRelativeTime(time)} · USGS',
      };
    }).toList();
  }

  String _formatMagnitude(dynamic magnitude) {
    if (magnitude is num) {
      return magnitude.toStringAsFixed(1);
    }
    return '?';
  }

  String _formatRelativeTime(int? timestampMs) {
    if (timestampMs == null) {
      return 'Recently reported';
    }

    final difference = DateTime.now().difference(
      DateTime.fromMillisecondsSinceEpoch(timestampMs),
    );

    if (difference.inMinutes < 1) {
      return 'Just now';
    }
    if (difference.inHours < 1) {
      return '${difference.inMinutes} min ago';
    }
    if (difference.inDays < 1) {
      return '${difference.inHours} hr ago';
    }
    return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
  }
}
