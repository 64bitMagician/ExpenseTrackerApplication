import 'package:flutter/material.dart';
import '../custom_widgets/faq_card.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  static const List<Map<String, String>> faqData = [
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(top: 8, bottom: 32),
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
          ],
        ),
      ),
    );
  }
}
