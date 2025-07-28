import 'package:flutter/material.dart';

enum ChatUserType {
  influencer,
  business
}

class ChatScreen extends StatefulWidget {
  final String partnerName;
  final String partnerImagePath;
  final ChatUserType userType;

  const ChatScreen({
    Key? key,
    required this.partnerName,
    required this.partnerImagePath,
    required this.userType,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [
    // Initial messages to create a conversation
    ChatMessage(
      text: "Hey, Shannu Jashwanth",
      isFromPartner: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    ChatMessage(
      text: "Hi there! How can I help you today?",
      isFromPartner: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
    ),
    ChatMessage(
      text: "I wanted to discuss our upcoming collaboration",
      isFromPartner: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
    ),
    ChatMessage(
      text: "Sure, I'm excited about it. What aspects would you like to discuss?",
      isFromPartner: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
    ChatMessage(
      text: "Let's talk about the timeline and deliverables",
      isFromPartner: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(child: _buildChatList()),
          _buildMessageInput(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black54),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: AssetImage(widget.partnerImagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Wrap the text in Flexible to prevent overflow
          Flexible(
            child: Text(
              widget.partnerName,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.call, color: Colors.black54),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.videocam, color: Colors.black54),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.black54),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildChatList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length,
      reverse: false,
      itemBuilder: (context, index) {
        final message = _messages[index];
        final isFromUser = !message.isFromPartner;
        
        // Fix the alignment issue - partner messages should be on the left
        // User messages should be on the right
        final isOnRightSide = isFromUser;
        
        return _buildMessageBubble(
          message: message.text,
          isOnRightSide: isOnRightSide,
          timestamp: message.timestamp,
        );
      },
    );
  }

  Widget _buildMessageBubble({
    required String message,
    required bool isOnRightSide,
    required DateTime timestamp,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment:
            isOnRightSide ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isOnRightSide) ...[  
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: AssetImage(widget.partnerImagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isOnRightSide ? const Color(0xFF4A2D82) : Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: TextStyle(
                      color: isOnRightSide ? Colors.white : Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(timestamp),
                    style: TextStyle(
                      color: isOnRightSide ? Colors.white70 : Colors.black54,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isOnRightSide) ...[  
            const SizedBox(width: 8),
            // Use the user's image for their messages
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: const DecorationImage(
                  image: AssetImage('assets/images/shannu.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.photo, color: Colors.grey),
              onPressed: () {},
            ),
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Aa',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.mic, color: Colors.grey),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.send, color: Color(0xFF4A2D82)),
              onPressed: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add(
          ChatMessage(
            text: _messageController.text.trim(),
            isFromPartner: false,
            timestamp: DateTime.now(),
          ),
        );
      });
      _messageController.clear();
    }
  }
}

class ChatMessage {
  final String text;
  final bool isFromPartner;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isFromPartner,
    required this.timestamp,
  });
}