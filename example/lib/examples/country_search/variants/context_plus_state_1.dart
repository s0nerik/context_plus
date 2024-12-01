import 'package:async_listenable/async_listenable.dart';
import 'package:context_plus/context_plus.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';

import '../util/countries_api.dart';

final _state = Ref<_State>();

class _State {
  final query = ValueNotifier('');
  final countries = AsyncNotifier<List<CountryInfo>>()
    ..setFuture(CountriesAPI.searchCountries(''));
  final showOnlyFavorites = ValueNotifier(false);
  final favorites = ValueNotifier(const <String>{});

  void dispose() {
    query.dispose();
    countries.dispose();
    showOnlyFavorites.dispose();
    favorites.dispose();
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
    final state = _state.of(context);
    return TextField(
      onChanged: (query) {
        state.query.value = query;
        state.countries.setFuture(CountriesAPI.searchCountries(query));
      },
      decoration: InputDecoration(
        labelText: 'Search',
        hintText: 'Enter country name',
        suffixIcon: IconButton(
          onPressed: () =>
              state.showOnlyFavorites.value = !state.showOnlyFavorites.value,
          icon: state.showOnlyFavorites.watch(context)
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
    final state = _state.of(context);

    final countriesSnapshot = state.countries.watch(context);
    if (countriesSnapshot.hasError) {
      return Center(
        child: Text('Error fetching countries:\n${countriesSnapshot.error}'),
      );
    }
    if (!countriesSnapshot.hasData) {
      return const Center(child: CircularProgressIndicator());
    }

    var countries = countriesSnapshot.data ?? const [];
    final showOnlyFavorites = state.showOnlyFavorites.watch(context);
    if (showOnlyFavorites) {
      final favorites = state.favorites.watch(context);
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
    final state = _state.of(context);
    return ListTile(
      title: _CountryTileTitle(country: country),
      subtitle: country.capital != null ? Text(country.capital!) : null,
      leading: country.flag != null
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
        icon: state.favorites.watch(context).contains(country.name)
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
    final state = _state.of(context);
    final words =
        state.query.watch(context).split(' ').where((word) => word.isNotEmpty);
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
