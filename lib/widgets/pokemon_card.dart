import 'package:flutter/material.dart';
import '../models/pokemon.dart';

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;
  final VoidCallback? onFavorite;
  final VoidCallback? onTap;
  const PokemonCard({Key? key, required this.pokemon, this.onFavorite, this.onTap}) : super(key: key);

  Color getTypeColor(String type) {
    switch (type) {
      case 'fire':
        return Colors.redAccent;
      case 'water':
        return Colors.blueAccent;
      case 'grass':
        return Colors.green;
      case 'electric':
        return Colors.yellow[700]!;
      case 'psychic':
        return Colors.purpleAccent;
      case 'ice':
        return Colors.cyanAccent;
      case 'ground':
        return Colors.brown;
      case 'rock':
        return Colors.grey;
      case 'fairy':
        return Colors.pinkAccent;
      case 'poison':
        return Colors.deepPurple;
      case 'bug':
        return Colors.lightGreen;
      case 'flying':
        return Colors.indigoAccent;
      case 'fighting':
        return Colors.orangeAccent;
      case 'dragon':
        return Colors.indigo;
      case 'ghost':
        return Colors.deepPurpleAccent;
      default:
        return Colors.grey[300]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              colors: [Colors.white, Colors.red[50]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              pokemon.imageUrl.isNotEmpty
                  ? Image.network(
                      pokemon.imageUrl,
                      height: 90,
                      fit: BoxFit.contain,
                    )
                  : const SizedBox(height: 90),
              const SizedBox(height: 12),
              Text(
                pokemon.name[0].toUpperCase() + pokemon.name.substring(1),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                children: pokemon.types
                    .map(
                      (type) => Chip(
                        label: Text(
                          type,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        backgroundColor: getTypeColor(type),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 0,
                        ),
                      ),
                    )
                    .toList(),
              ),
              IconButton(
                icon: Icon(
                  pokemon.isFavorite ? Icons.star : Icons.star_border,
                  color: Colors.red[700],
                ),
                onPressed: onFavorite,
                tooltip: 'Favoritar',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
