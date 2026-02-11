import 'package:flutter/material.dart';
import 'package:pokemon/core/theme/app_theme.dart';
import 'package:pokemon/presentation/providers/pokemon_provider.dart';
import 'package:pokemon/presentation/widgets/pokeball_loader.dart'; // Import loader
import 'package:pokemon/presentation/widgets/pokemon_card.dart';
import 'package:provider/provider.dart';

class PokemonListScreen extends StatefulWidget {
  const PokemonListScreen({super.key});

  @override
  State<PokemonListScreen> createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PokemonProvider>().fetchPokemonList();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      context.read<PokemonProvider>().fetchPokemonList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background
      appBar: AppBar(
        title: const Text('POKEMON', style: TextStyle(letterSpacing: 2)),
        backgroundColor: AppTheme.pokemonRed, // Red App Bar
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Search functionality to be implemented
            },
          ),
        ],
      ),
      body: Consumer<PokemonProvider>(
        builder: (context, provider, child) {
          if (provider.pokemonList.isEmpty && provider.isLoading) {
            return const Center(child: PokeballLoader(size: 80));
          }

          if (provider.error != null && provider.pokemonList.isEmpty) {
            return Center(
              child: Text(
                'Error: ${provider.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchPokemonList(refresh: true),
            color: AppTheme.pokemonRed,
            backgroundColor: Colors.white,
            child: Stack(
              children: [
                // Background decoration (optional large pokeball watermark or similar)
                Positioned(
                  top: -50,
                  right: -50,
                  child: Opacity(
                    opacity: 0.05,
                    child: Image.network(
                      'https://upload.wikimedia.org/wikipedia/commons/5/53/Pok%C3%A9_Ball_icon.svg',
                      width: 300,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 0.75, // Slightly taller cards
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    itemCount:
                        provider.pokemonList.length +
                        (provider.hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == provider.pokemonList.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: PokeballLoader(size: 40),
                          ),
                        );
                      }
                      final pokemon = provider.pokemonList[index];
                      return PokemonCard(pokemon: pokemon);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
