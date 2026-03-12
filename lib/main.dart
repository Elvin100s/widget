import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CarouselView Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const DemoPage(),
    );
  }
}

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  static const _items = [
    {'title': 'Mountains', 'icon': Icons.landscape,     'color': Color(0xFF6A9CC9)},
    {'title': 'Ocean',     'icon': Icons.water,         'color': Color(0xFF4A90D9)},
    {'title': 'Forest',    'icon': Icons.forest,        'color': Color(0xFF5AAD6F)},
    {'title': 'Desert',    'icon': Icons.wb_sunny,      'color': Color(0xFFD4A843)},
    {'title': 'City',      'icon': Icons.location_city, 'color': Color(0xFF8E7CC3)},
    {'title': 'Space',     'icon': Icons.nights_stay,   'color': Color(0xFF3B4A6B)},
  ];

  late final CarouselController _controller;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = CarouselController();
    _controller.addListener(() {
      if (!_controller.hasClients) return;
      final newIndex = (_controller.offset / 260).round().clamp(0, _items.length - 1);
      if (newIndex != _currentIndex) {
        setState(() => _currentIndex = newIndex);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap(int index) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text('Tapped: ${_items[index]['title']}'),
        duration: const Duration(seconds: 1),
      ));
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: scheme.inversePrimary,
        title: const Text('CarouselView Demo'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([

                // ── Default CarouselView ─────────────────────────────
                const Text(
                  '1. Default CarouselView',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Scrolls horizontally. Each card has a fixed width (itemExtent). '
                  'Tap a card to see its name. Cards snap into place when you release.',
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 200,
                  child: CarouselView(
                    controller: _controller,
                    itemExtent: 260,
                    shrinkExtent: 160,
                    onTap: _onTap,
                    itemSnapping: true,
                    children: List.generate(_items.length, (i) => _CarouselCard(
                      title: _items[i]['title'] as String,
                      icon: _items[i]['icon'] as IconData,
                      color: _items[i]['color'] as Color,
                    )),
                  ),
                ),

                // ── Dot indicator ────────────────────────────────────
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_items.length, (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentIndex == i ? 20 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentIndex == i
                          ? scheme.primary
                          : scheme.outlineVariant,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  )),
                ),

                // ── Prev / Next buttons ──────────────────────────────
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton.icon(
                      onPressed: _currentIndex == 0
                          ? null
                          : () {
                              setState(() => _currentIndex--);
                              _controller.animateToItem(
                                _currentIndex,
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                              );
                            },
                      icon: const Icon(Icons.chevron_left),
                      label: const Text('Prev'),
                    ),
                    const SizedBox(width: 16),
                    FilledButton.icon(
                      onPressed: _currentIndex == _items.length - 1
                          ? null
                          : () {
                              setState(() => _currentIndex++);
                              _controller.animateToItem(
                                _currentIndex,
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeInOut,
                              );
                            },
                      icon: const Icon(Icons.chevron_right),
                      label: const Text('Next'),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // ── Weighted CarouselView ────────────────────────────
                const Text(
                  '4. CarouselView.weighted',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 200,
                  child: CarouselView.weighted(
                    flexWeights: const [3, 2, 1],
                    onTap: _onTap,
                    children: _items.reversed.map((item) => _CarouselCard(
                      title: item['title'] as String,
                      icon: item['icon'] as IconData,
                      color: item['color'] as Color,
                    )).toList(),
                  ),
                ),

                const SizedBox(height: 20),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _CarouselCard extends StatelessWidget {
  const _CarouselCard({
    required this.title,
    required this.icon,
    required this.color,
  });

  final String title;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.white),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
