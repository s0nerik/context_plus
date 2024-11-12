import 'package:async_listenable/async_listenable.dart';
import 'package:context_plus/context_plus.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';

import '../util/countries_api.dart';

final _query = Ref<ValueNotifier<String>>();
final _countries = Ref<AsyncNotifier<List<CountryInfo>>>();
final _showOnlyFavorites = Ref<ValueNotifier<bool>>();
final _favorites = Ref<ValueNotifier<Set<String>>>();

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    _query.bind(context, () => ValueNotifier(''));
    _countries.bind(
      context,
      () => AsyncNotifier()..setFuture(CountriesAPI.searchCountries('')),
    );
    _showOnlyFavorites.bind(context, () => ValueNotifier(false));
    _favorites.bind(context, () => ValueNotifier(const {}));
    return const Column(
      children: [
        _SearchField(),
        Expanded(
          child: _CountriesList(),
        ),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField();

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (query) {
        _query.of(context).value = query;
        _countries.of(context).setFuture(CountriesAPI.searchCountries(query));
      },
      decoration: InputDecoration(
        labelText: 'Search',
        hintText: 'Enter country name',
        suffixIcon: IconButton(
          onPressed: () => _showOnlyFavorites.of(context).value =
              !_showOnlyFavorites.of(context).value,
          icon: _showOnlyFavorites.watchValue(context)
              ? const Icon(Icons.favorite)
              : const Icon(Icons.favorite_border),
        ),
      ),
    );
  }
}

class _CountriesList extends StatelessWidget {
  const _CountriesList();

  @override
  Widget build(BuildContext context) {
    final countriesSnapshot = _countries.watchValue(context);
    if (countriesSnapshot.hasError) {
      return Center(
        child: Text('Error fetching countries:\n${countriesSnapshot.error}'),
      );
    }
    if (!countriesSnapshot.hasData) {
      return const Center(child: CircularProgressIndicator());
    }

    var countries = countriesSnapshot.data ?? const [];
    final showOnlyFavorites = _showOnlyFavorites.watchValue(context);
    if (showOnlyFavorites) {
      final favorites = _favorites.watchValue(context);
      countries = countries
          .where((country) => favorites.contains(country.name))
          .toList();
    }

    return ListView.builder(
      itemCount: countries.length,
      itemBuilder: (context, index) => _CountryTile(
        key: ValueKey(countries[index].name),
        country: countries[index],
      ),
    );
  }
}

class _CountryTile extends StatelessWidget {
  const _CountryTile({
    super.key,
    required this.country,
  });

  final CountryInfo country;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: _CountryTileTitle(country: country),
      subtitle: country.capital != null ? Text(country.capital!) : null,
      leading: country.flag != null
          ? Image.network(country.flag!, width: 48, height: 48)
          : null,
      trailing: IconButton(
        onPressed: () {
          final favorites = _favorites.of(context).value.toSet();
          if (favorites.contains(country.name)) {
            favorites.remove(country.name);
          } else {
            favorites.add(country.name);
          }
          _favorites.of(context).value = favorites;
        },
        icon: _favorites.watchValue(context).contains(country.name)
            ? const Icon(Icons.favorite)
            : const Icon(Icons.favorite_border),
      ),
    );
  }
}

class _CountryTileTitle extends StatelessWidget {
  const _CountryTileTitle({
    required this.country,
  });

  final CountryInfo country;

  @override
  Widget build(BuildContext context) {
    final words =
        _query.watchValue(context).split(' ').where((word) => word.isNotEmpty);
    return TextHighlight(
      text: country.name,
      words: {
        for (final word in words)
          word: HighlightedWord(
            textStyle: TextStyle(
              backgroundColor: Colors.yellow[900],
            ),
          ),
      },
    );
  }
}
