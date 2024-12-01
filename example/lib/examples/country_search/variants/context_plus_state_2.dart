import 'dart:collection';

import 'package:async_listenable/async_listenable.dart';
import 'package:context_plus/context_plus.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';

import '../util/countries_api.dart';

final _state = Ref<_State>();

class _State extends ChangeNotifier {
  _State() {
    searchCountries('');
  }

  var _query = '';
  String get query => _query;

  late final _countriesNotifier = AsyncNotifier<List<CountryInfo>>()
    ..addListener(() => notifyListeners());
  AsyncSnapshot<List<CountryInfo>> get countries => _countriesNotifier.snapshot;

  final _favorites = <String>{};
  Set<String> get favorites => UnmodifiableSetView(_favorites);

  var _showOnlyFavorites = false;
  bool get showOnlyFavorites => _showOnlyFavorites;

  void searchCountries(String query) {
    _query = query;
    _countriesNotifier.setFuture(CountriesAPI.searchCountries(query));
    notifyListeners();
  }

  void toggleFavorite(String countryName) {
    if (_favorites.contains(countryName)) {
      _favorites.remove(countryName);
    } else {
      _favorites.add(countryName);
    }
    notifyListeners();
  }

  void toggleShowOnlyFavorites() {
    _showOnlyFavorites = !_showOnlyFavorites;
    notifyListeners();
  }

  @override
  void dispose() {
    _countriesNotifier.dispose();
    super.dispose();
  }
}

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    _state.bind(context, (context) => _State());
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
      onChanged: _state.of(context).searchCountries,
      decoration: InputDecoration(
        labelText: 'Search',
        hintText: 'Enter country name',
        suffixIcon: IconButton(
          onPressed: _state.of(context).toggleShowOnlyFavorites,
          icon: _state.watchOnly(context, (s) => s.showOnlyFavorites)
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
    final countriesSnapshot = _state.watchOnly(context, (s) => s.countries);
    if (countriesSnapshot.hasError) {
      return Center(
        child: Text('Error fetching countries:\n${countriesSnapshot.error}'),
      );
    }
    if (!countriesSnapshot.hasData) {
      return const Center(child: CircularProgressIndicator());
    }

    var countries = countriesSnapshot.data ?? const [];
    final showOnlyFavorites =
        _state.watchOnly(context, (s) => s.showOnlyFavorites);
    if (showOnlyFavorites) {
      final favorites = _state.watchOnly(context, (s) => s.favorites);
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
        onPressed: () => _state.of(context).toggleFavorite(country.name),
        icon:
            _state.watchOnly(context, (s) => s.favorites.contains(country.name))
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
    final words = _state
        .watchOnly(context, (s) => s.query)
        .split(' ')
        .where((word) => word.isNotEmpty);
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
