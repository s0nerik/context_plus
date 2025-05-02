import 'package:flutter/material.dart';
import 'package:syntax_highlight/syntax_highlight.dart';

final darkCodeThemeFuture = HighlighterTheme.loadFromAssets([
  'packages/syntax_highlight/themes/dark_vs.json',
  'packages/syntax_highlight/themes/dark_plus.json',
], const TextStyle(color: Color(0xFFB9EEFF), fontFamily: 'Fira Code'));

final lightCodeThemeFuture = HighlighterTheme.loadFromAssets([
  'packages/syntax_highlight/themes/light_vs.json',
  'packages/syntax_highlight/themes/light_plus.json',
], const TextStyle(color: Color(0xFF000088), fontFamily: 'Fira Code'));
