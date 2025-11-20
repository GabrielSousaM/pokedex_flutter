# Pokedex Flutter

Uma Pokedex completa feita em Flutter, conectada à PokeAPI, com interface moderna e responsiva para dispositivos móveis e desktop.

## Funcionalidades

- **Tela de Login**: Acesso inicial estilizado para o usuário.
- **Listagem de Pokémons**: Exibe os Pokémons em um grid, mostrando nome, imagem e tipos.
- **Barra de Pesquisa**: Permite buscar Pokémons pelo nome.
- **Filtros por Tipo**: Filtre Pokémons por seus tipos (água, fogo, etc).
- **Favoritos**: Marque Pokémons favoritos e visualize apenas eles.
- **Filtro por Geração**: Carregue Pokémons de diferentes gerações (Gen 1 a Gen 8) usando dropdown.
- **Tela de Detalhes**: Ao clicar em um Pokémon, veja informações detalhadas: imagem grande, número, nome, altura, peso, tipos, habilidades, fraquezas e descrição.
- **Layout Responsivo**: Interface adaptada para mobile

## Estrutura do Projeto

- `lib/main.dart`: Tela de login e navegação principal.
- `lib/screens/pokedex_home.dart`: Grid principal, pesquisa, filtros, favoritos, geração.
- `lib/screens/pokemon_detail.dart`: Tela de detalhes do Pokémon.
- `lib/models/pokemon.dart`: Modelo de dados do Pokémon.
- `lib/widgets/pokemon_card.dart`: Card visual dos Pokémons.

## Tecnologias Utilizadas

- Flutter
- Dart
- PokeAPI (https://pokeapi.co)
- HTTP package

## Como Executar

1. Instale o Flutter SDK: https://docs.flutter.dev/get-started/install
2. Clone este repositório
3. Execute `flutter pub get` para instalar dependências
4. Execute `flutter run` para iniciar o app

## Testes

O projeto inclui testes básicos em `test/widget_test.dart`.

## Créditos

- Ícones e dados: [PokeAPI](https://pokeapi.co)
- Desenvolvido por GabrielSousaM e tiagomarcoss

---

Este projeto é apenas para fins educacionais e demonstração do Flutter.
