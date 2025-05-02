import 'package:async_listenable/async_listenable.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';

import '../util/countries_api.dart';

class _State extends InheritedWidget {
  const _State({
    required this.query,
    required this.countries,
    required this.showOnlyFavorites,
    required this.favorites,
    required super.child,
  });

  final ValueNotifier<String> query;
  final AsyncNotifier<List<CountryInfo>> countries;
  final ValueNotifier<bool> showOnlyFavorites;
  final ValueNotifier<Set<String>> favorites;

  static _State of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_State>()!;
  }

  @override
  bool updateShouldNotify(_State oldWidget) {
    return query != oldWidget.query ||
        countries != oldWidget.countries ||
        showOnlyFavorites != oldWidget.showOnlyFavorites ||
        favorites != oldWidget.favorites;
  }
}

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  final _query = ValueNotifier('');
  late final _countries =
      AsyncNotifier<List<CountryInfo>>()
        ..setFuture(CountriesAPI.searchCountries(''));
  final _showOnlyFavorites = ValueNotifier(false);
  final _favorites = ValueNotifier(const <String>{});

  @override
  Widget build(BuildContext context) {
    return _State(
      query: _query,
      countries: _countries,
      showOnlyFavorites: _showOnlyFavorites,
      favorites: _favorites,
      child: const Column(
        children: [_SearchField(), Expanded(child: _CountriesList())],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField();

  @override
  Widget build(BuildContext context) {
    final state = _State.of(context);
    return ValueListenableBuilder(
      valueListenable: state.showOnlyFavorites,
      builder:
          (context, showOnlyFavorites, _) => TextField(
            onChanged: (query) {
              state.query.value = query;
              state.countries.setFuture(CountriesAPI.searchCountries(query));
            },
            decoration: InputDecoration(
              labelText: 'Search',
              hintText: 'Enter country name',
              suffixIcon: IconButton(
                onPressed:
                    () =>
                        state.showOnlyFavorites.value =
                            !state.showOnlyFavorites.value,
                icon:
                    showOnlyFavorites
                        ? const Icon(Icons.favorite)
                        : const Icon(Icons.favorite_border),
              ),
            ),
          ),
    );
  }
}

class _CountriesList extends StatelessWidget {
  const _CountriesList();

  @override
  Widget build(BuildContext context) {
    final state = _State.of(context);
    return AsyncListenableBuilder(
      asyncListenable: state.countries,
      builder:
          (context, countriesSnapshot) => ValueListenableBuilder(
            valueListenable: state.showOnlyFavorites,
            builder:
                (context, showOnlyFavorites, _) => ValueListenableBuilder(
                  valueListenable: state.favorites,
                  builder: (context, favorites, _) {
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
                              .where(
                                (country) => favorites.contains(country.name),
                              )
                              .toList();
                    }

                    return ListView.builder(
                      itemCount: countries.length,
                      itemBuilder:
                          (context, index) => _CountryTile(
                            key: ValueKey(countries[index].name),
                            country: countries[index],
                          ),
                    );
                  },
                ),
          ),
    );
  }
}

class _CountryTile extends StatelessWidget {
  const _CountryTile({super.key, required this.country});

  final CountryInfo country;

  @override
  Widget build(BuildContext context) {
    final state = _State.of(context);
    return ValueListenableBuilder(
      valueListenable: state.favorites,
      builder: (context, favorites, _) {
        return ListTile(
          title: _CountryTileTitle(country: country),
          subtitle: country.capital != null ? Text(country.capital!) : null,
          leading:
              country.flag != null
                  ? Image.network(country.flag!, width: 48, height: 48)
                  : null,
          trailing: IconButton(
            onPressed: () {
              final favorites = state.favorites.value.toSet();
              if (favorites.contains(country.name)) {
                favorites.remove(country.name);
              } else {
                favorites.add(country.name);
              }
              state.favorites.value = favorites;
            },
            icon:
                favorites.contains(country.name)
                    ? const Icon(Icons.favorite)
                    : const Icon(Icons.favorite_border),
          ),
        );
      },
    );
  }
}

class _CountryTileTitle extends StatelessWidget {
  const _CountryTileTitle({required this.country});

  final CountryInfo country;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _State.of(context).query,
      builder: (context, query, _) {
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
      },
    );
  }
}
