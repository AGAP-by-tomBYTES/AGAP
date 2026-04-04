import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherService {
  Future<Map<String, String>> getWeatherAdvisory() async {
    final apiKey = dotenv.env['OPENWEATHER_API_KEY'];

    if (apiKey == null) {
      throw Exception('API key not found in .env');
    }

    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=Miagao,PH&appid=$apiKey&units=metric',
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to load weather data');
    }

    final data = jsonDecode(response.body);

    final description = data['weather'][0]['description'];
    final temp = data['main']['temp'];

    return {
      'title': 'Weather Advisory',
      'message': 'Current condition: $description, Temp: $temp°C',
    };
  }
}