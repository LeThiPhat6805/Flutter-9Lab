import 'package:flutter/material.dart';

void main() {
  runApp(const DestiniApp());
}

class DestiniApp extends StatelessWidget {
  const DestiniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Destini',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      home: const DestiniPage(),
    );
  }
}

// Story node model
class StoryNode {
  final String storyText;
  final String? choiceA;
  final String? choiceB;
  final int? nextA; // index of next node for choice A
  final int? nextB; // index of next node for choice B

  const StoryNode({
    required this.storyText,
    this.choiceA,
    this.choiceB,
    this.nextA,
    this.nextB,
  });

  bool get isEnding => choiceA == null;
}

// Story data (adventure story with multiple endings)
const List<StoryNode> _story = [
  // 0 - Start
  StoryNode(
    storyText:
        'Bạn đang đi bộ trong rừng thì gặp một ngã ba đường. Phía trái là con đường có ánh đèn leo lắt, phía phải là con đường tối tăm im lặng.',
    choiceA: '⬅️ Đi theo ánh đèn',
    choiceB: '➡️ Đi vào bóng tối',
    nextA: 1,
    nextB: 2,
  ),
  // 1 - Light path
  StoryNode(
    storyText:
        'Ánh đèn dẫn bạn đến một ngôi làng nhỏ. Người dân thân thiện mời bạn vào ăn tối. Bạn có muốn ở lại hay tiếp tục lên đường?',
    choiceA: '🏡 Ở lại làng nghỉ ngơi',
    choiceB: '🚶 Tiếp tục hành trình',
    nextA: 3,
    nextB: 4,
  ),
  // 2 - Dark path
  StoryNode(
    storyText:
        'Trong bóng tối, bạn nghe thấy tiếng kêu cứu. Bạn tìm thấy một nhà thám hiểm bị thương. Bạn có giúp họ không?',
    choiceA: '❤️ Giúp đỡ nhà thám hiểm',
    choiceB: '🏃 Bỏ đi tiếp',
    nextA: 5,
    nextB: 6,
  ),
  // 3 - ENDING: Rest at village
  StoryNode(
    storyText:
        '🎉 Kết thúc 1: Bạn ở lại làng, kết thân với người dân và tìm thấy hạnh phúc bình dị. Một kết thúc ấm áp!',
  ),
  // 4 - ENDING: Continue journey from village
  StoryNode(
    storyText:
        '🗺️ Kết thúc 2: Bạn tiếp tục hành trình và khám phá ra một kho báu bí ẩn sâu trong rừng. Bạn trở thành nhà thám hiểm nổi tiếng!',
  ),
  // 5 - ENDING: Help the explorer
  StoryNode(
    storyText:
        '🤝 Kết thúc 3: Nhà thám hiểm là người nổi tiếng, họ cảm ơn bạn và dẫn bạn đến ngôi đền cổ đầy kho báu. Bạn giàu có và nổi tiếng!',
  ),
  // 6 - ENDING: Abandon explorer
  StoryNode(
    storyText:
        '💀 Kết thúc 4: Bạn bỏ đi và rơi vào một cái bẫy của kẻ xấu trong rừng. Hành trình kết thúc bi thảm...',
  ),
];

class DestiniPage extends StatefulWidget {
  const DestiniPage({super.key});

  @override
  State<DestiniPage> createState() => _DestiniPageState();
}

class _DestiniPageState extends State<DestiniPage> {
  int _currentNodeIndex = 0;

  StoryNode get _currentNode => _story[_currentNodeIndex];

  void _choose(int? nextIndex) {
    if (nextIndex == null) return;
    setState(() {
      _currentNodeIndex = nextIndex;
    });
  }

  void _restart() {
    setState(() {
      _currentNodeIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final node = _currentNode;

    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        backgroundColor: Colors.brown.shade800,
        title: const Text(
          '🗺️ Destini',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _restart,
            tooltip: 'Restart',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    node.storyText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              if (node.isEnding) ...[
                const Text(
                  '— THE END —',
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _restart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Text(
                    '🔄 Chơi lại từ đầu',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ] else ...[
                ElevatedButton(
                  onPressed: () => _choose(node.nextA),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown.shade700,
                    padding: const EdgeInsets.all(16),
                  ),
                  child: Text(
                    node.choiceA!,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => _choose(node.nextB),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown.shade400,
                    padding: const EdgeInsets.all(16),
                  ),
                  child: Text(
                    node.choiceB!,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
