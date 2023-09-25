import '../../core/configurations.dart';
import '../common_widgets/custom_text_widget.dart';

class SupportChatScreen extends StatelessWidget {
  static const String routeName = 'support_chat_screen';
  const SupportChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Support"),
      ),
      body: const CenterText(text: "Support screen"),
    );
  }
}
