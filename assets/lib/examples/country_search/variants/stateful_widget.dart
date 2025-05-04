import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';

import '../util/countries_api.dart';

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  String _query = '';
  late Future<List<CountryInfo>> _countriesFuture;
  bool _showOnlyFavorites = false;
  final _favorites = <String>{};

  @override
  void initState() {
    super.initState();
    _countriesFuture = CountriesAPI.searchCountries('');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SearchField(
          onQueryChanged:
              (query) => setState(() {
                _query = query;
                _countriesFuture = CountriesAPI.searchCountries(query);
              }),
          onToggleShowOnlyFavorites:
              () => setState(() {
                _showOnlyFavorites = !_showOnlyFavorites;
              }),
          showOnlyFavorites: _showOnlyFavorites,
        ),
        Expanded(
          child: _CountriesList(
            query: _query,
            countriesFuture: _countriesFuture,
            showOnlyFavorites: _showOnlyFavorites,
            favorites: _favorites,
            onToggleFavorite:
                (countryName) => setState(() {
                  if (_favorites.contains(countryName)) {
                    _favorites.remove(countryName);
                  } else {
                    _favorites.add(countryName);
                  }
                }),
          ),
        ),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.onQueryChanged,
    required this.showOnlyFavorites,
    required this.onToggleShowOnlyFavorites,
  });

  final ValueChanged<String>? onQueryChanged;
  final bool showOnlyFavorites;
  final VoidCallback onToggleShowOnlyFavorites;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onQueryChanged,
      decoration: InputDecoration(
        labelText: 'Search',
        hintText: 'Enter country name',
        suffixIcon: IconButton(
          onPressed: onToggleShowOnlyFavorites,
          icon:
              showOnlyFavorites
                  ? const Icon(Icons.favorite)
                  : const Icon(Icons.favorite_border),
        ),
      ),
    );
  }
}

class _CountriesList extends StatelessWidget {
  const _CountriesList({
    required this.countriesFuture,
    required this.showOnlyFavorites,
    required this.favorites,
    required this.onToggleFavorite,
    required this.query,
  });

  final Future<List<CountryInfo>> countriesFuture;
  final bool showOnlyFavorites;
  final Set<String> favorites;
  final ValueChanged<String> onToggleFavorite;
  final String query;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: countriesFuture,
      builder: (context, countriesSnapshot) {
        if (countriesSnapshot.hasError) {
          return Center(
            child: Text(
              'Error fetching countries:\n${countriesSnapshot.error}',
            ),
          );
        }
        if (!countriesSnapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        var countries = countriesSnapshot.data ?? const [];
        if (showOnlyFavorites) {
          countries =
              countries
                  .where((country) => favorites.contains(country.name))
                  .toList();
        }

        return ListView.builder(
          itemCount: countries.length,
          itemBuilder:
              (context, index) => _CountryTile(
                key: ValueKey(countries[index].name),
                country: countries[index],
                isFavorite: favorites.contains(countries[index].name),
                onToggleFavorite: () => onToggleFavorite(countries[index].name),
                query: query,
              ),
        );
      },
    );
  }
}

class _CountryTile extends StatelessWidget {
  const _CountryTile({
    super.key,
    required this.country,
    required this.onToggleFavorite,
    required this.isFavorite,
    required this.query,
  });

  final CountryInfo country;
  final VoidCallback onToggleFavorite;
  final bool isFavorite;
  final String query;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: _CountryTileTitle(country: country, query: query),
      subtitle: country.capital != null ? Text(country.capital!) : null,
      leading:
          country.flag != null
              ? Image.network(country.flag!, width: 48, height: 48)
              : null,
      trailing: IconButton(
        onPressed: onToggleFavorite,
        icon:
            isFavorite
                ? const Icon(Icons.favorite)
                : const Icon(Icons.favorite_border),
      ),
    );
  }
}

class _CountryTileTitle extends StatelessWidget {
  const _CountryTileTitle({required this.country, required this.query});

  final CountryInfo country;
  final String query;

  @override
  Widget build(BuildContext context) {
    final words = query.split(' ').where((word) => word.isNotEmpty);
    return TextHighlight(
      text: country.name,
      words: {
        for (final word in words)
          word: HighlightedWord(
            textStyle: TextStyle(backgroundColor: Colors.yellow[900]),
          ),
      },
    );
  }
}
