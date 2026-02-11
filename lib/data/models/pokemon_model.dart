class Pokemon {
  final int id;
  final String name;
  final String imageUrl;
  final List<String> types;
  final int height;
  final int weight;
  final Map<String, int> stats;

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.types = const [],
    this.height = 0,
    this.weight = 0,
    this.stats = const {},
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    // Check if it's a detail response or a list item
    if (json.containsKey('stats')) {
      return Pokemon.fromDetailJson(json);
    } else {
      return Pokemon.fromListJson(json);
    }
  }

  factory Pokemon.fromListJson(Map<String, dynamic> json) {
    final url = json['url'] as String;
    final id = int.parse(url.split('/')[6]);
    return Pokemon(
      id: id,
      name: json['name'],
      imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png',
    );
  }

  factory Pokemon.fromDetailJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'],
      name: json['name'],
      imageUrl: json['sprites']['other']['official-artwork']['front_default'] ?? '',
      height: json['height'],
      weight: json['weight'],
      types: (json['types'] as List)
          .map((t) => t['type']['name'] as String)
          .toList(),
      stats: Map.fromEntries(
        (json['stats'] as List).map(
          (s) => MapEntry(
            s['stat']['name'] as String,
            s['base_stat'] as int,
          ),
        ),
      ),
    );
  }
}
