// lib/screens/chat_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../services/database_service.dart';
import 'breathing_screen.dart';
import 'journal_screen.dart';
import 'affirmations_screen.dart';

class ChatScreen extends StatefulWidget {
  final String language;

  const ChatScreen({super.key, required this.language});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final DatabaseService _dbService = DatabaseService();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    final chatProvider = context.read<ChatProvider>();
    chatProvider.sendMessage(_controller.text, widget.language);
    _controller.clear();

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFF212121),
      drawer: _buildDrawer(),
      body: Column(
        children: [
          _buildTopBar(),
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, child) {
                if (chatProvider.messages.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: chatProvider.messages.length,
                  itemBuilder: (context, index) {
                    final message = chatProvider.messages[index];
                    return _MessageBubble(
                      text: message['text'],
                      isUser: message['isUser'],
                    );
                  },
                );
              },
            ),
          ),
          Consumer<ChatProvider>(
            builder: (context, chatProvider, child) {
              if (!chatProvider.isLoading) return const SizedBox.shrink();
              return Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Color(0xFF10A37F)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      widget.language == 'ru'
                          ? 'AI думает...'
                          : widget.language == 'en'
                              ? 'AI is thinking...'
                              : 'AI ойлануда...',
                      style: TextStyle(color: Colors.grey.shade400),
                    ),
                  ],
                ),
              );
            },
          ),
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2F2F2F),
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade800, width: 1),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
            const Expanded(
              child: Text(
                'MoodMate AI',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () async {
                final chatProvider = context.read<ChatProvider>();
                await chatProvider.createNewChat();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFF2F2F2F),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF10A37F), Color(0xFF19C37D)],
              ),
            ),
            child: const SafeArea(
              bottom: false,
              child: Row(
                children: [
                  Icon(Icons.favorite, color: Colors.white, size: 32),
                  SizedBox(width: 12),
                  Text(
                    'MoodMate AI',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, child) {
                if (chatProvider.allChats.isEmpty) {
                  return Center(
                    child: Text(
                      widget.language == 'ru'
                          ? 'Нет чатов'
                          : widget.language == 'en'
                              ? 'No chats'
                              : 'Чат жоқ',
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: chatProvider.allChats.length,
                  itemBuilder: (context, index) {
                    final chat = chatProvider.allChats[index];
                    final isActive = chat['id'] == chatProvider.currentChatId;

                    return ListTile(
                      selected: isActive,
                      selectedTileColor: Colors.grey.shade800,
                      leading: const Icon(Icons.chat_bubble_outline,
                          color: Colors.white70),
                      title: Text(
                        chat['title'] ?? 'Новый чат',
                        style: const TextStyle(color: Colors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline,
                            color: Colors.white70),
                        onPressed: () async {
                          await chatProvider.deleteChat(chat['id']);
                        },
                      ),
                      onTap: () async {
                        await chatProvider.switchChat(chat['id']);
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              },
            ),
          ),
          Divider(color: Colors.grey.shade800),
          ListTile(
            leading: const Icon(Icons.air, color: Color(0xFF10A37F)),
            title: Text(
              widget.language == 'ru'
                  ? 'Дыхание'
                  : widget.language == 'en'
                      ? 'Breathing'
                      : 'Тыныс алу',
              style: const TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BreathingScreen(language: widget.language),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.book, color: Color(0xFF10A37F)),
            title: Text(
              widget.language == 'ru'
                  ? 'Дневник'
                  : widget.language == 'en'
                      ? 'Journal'
                      : 'Күнделік',
              style: const TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => JournalScreen(language: widget.language),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.auto_awesome, color: Color(0xFF10A37F)),
            title: Text(
              widget.language == 'ru'
                  ? 'Аффирмации'
                  : widget.language == 'en'
                      ? 'Affirmations'
                      : 'Аффирмациялар',
              style: const TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AffirmationsScreen(language: widget.language),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF10A37F), Color(0xFF19C37D)],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.psychology, size: 40, color: Colors.white),
          ),
          const SizedBox(height: 20),
          Text(
            widget.language == 'ru'
                ? 'Начни разговор!'
                : widget.language == 'en'
                    ? 'Start conversation!'
                    : 'Әңгімені бастаңыз!',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            widget.language == 'ru'
                ? 'Расскажи мне о своём дне'
                : widget.language == 'en'
                    ? 'Tell me about your day'
                    : 'Күніңіз туралы айтыңыз',
            style: TextStyle(color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2F2F2F),
        border: Border(
          top: BorderSide(color: Colors.grey.shade800, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: widget.language == 'ru'
                      ? 'Напиши сообщение...'
                      : widget.language == 'en'
                          ? 'Write a message...'
                          : 'Хабарлама жазыңыз...',
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: const Color(0xFF3E3E3E),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF10A37F), Color(0xFF19C37D)],
                ),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.send),
                color: Colors.white,
                onPressed: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final String text;
  final bool isUser;

  const _MessageBubble({
    required this.text,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF10A37F), Color(0xFF19C37D)],
                ),
                shape: BoxShape.circle,
              ),
              child:
                  const Icon(Icons.psychology, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    isUser ? const Color(0xFF10A37F) : const Color(0xFF3E3E3E),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 12),
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Color(0xFF10A37F),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 20),
            ),
          ],
        ],
      ),
    );
  }
}
