import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon_model.dart';

class PokemonRepository {
  static const String _baseUrl = 'https://pokeapi.co/api/v2';
  final http.Client _client;

  PokemonRepository({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Pokemon>> getPokemonList({int limit = 20, int offset = 0}) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/pokemon?limit=$limit&offset=$offset'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((json) => Pokemon.fromListJson(json)).toList();
    } else {
      throw Exception('Failed to load pokemon list');
    }
  }

  Future<Pokemon> getPokemonDetail(int id) async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/pokemon/$id'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Pokemon.fromDetailJson(data);
    } else {
      throw Exception('Failed to load pokemon detail');
    }
  }
}
