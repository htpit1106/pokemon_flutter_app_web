import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pokemon/presentation/providers/pokemon_provider.dart';
import 'package:pokemon/core/theme/app_theme.dart';
import 'package:pokemon/data/models/pokemon_model.dart'; // Import Pokemon model

class PokemonDetailScreen extends StatefulWidget {
  final int pokemonId;

  const PokemonDetailScreen({super.key, required this.pokemonId});

  @override
  State<PokemonDetailScreen> createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PokemonProvider>().getPokemonDetail(widget.pokemonId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.pokemonRed,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<PokemonProvider>(
        builder: (context, provider, child) {
          final basicPokemon = provider.pokemonList.firstWhere(
            (p) => p.id == widget.pokemonId,
            orElse: () => Pokemon(
                id: widget.pokemonId, name: 'Loading...', imageUrl: ''),
          );

          final detailedPokemon =
              provider.getPokemonDetailSync(widget.pokemonId);
          final pokemon = detailedPokemon ?? basicPokemon;
          final isLoadingDetails = detailedPokemon == null;

          return Column(
            children: [
              SizedBox(
                height: 250,
                child: Center(
                  child: Hero(
                    tag: 'pokemon_${widget.pokemonId}',
                    child: CachedNetworkImage(
                      imageUrl: pokemon.imageUrl.isNotEmpty
                          ? pokemon.imageUrl
                          : 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${widget.pokemonId}.png',
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  )
                      .animate()
                      .scale(duration: 600.ms, curve: Curves.elasticOut)
                      .rotate(
                          begin: 0,
                          end: 0.05,
                          duration: 2000.ms,
                          curve: Curves.easeInOut,
                          alignment: Alignment.center)
                      .then()
                      .rotate(
                          begin: 0.05,
                          end: -0.05,
                          duration: 2000.ms,
                          curve: Curves.easeInOut,
                          alignment: Alignment.center),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            pokemon.name.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.pokemonBlack,
                                ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (isLoadingDetails)
                          const Center(
                              child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: CircularProgressIndicator(),
                          ))
                        else ...[
                          Center(
                            child: Wrap(
                              spacing: 8,
                              children: pokemon.types
                                  .map((type) => Chip(
                                        label: Text(
                                          type.toUpperCase(),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        backgroundColor: _getTypeColor(type),
                                      ))
                                  .toList(),
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildStatRow(
                              context, 'Height', '${pokemon.height / 10} m'),
                          _buildStatRow(
                              context, 'Weight', '${pokemon.weight / 10} kg'),
                          const SizedBox(height: 24),
                          if (pokemon.stats.isNotEmpty) ...[
                            Text(
                              'Base Stats',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            ...pokemon.stats.entries
                                .map((e) => _buildStatBar(e.key, e.value)),
                          ],
                        ]
                      ],
                    )
                        .animate()
                        .fadeIn(duration: 500.ms, delay: 200.ms)
                        .slideY(begin: 0.2, end: 0, duration: 500.ms),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey)),
        Text(value, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildStatBar(String label, int value) {
    // Max stat is usually around 255
    double percentage = value / 255.0;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12),
            ),
          ),
          Text(
            value.toString().padLeft(3, '0'),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(_getStatColor(value)),
                minHeight: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatColor(int value) {
    if (value < 50) return Colors.red;
    if (value < 100) return Colors.orange;
    return Colors.green;
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'fire': return const Color(0xFFEE8130);
      case 'water': return const Color(0xFF6390F0);
      case 'grass': return const Color(0xFF7AC74C);
      case 'electric': return const Color(0xFFF7D02C);
      case 'ice': return const Color(0xFF96D9D6);
      case 'fighting': return const Color(0xFFC22E28);
      case 'poison': return const Color(0xFFA33EA1);
      case 'ground': return const Color(0xFFE2BF65);
      case 'flying': return const Color(0xFFA98FF3);
      case 'psychic': return const Color(0xFFF95587);
      case 'bug': return const Color(0xFFA6B91A);
      case 'rock': return const Color(0xFFB6A136);
      case 'ghost': return const Color(0xFF735797);
      case 'dragon': return const Color(0xFF6F35FC);
      case 'dark': return const Color(0xFF705746);
      case 'steel': return const Color(0xFFB7B7CE);
      case 'fairy': return const Color(0xFFD685AD);
      default: return Colors.grey;
    }
  }
}
