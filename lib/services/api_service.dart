import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String apiKey = 'AIzaSyC-4ST8MtHmxWsbttQhnGbsMMwY-PobGdY'; // Secure this!

  Future<List<dynamic>> fetchPlaces(double latitude, double longitude) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=1500&type=restaurant&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['results']; // Return the list of places
      } else {
        throw Exception('Failed to load places: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching places: $e');
    }
  }
}
