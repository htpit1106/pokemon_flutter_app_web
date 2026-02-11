import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'presentation/providers/pokemon_provider.dart';
import 'presentation/screens/home/pokemon_list_screen.dart';
import 'presentation/screens/detail/pokemon_detail_screen.dart';

void main() {
  runApp(const PokemonApp());
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const PokemonListScreen(),
      routes: [
        GoRoute(
          path: 'pokemon/:id',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return PokemonDetailScreen(pokemonId: id);
          },
        ),
      ],
    ),
  ],
);

class PokemonApp extends StatelessWidget {
  const PokemonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PokemonProvider()),
      ],
      child: MaterialApp.router(
        title: 'Pokemon Flutter Web',
        theme: AppTheme.lightTheme,
        routerConfig: _router,
      ),
    );
  }
}
