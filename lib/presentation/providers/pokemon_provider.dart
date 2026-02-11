import 'package:flutter/material.dart';
import '../../data/models/pokemon_model.dart';
import '../../data/repositories/pokemon_repository.dart';

class PokemonProvider with ChangeNotifier {
  final PokemonRepository _repository;
  List<Pokemon> _pokemonList = [];
  bool _isLoading = false;
  String? _error;
  int _offset = 0;
  final int _limit = 30;
  bool _hasMore = true;

  // Cache for details
  final Map<int, Pokemon> _pokemonDetails = {};
  final Map<int, Future<Pokemon?>> _ongoingDetailRequests = {};

  PokemonProvider({PokemonRepository? repository})
      : _repository = repository ?? PokemonRepository();

  List<Pokemon> get pokemonList => _pokemonList;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasMore => _hasMore;

  Future<void> fetchPokemonList({bool refresh = false}) async {
    if (_isLoading) return;
    if (refresh) {
      _offset = 0;
      _pokemonList = [];
      _hasMore = true;
    }
    if (!_hasMore) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newPokemon = await _repository.getPokemonList(
        limit: _limit,
        offset: _offset,
      );

      if (newPokemon.isEmpty) {
        _hasMore = false;
      } else {
        _pokemonList.addAll(newPokemon);
        _offset += _limit;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Pokemon?> getPokemonDetail(int id) async {
    if (_pokemonDetails.containsKey(id)) {
      return _pokemonDetails[id];
    }

    if (_ongoingDetailRequests.containsKey(id)) {
      return _ongoingDetailRequests[id];
    }

    final future = _fetchDetailAndCache(id);
    _ongoingDetailRequests[id] = future;
    return future;
  }

  Pokemon? getPokemonDetailSync(int id) {
    return _pokemonDetails[id];
  }

  Future<Pokemon?> _fetchDetailAndCache(int id) async {
    try {
      final pokemon = await _repository.getPokemonDetail(id);
      _pokemonDetails[id] = pokemon;
      notifyListeners();
      return pokemon;
    } catch (e) {
      return null;
    } finally {
      _ongoingDetailRequests.remove(id);
    }
  }
}
