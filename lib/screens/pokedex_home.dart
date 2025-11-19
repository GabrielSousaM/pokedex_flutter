import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/pokemon.dart';
import '../widgets/pokemon_card.dart';
import 'pokemon_detail.dart';

class PokedexHome extends StatefulWidget {
  const PokedexHome({Key? key}) : super(key: key);

  @override
  State<PokedexHome> createState() => _PokedexHomeState();
}

class _PokedexHomeState extends State<PokedexHome> {
  List<Pokemon> pokemons = [];
  List<Pokemon> filteredPokemons = [];
  Set<String> selectedTypes = {};
  bool showFavoritesOnly = false;
  bool isLoading = true;
  Set<String> allTypes = {};
  String searchText = '';
  int selectedGeneration = 1;
  final Map<int, String> generationNames = {
    1: 'generation-i',
    2: 'generation-ii',
    3: 'generation-iii',
    4: 'generation-iv',
    5: 'generation-v',
    6: 'generation-vi',
    7: 'generation-vii',
    8: 'generation-viii',
  };

  @override
  void initState() {
    super.initState();
    fetchPokemonsByGeneration(selectedGeneration);
  }

  Future<void> fetchPokemonsByGeneration(int generation) async {
    setState(() {
      isLoading = true;
    });
    final genName = generationNames[generation] ?? 'generation-i';
    final response = await http.get(
      Uri.parse('https://pokeapi.co/api/v2/generation/$genName'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List species = data['pokemon_species'];
      List<Pokemon> tempList = [];
      Set<String> typeSet = {};
      for (var item in species) {
        final pokeName = item['name'];
        final pokeDetails = await http.get(
          Uri.parse('https://pokeapi.co/api/v2/pokemon/$pokeName'),
        );
        if (pokeDetails.statusCode == 200) {
          final pokeData = json.decode(pokeDetails.body);
          List<String> types = (pokeData['types'] as List)
              .map((t) => t['type']['name'] as String)
              .toList();
          typeSet.addAll(types);
          tempList.add(
            Pokemon(
              name: pokeData['name'],
              imageUrl:
                  pokeData['sprites']['other']['official-artwork']['front_default'] ?? '',
              types: types,
              url: 'https://pokeapi.co/api/v2/pokemon/${pokeData['id']}',
            ),
          );
        }
      }
      setState(() {
        pokemons = tempList;
        allTypes = typeSet;
        isLoading = false;
      });
      updateFilters();
    }
  }

  void updateFilters() {
    setState(() {
      filteredPokemons = pokemons.where((p) {
        final matchesType = selectedTypes.isEmpty || p.types.any(selectedTypes.contains);
        final matchesFavorite = !showFavoritesOnly || p.isFavorite;
        final matchesSearch = searchText.isEmpty || p.name.contains(searchText.toLowerCase());
        return matchesType && matchesFavorite && matchesSearch;
      }).toList();
    });
  }

  void toggleFavorite(Pokemon pokemon) {
    setState(() {
      pokemon.isFavorite = !pokemon.isFavorite;
    });
    updateFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokedex'),
        backgroundColor: Colors.red[700],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(showFavoritesOnly ? Icons.star : Icons.star_border),
            onPressed: () {
              showFavoritesOnly = !showFavoritesOnly;
              updateFilters();
            },
            tooltip: 'Favoritos',
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Text(
                        'Geração:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      DropdownButton<int>(
                        value: selectedGeneration,
                        items: generationNames.keys.map((gen) {
                          return DropdownMenuItem<int>(
                            value: gen,
                            child: Text('Geração $gen'),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              selectedGeneration = val;
                            });
                            fetchPokemonsByGeneration(val);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Pesquisar Pokémon',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (val) {
                      searchText = val;
                      updateFilters();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Wrap(
                    spacing: 8,
                    children: allTypes.map((type) {
                      final selected = selectedTypes.contains(type);
                      return FilterChip(
                        label: Text(type),
                        selected: selected,
                        onSelected: (val) {
                          setState(() {
                            if (val) {
                              selectedTypes.add(type);
                            } else {
                              selectedTypes.remove(type);
                            }
                          });
                          updateFilters();
                        },
                        selectedColor: Colors.red[200],
                        checkmarkColor: Colors.red[700],
                      );
                    }).toList(),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: filteredPokemons.length,
                      itemBuilder: (context, index) {
                        final pokemon = filteredPokemons[index];
                        return PokemonCard(
                          pokemon: pokemon,
                          onFavorite: () => toggleFavorite(pokemon),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PokemonDetailPage(pokemon: pokemon),
                              ),
                            );
                          },
                        );
// ...existing code...
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
