import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CommunityForumPage extends StatefulWidget {
  const CommunityForumPage({super.key});
  @override
  State<CommunityForumPage> createState() => _CommunityForumPageState();
}

class _CommunityForumPageState extends State<CommunityForumPage> {
  final TextEditingController _questionController = TextEditingController();
  final _supabase = Supabase.instance.client;
  String _farmerName = 'একজন চাষি';
  bool _isPosting = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadFarmerName();
  }

  // লোকাল স্টোরেজ থেকে কৃষকের নাম লোড করা হচ্ছে
  Future<void> _loadFarmerName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _farmerName = prefs.getString('farmer_name') ?? 'একজন চাষি';
    });
  }

  Future<void> _postQuestion() async {
    final question = _questionController.text.trim();
    if (question.isEmpty || _isPosting) return;

    setState(() => _isPosting = true);
    try {
      await _supabase.from('posts').insert({'farmer_name': _farmerName, 'question': question});
      if (mounted) _questionController.clear();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('পোস্ট করতে সমস্যা হয়েছে: $e')));
      }
    } finally {
      if (mounted) setState(() => _isPosting = false);
    }
  }

  Stream<List<Map<String, dynamic>>> _fetchPosts() {
    // নতুন পোস্ট নিচে দেখানোর জন্য ascending: true ব্যবহার করা হয়েছে
    return _supabase.from('posts').stream(primaryKey: ['id']).order('created_at', ascending: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('কৃষক ফোরাম'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade700, Colors.green.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _fetchPosts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('ত্রুটি: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('এখনও কোনো প্রশ্ন করা হয়নি।\nআপনার প্রশ্নটি প্রথম করুন!', textAlign: TextAlign.center));
                } else {
                  final posts = snapshot.data!;
                  // নতুন মেসেজ এলে স্বয়ংক্রিয়ভাবে স্ক্রল করার জন্য
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_scrollController.hasClients) {
                      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                    }
                  });
                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(10),
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      final isCurrentUser = post['farmer_name'] == _farmerName;
                      return _MessageBubble(
                        farmerName: post['farmer_name'] ?? 'অজানা চাষি',
                        question: post['question'] ?? 'প্রশ্ন নেই',
                        isCurrentUser: isCurrentUser,
                      );
                    },
                  );
                }
              },
            ),
          ),
          // প্রশ্ন লেখার ইনপুট ফিল্ড
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, -2)),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _questionController,
                      decoration: InputDecoration(
                        hintText: 'আপনার প্রশ্ন লিখুন...',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      ),
                      onSubmitted: (_) => _postQuestion(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    icon: _isPosting
                        ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Icon(Icons.send),
                    onPressed: _postQuestion,
                    style: IconButton.styleFrom(padding: const EdgeInsets.all(12), backgroundColor: Colors.green),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// চ্যাট বাবল দেখানোর জন্য একটি কাস্টম উইজেট
class _MessageBubble extends StatelessWidget {
  final String farmerName;
  final String question;
  final bool isCurrentUser;

  const _MessageBubble({required this.farmerName, required this.question, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: isCurrentUser ? Colors.green.shade200 : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: isCurrentUser ? const Radius.circular(20) : Radius.zero,
            bottomRight: isCurrentUser ? Radius.zero : const Radius.circular(20),
          ),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 3)],
        ),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        child: Column(
          crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              isCurrentUser ? 'আপনি' : farmerName,
              style: TextStyle(fontWeight: FontWeight.bold, color: isCurrentUser ? Colors.green.shade900 : Colors.blueGrey, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(question, style: const TextStyle(color: Colors.black87, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

