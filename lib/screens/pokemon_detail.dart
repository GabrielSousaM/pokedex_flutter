import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/pokemon.dart';
// import '../widgets/pokemon_card.dart';

class PokemonDetailPage extends StatefulWidget {
  final Pokemon pokemon;
  const PokemonDetailPage({Key? key, required this.pokemon}) : super(key: key);

  @override
  State<PokemonDetailPage> createState() => _PokemonDetailPageState();
}

class _PokemonDetailPageState extends State<PokemonDetailPage> {
  String description = '';
  bool isLoading = true;
  int? id;
  int? height;
  int? weight;
  List<String> abilities = [];
  List<String> weaknesses = [];

  @override
  void initState() {
    super.initState();
    fetchDescription();
  }

  Future<void> fetchDescription() async {
    final response = await http.get(Uri.parse(widget.pokemon.url));
    if (response.statusCode == 200) {
      final pokeData = json.decode(response.body);
      id = pokeData['id'];
      height = pokeData['height'];
      weight = pokeData['weight'];
      abilities = (pokeData['abilities'] as List)
          .map((a) => a['ability']['name'] as String)
          .toList();
      weaknesses = (pokeData['types'] as List)
          .map((t) => t['type']['name'] as String)
          .toList();
      final speciesUrl = pokeData['species']['url'];
      final speciesResponse = await http.get(Uri.parse(speciesUrl));
      if (speciesResponse.statusCode == 200) {
        final speciesData = json.decode(speciesResponse.body);
        final flavor = (speciesData['flavor_text_entries'] as List?)?.firstWhere(
          (entry) => entry['language']['name'] == 'en',
          orElse: () => null,
        );
        setState(() {
          description = flavor != null ? flavor['flavor_text'] : '';
          isLoading = false;
        });
      } else {
        setState(() { isLoading = false; });
      }
    } else {
      setState(() { isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pokemon.name[0].toUpperCase() + widget.pokemon.name.substring(1)),
        backgroundColor: Colors.red[700],
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 12,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Center(
                              child: Image.network(
                                widget.pokemon.imageUrl,
                                height: 180,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '#${id ?? '--'}  ${widget.pokemon.name[0].toUpperCase() + widget.pokemon.name.substring(1)}',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: widget.pokemon.types
                                  .map((type) => Chip(
                                        label: Text(type),
                                        backgroundColor: Colors.red[200],
                                      ))
                                  .toList(),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Text('Altura', style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text(height != null ? '${height! / 10} m' : '--'),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text('Peso', style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text(weight != null ? '${weight! / 10} kg' : '--'),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            if (abilities.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Habilidades', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                                  Wrap(
                                    alignment: WrapAlignment.center,
                                    spacing: 8,
                                    children: abilities.map((a) => Chip(label: Text(a))).toList(),
                                  ),
                                ],
                              ),
                            const SizedBox(height: 12),
                            if (weaknesses.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Fraquezas', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                                  Wrap(
                                    alignment: WrapAlignment.center,
                                    spacing: 8,
                                    children: weaknesses.map((w) => Chip(label: Text(w))).toList(),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Descrição',
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              description.isNotEmpty ? description : 'Descrição não disponível.',
                              style: const TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ),
            );
  }
}
