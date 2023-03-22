import 'dart:developer';

import 'package:chatgoclient/config/size_config.dart';
import 'package:chatgoclient/controllers/chat.dart';
import 'package:chatgoclient/controllers/user_mangement.dart';
import 'package:chatgoclient/data/models/chat_preview.dart';
import 'package:chatgoclient/ui/widgets/chat/chat_bottom.dart';
import 'package:chatgoclient/ui/widgets/chat/chat_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends StatefulWidget {
  final ChatPreview chatPreview;
  const ChatScreen({super.key, required this.chatPreview});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    ChatController.instance.initScrollController();
    super.initState();
  }

  @override
  void dispose() {
    ChatController.instance.closeChatSnapShot();
    ChatController.instance.disposeScrollController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              child: Text(widget.chatPreview.receiverName[0]),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(widget.chatPreview.receiverName),
          ],
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.safeBlockHorizontal * 2,
            vertical: SizeConfig.blockSizeVertical * 1),
        child: Consumer(
          builder: (context, ref, child) {
            final chatController = ref.read(chatProvider);
            return Column(
              children: [
                Expanded(
                  child: GestureDetector(
                      onTap: () {
                        // FocusScopeNode currentFocus = FocusScope.of(context);
                        // if (!currentFocus.hasPrimaryFocus) {
                        //   currentFocus.unfocus();
                        // }
                      },
                      child: FutureBuilder(
                          future: chatController.populateInitialChats(
                              reciverId: widget.chatPreview.receiverid),
                          builder: (context, data) {
                            if (data.connectionState == ConnectionState.done) {
                              return Consumer(
                                builder: (context, ref, child) {
                                  ref.watch(chatProvider);
                                  chatController.scrollDown();
                                 
                                  return ListView.builder(
                                    controller: chatController.scrollController,
                                    itemBuilder: (context, index) {
                                      return ChatCard(
                                          chat: chatController.userChats[widget
                                              .chatPreview.receiverid]![index]);
                                    },
                                    itemCount: chatController
                                        .userChats[
                                            widget.chatPreview.receiverid]
                                        ?.length,
                                  );
                                },
                              );
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          })),
                ),
                ChatBottom(
                  receiverId: widget.chatPreview.receiverid,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
