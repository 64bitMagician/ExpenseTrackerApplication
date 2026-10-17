import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../custom_widgets/faq_card.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  late VideoPlayerController _controller;

  final List<Map<String, String>> faqData = [
    {
      'question': 'How do I add an expense?',
      'answer': 'Navigate from Dashboard screen to Expenses Screen. In the bottom right corner there is a floating button with a plus icon. Press on it. A pop up will be shown, asking you to add an expense. Add the expense name and price as the pop up suggests and click on "ok".'
    },
    {
      'question': 'How do I add an Income?',
      'answer': 'Navigate from Dashboard screen to Income Screen. In the bottom right corner there is a floating button with a plus icon. Press on it. A pop up will be shown, asking you to add an income. Add the income name and money amount as the pop up suggests and click on "ok".'
    },
    {
      'question': 'How do I add to savings?',
      'answer': 'Navigate from Dashboard screen to Savings Screen. You have three buttons that you can manipulate the savings circle with. First, you need to add a Savings goal by pressing on "Set Savings Goal". A pop up will appear, asking you to enter the amount, and press "ok". After that, whenever you are ready, you can come back to the Savings screen, and press on "Add to Savings" Button to fill the circle progress Savings Bar. The amount is taken from your Current Balance, so you can only add money you actually have, and the total cannot be bigger than the Goal. When you reached that goal, a confetti animation will appear, suggesting that the savings goal has been reached. Also, if you want to reset the Savings Progress Bar, just click on "Delete Savings Goal" and the saved money will return to your Current Balance.'
    },
    {
      'question': 'How do I change my password?',
      'answer': "From the Dashboard Screen, go to Settings > Change Password. There you'll be asked to insert your current password and your new desired password."
    },
    {
      'question': 'What do I do if I forgot my password?',
      'answer': "The first time you installed the app, there was a screen that asked you what is the name of your first dog. With the answer that you gave there, from the login page, press on the |--Forgot your password?--| text button. You will be transferred to another screen, where you'll be asked to write the name of your first dog. The correct answer should match the same answer that you gave the first time you installed the app. If the answer matches and is correct, your current password will pop up on the screen!"
    },
    {
      'question': 'Where is my data stored?',
      'answer': 'All your data stays on this device, nothing is sent to a server. Expenses and incomes are saved as CSV text using SharedPreferences (in the browser\'s local storage when using the web version).',
    },
    {
      'question': 'Can I export my data?',
      'answer': 'No, there is no feature for exporting any data at the moment...',
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/tutorial.mp4')
      ..addListener(_onVideoChanged)
      ..initialize().then((_) {
        if (mounted) setState(() {});
      }, onError: (_) {
        if (mounted) setState(() {}); // shows the error message instead of the spinner
      });
  }

  // Rebuild only when the play overlay needs to change, e.g. when the video ends
  bool _wasPlaying = false;
  void _onVideoChanged() {
    final isPlaying = _controller.value.isPlaying;
    if (isPlaying != _wasPlaying && mounted) {
      setState(() => _wasPlaying = isPlaying);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onVideoChanged);
    _controller.dispose();
    super.dispose();
  }

  Widget buildVideoSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  VideoPlayer(_controller),
                  if (!_controller.value.isPlaying)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _controller.play();
                        });
                      },
                      child: Container(
                        color: Colors.black45,
                        child: const Icon(Icons.play_circle_fill, size: 64, color: Colors.white),
                      ),
                    ),
                  if (_controller.value.isPlaying)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _controller.pause();
                        });
                      },
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: VideoProgressIndicator(_controller, allowScrubbing: true),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                'Watch this short tutorial to understand how the app works.',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFAQSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Row(
            children: [
              Icon(Icons.question_answer),
              SizedBox(width: 8),
              Text(
                'Frequently Asked Questions',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const Divider(
          color: Colors.grey,
          thickness: 1,
          indent: 16,
          endIndent: 16,
        ),
        const SizedBox(height: 4),
        ...faqData.map((item) => FAQCard(
          question: item['question']!,
          answer: item['answer']!,
        )),
        const SizedBox(height: 32),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (_controller.value.isInitialized)
                buildVideoSection()
              else if (_controller.value.hasError)
                const Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text('The tutorial video could not be loaded.'),
                )
              else
                const Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              buildFAQSection(),
            ],
          ),
        ),
      ),
    );
  }
}
