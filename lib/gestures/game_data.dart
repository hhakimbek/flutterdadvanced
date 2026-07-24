import 'package:flutter/material.dart';

class GameColors {
  static const navy = Color(0xFF123249);
  static const navyLight = Color(0xFF1C4460);
  static const background = Color(0xFFFFFFFF);
  static const coinPill = Color(0xFFEDEDED);
  static const coinGold = Color(0xFFF4B32B);
  static const key = Color(0xFF15374F);
  static const textDark = Color(0xFF1B2B36);
}

const List<Color> tileColors = [
  Color(0xFFEF6F6C),
  Color(0xFF5AA9E6),
  Color(0xFFF4C542),
  Color(0xFF7E5BC2),
  Color(0xFF33B79B),
  Color(0xFFF0894E),
  Color(0xFF5C6BC0),
];

class GameLevel {
  final int level;
  final String emoji1;
  final Color color1;
  final String emoji2;
  final Color color2;
  final String clue;
  final String answer;
  final List<int> prefilled;
  final List<String> tray;

  const GameLevel({
    required this.level,
    required this.emoji1,
    required this.color1,
    required this.emoji2,
    required this.color2,
    required this.clue,
    required this.answer,
    required this.prefilled,
    required this.tray,
  });
}

const List<GameLevel> levels = [
  GameLevel(
    level: 1,
    emoji1: '🏹',
    color1: Color(0xFFEF6F6C),
    emoji2: '🦉',
    color2: Color(0xFF5AA9E6),
    clue: 'a vessel or a container',
    answer: 'BOWL',
    prefilled: [0, 1, 2],
    tray: ['O', 'L', 'W', 'B'],
  ),
  GameLevel(
    level: 2,
    emoji1: '🐝',
    color1: Color(0xFFF4C542),
    emoji2: '👂',
    color2: Color(0xFF7E5BC2),
    clue: 'a large & heavy animal',
    answer: 'BEAR',
    prefilled: [0, 1],
    tray: ['R', 'A', 'B', 'E'],
  ),
  GameLevel(
    level: 3,
    emoji1: '🍳',
    color1: Color(0xFF33B79B),
    emoji2: '🐜',
    color2: Color(0xFFEF6F6C),
    clue: 'short & quick breaths',
    answer: 'PANT',
    prefilled: [],
    tray: ['N', 'P', 'A', 'T'],
  ),
  GameLevel(
    level: 4,
    emoji1: '☕',
    color1: Color(0xFFEF6F6C),
    emoji2: '👂',
    color2: Color(0xFFF4C542),
    clue: 'a drop from a person\'s eye',
    answer: 'TEAR',
    prefilled: [0, 1, 2],
    tray: ['T', 'R', 'A', 'E'],
  ),
  GameLevel(
    level: 6,
    emoji1: '🐝',
    color1: Color(0xFF7DB93C),
    emoji2: '🔫',
    color2: Color(0xFFF0894E),
    clue: 'start',
    answer: 'BEGUN',
    prefilled: [],
    tray: ['E', 'O', 'U', 'N', 'B', 'G'],
  ),
  GameLevel(
    level: 13,
    emoji1: '🧠',
    color1: Color(0xFFF4C542),
    emoji2: '🎀',
    color2: Color(0xFFEF6F6C),
    clue: 'a seven color arch',
    answer: 'RAINBOW',
    prefilled: [0, 1, 2, 3],
    tray: ['O', 'E', 'B', 'R', 'A', 'W', 'I', 'N', 'P'],
  ),
  GameLevel(
    level: 14,
    emoji1: '🍋',
    color1: Color(0xFF5AA9E6),
    emoji2: '🔑',
    color2: Color(0xFF7DB93C),
    clue: 'animal that lives on trees',
    answer: 'MONKEY',
    prefilled: [],
    tray: ['M', 'O', 'L', 'E', 'K', 'S', 'N', 'Y'],
  ),
  GameLevel(
    level: 85,
    emoji1: '📕',
    color1: Color(0xFF7DB93C),
    emoji2: '🤴',
    color2: Color(0xFFF0894E),
    clue: 'reserving ticket',
    answer: 'BOOKING',
    prefilled: [0, 1, 2, 3],
    tray: ['K', 'N', 'V', 'G', 'Y', 'H', 'B', 'I', 'S', 'O', 'Z', 'M', 'U'],
  ),
];
