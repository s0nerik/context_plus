import 'dart:convert';

import 'package:flutter/services.dart';

class CountriesAPI {
  CountriesAPI._();

  static Future<List<CountryInfo>> searchCountries(String query) async {
    final countries = await _fetchCountries();

    // Imitate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    query = query.trim();
    if (query.isEmpty) return countries;

    final queryLower = query.toLowerCase();
    return countries
        .where((country) => country.name.toLowerCase().contains(queryLower))
        .toList();
  }

  static Future<List<CountryInfo>>? _countries;
  static Future<List<CountryInfo>> _fetchCountries() =>
      _countries ??= () async {
        // Fetched from https://restcountries.com/v3.1/all?fields=name,capital,area,population,flags
        final countriesJsonBuffer = await rootBundle.load(
          'lib/examples/country_search/util/countries.json',
        );
        final countriesJsonBytes = countriesJsonBuffer.buffer.asUint8List();
        final countriesJson = utf8.decode(countriesJsonBytes);
        final List<dynamic> data = json.decode(countriesJson);
        return data.map((json) => CountryInfo.fromJson(json)).toList()
          ..sort((a, b) => a.name.compareTo(b.name));
      }();
}

class CountryInfo {
  CountryInfo({
    required this.name,
    required this.capital,
    required this.area,
    required this.population,
    required this.flag,
  });

  final String name;
  final String? capital;
  final double area;
  final int population;
  final String? flag;

  static const fields = ['name', 'capital', 'area', 'population', 'flags'];

  factory CountryInfo.fromJson(Map<String, dynamic> json) {
    return CountryInfo(
      name: json['name']['common'] as String,
      capital: (json['capital'] as List).firstOrNull,
      area: (json['area'] as num).toDouble(),
      population: json['population'] as int,
      flag: json['flags']?['png'] as String?,
    );
  }
}
