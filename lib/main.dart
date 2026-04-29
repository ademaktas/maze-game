import 'package:flutter/material.dart';
import 'game.dart';
import 'level.dart';

void main() {
  runApp(const ArrowMazeApp());
}

class ArrowMazeApp extends StatelessWidget {
  const ArrowMazeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arrow Maze',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xfff8f8ff),
        useMaterial3: true,
      ),
      home: const GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int level = 1;
  int hearts = 3;
  late GameState game;

  @override
  void initState() {
    super.initState();
    game = LevelGen.generate(level);
  }

  IconData iconFor(Dir d) {
    switch (d) {
      case Dir.up:
        return Icons.arrow_upward;
      case Dir.down:
        return Icons.arrow_downward;
      case Dir.left:
        return Icons.arrow_back;
      case Dir.right:
        return Icons.arrow_forward;
    }
  }

  void restartLevel() {
    setState(() {
      game = LevelGen.generate(level);
      hearts = 3;
    });
  }

  void nextLevel() {
    setState(() {
      level++;
      game = LevelGen.generate(level);
      hearts = 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = game.size;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Text(
              'Arrows',
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.w900,
                color: Colors.indigo.shade900,
              ),
            ),
            Text(
              'Seviye $level',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Colors.indigo.shade400,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '❤️' * hearts,
              style: const TextStyle(fontSize: 28),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: size * size,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: size,
                      ),
                      itemBuilder: (context, index) {
                        final x = index ~/ size;
                        final y = index % size;
                        final cell = game.grid[x][y];

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              final moved = game.tap(x, y);

                              if (!moved && hearts > 0) {
                                hearts--;
                              }

                              if (game.isCleared()) {
                                nextLevel();
                              }
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            child: cell.active
                                ? Icon(
                                    iconFor(cell.dir),
                                    size: 30,
                                    color: const Color(0xff111936),
                                  )
                                : const SizedBox(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: restartLevel,
                    child: const Text('Yenile'),
                  ),
                  ElevatedButton(
                    onPressed: nextLevel,
                    child: const Text('Sonraki'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
