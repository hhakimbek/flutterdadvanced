import 'package:flutter/material.dart';

import 'game_data.dart';

class _Tile {
  final String id;
  final String char;
  final bool locked;
  const _Tile(this.id, this.char, {this.locked = false});
}

class WordMergeGame extends StatefulWidget {
  const WordMergeGame({super.key});

  @override
  State<WordMergeGame> createState() => _WordMergeGameState();
}

class _WordMergeGameState extends State<WordMergeGame>
    with SingleTickerProviderStateMixin {
  int _levelIndex = 0;
  int _coins = 1000;
  bool _wrong = false;

  late List<_Tile?> _slots;
  late List<_Tile> _tray;

  late final AnimationController _shakeController;

  GameLevel get _level => levels[_levelIndex];

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _loadLevel();
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _loadLevel() {
    final chars = _level.answer.split('');
    _slots = List<_Tile?>.generate(chars.length, (i) {
      if (_level.prefilled.contains(i)) {
        return _Tile('pre$i', chars[i], locked: true);
      }
      return null;
    });
    _tray = [
      for (int i = 0; i < _level.tray.length; i++)
        _Tile('t$i', _level.tray[i]),
    ];
    _wrong = false;
  }

  void _placeInSlot(int slotIndex, _Tile tile) {
    if (_slots[slotIndex] != null) return;
    setState(() {
      _slots[slotIndex] = tile;
      _tray.removeWhere((t) => t.id == tile.id);
      _wrong = false;
    });
    _checkComplete();
  }

  void _removeFromSlot(int slotIndex) {
    final tile = _slots[slotIndex];
    if (tile == null || tile.locked) return;
    setState(() {
      _tray.add(tile);
      _slots[slotIndex] = null;
      _wrong = false;
    });
  }

  void _checkComplete() {
    if (_slots.any((t) => t == null)) return;
    final word = _slots.map((t) => t!.char).join();
    if (word == _level.answer) {
      _onSolved();
    } else {
      setState(() => _wrong = true);
      _shakeController.forward(from: 0);
    }
  }

  void _onSolved() {
    setState(() => _coins += 200);
    Future.delayed(const Duration(milliseconds: 250), _showWinSheet);
  }

  void _showWinSheet() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFEAF7EF),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded,
                  color: Color(0xFF33B79B), size: 44),
            ),
            const SizedBox(height: 18),
            Text(
              _level.answer,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                letterSpacing: 3,
                color: GameColors.textDark,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              '+200 coins',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: GameColors.coinGold,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _nextLevel();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: GameColors.navy,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  _levelIndex == levels.length - 1 ? 'Play again' : 'Next level',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _nextLevel() {
    setState(() {
      _levelIndex = (_levelIndex + 1) % levels.length;
      _loadLevel();
    });
  }

  void _openMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text('Levels',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700)),
            ),
            SizedBox(
              height: 320,
              child: GridView.count(
                crossAxisCount: 4,
                padding: const EdgeInsets.all(16),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: [
                  for (int i = 0; i < levels.length; i++)
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        setState(() {
                          _levelIndex = i;
                          _loadLevel();
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: i == _levelIndex
                              ? GameColors.navy
                              : GameColors.coinPill,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          '${levels[i].level}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: i == _levelIndex
                                ? Colors.white
                                : GameColors.textDark,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GameColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _topBar(),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _cardsRow(),
                    const SizedBox(height: 24),
                    _cluePanel(),
                    const SizedBox(height: 28),
                    _trayArea(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'LEVEL',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                  color: GameColors.textDark,
                ),
              ),
              Text(
                '${_level.level}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: GameColors.textDark,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: GameColors.coinPill,
              borderRadius: BorderRadius.circular(99),
            ),
            child: Row(
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    color: GameColors.coinGold,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.attach_money_rounded,
                      size: 16, color: Colors.white),
                ),
                const SizedBox(width: 8),
                Text(
                  '$_coins',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: GameColors.textDark,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: _openMenu,
            child: const Icon(Icons.menu_rounded,
                size: 28, color: GameColors.textDark),
          ),
        ],
      ),
    );
  }

  Widget _cardsRow() {
    return Row(
      children: [
        Expanded(child: _imageCard(_level.emoji1, _level.color1)),
        const SizedBox(width: 14),
        Expanded(child: _imageCard(_level.emoji2, _level.color2)),
      ],
    );
  }

  Widget _imageCard(String emoji, Color footerColor) {
    return AspectRatio(
      aspectRatio: 0.72,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.search_rounded,
                      size: 16, color: Color(0xFF9AA3AB)),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 76)),
              ),
            ),
            Container(
              height: 34,
              decoration: BoxDecoration(
                color: footerColor,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(14),
                ),
              ),
              alignment: Alignment.center,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    3,
                    (i) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: footerColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cluePanel() {
    return AnimatedBuilder(
      animation: _shakeController,
      builder: (context, child) {
        final dx = _wrong
            ? 8 *
                (1 - _shakeController.value) *
                ((_shakeController.value * 6).floor().isEven ? 1 : -1)
            : 0.0;
        return Transform.translate(offset: Offset(dx, 0), child: child);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        decoration: BoxDecoration(
          color: GameColors.navy,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(
              _level.clue,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                for (int i = 0; i < _slots.length; i++) _slotBox(i),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _slotBox(int index) {
    final tile = _slots[index];
    final color = tileColors[index % tileColors.length];
    return DragTarget<_Tile>(
      onWillAcceptWithDetails: (_) => _slots[index] == null,
      onAcceptWithDetails: (details) => _placeInSlot(index, details.data),
      builder: (context, candidate, rejected) {
        final highlighted = candidate.isNotEmpty;
        if (tile == null) {
          return Container(
            width: 40,
            height: 44,
            decoration: BoxDecoration(
              color: highlighted
                  ? color.withValues(alpha: 0.55)
                  : color.withValues(alpha: 0.28),
              borderRadius: BorderRadius.circular(9),
              border: Border.all(
                color: highlighted ? Colors.white : Colors.transparent,
                width: 2,
              ),
            ),
          );
        }
        return GestureDetector(
          onTap: () => _removeFromSlot(index),
          child: _letterTile(
            tile.char,
            color: _wrong ? const Color(0xFFD65454) : color,
            textColor: Colors.white,
            width: 40,
            height: 44,
          ),
        );
      },
    );
  }

  Widget _trayArea() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      runSpacing: 12,
      children: [
        for (final tile in _tray)
          Draggable<_Tile>(
            data: tile,
            feedback: _keyTile(tile.char, dragging: true),
            childWhenDragging: Opacity(
              opacity: 0.3,
              child: _keyTile(tile.char),
            ),
            child: _keyTile(tile.char),
          ),
      ],
    );
  }

  Widget _keyTile(String char, {bool dragging = false}) {
    return Container(
      width: 44,
      height: 50,
      decoration: BoxDecoration(
        color: GameColors.key,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: dragging ? 0.35 : 0.25),
            blurRadius: dragging ? 12 : 4,
            offset: Offset(0, dragging ? 6 : 3),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        char,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _letterTile(
    String char, {
    required Color color,
    required Color textColor,
    required double width,
    required double height,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(9),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        char,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: textColor,
        ),
      ),
    );
  }
}
