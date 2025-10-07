import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/pokemon.dart';
import '../../services/pokemon_service.dart';
import '../../widgets/base_view.dart';

class PokemonListView extends StatefulWidget {
  const PokemonListView({super.key});

  @override
  State<PokemonListView> createState() => _PokemonListViewState();
}

class _PokemonListViewState extends State<PokemonListView> {
  //* Se crea una instancia de la clase PokemonService
  final PokemonService _pokemonService = PokemonService();
  //* Se declara una variable de tipo Future que contendrá la lista de Pokémon
  late Future<List<Pokemon>> _futurePokemons;

  @override
  void initState() {
    super.initState();
    //! Se llama al método getPokemons de la clase PokemonService
    _futurePokemons = _pokemonService.getPokemons();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Pokémon - ListView',
      //! Se crea un FutureBuilder que se encargará de construir la lista de Pokémon
      //! futurebuilder se utiliza para construir widgets basados en un Future
      body: FutureBuilder<List<Pokemon>>(
        future: _futurePokemons,
        builder: (context, snapshot) {
          //snapshot contiene la respuesta del Future
          if (snapshot.hasData) {
            //* Se obtiene la lista de Pokémon
            final pokemons = snapshot.data!;
            //listview.builder se utiliza para construir una lista de elementos de manera eficiente
            return ListView.builder(
              itemCount: pokemons.length,
              itemBuilder: (context, index) {
                final pokemon = pokemons[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  //* gestureDetector se utiliza para detectar gestos del usuario
                  //* en este caso se utiliza para navegar a la vista de detalle del Pokémon
                  child: GestureDetector(
                    onTap: () {
                      context.push('/pokemon/${pokemon.name}');
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Image.network(
                                pokemon.image,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    pokemon.name.toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
