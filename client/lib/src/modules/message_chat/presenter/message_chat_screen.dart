import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sticker_swap_client/src/modules/chat/domain/entities/chat.dart';
import 'package:sticker_swap_client/src/modules/message_chat/domain/entities/message.dart';
import 'package:sticker_swap_client/src/modules/message_chat/domain/entities/message_simple.dart';
import 'package:sticker_swap_client/src/modules/message_chat/domain/entities/message_swap_stickers.dart';
import 'package:sticker_swap_client/src/modules/message_chat/presenter/message_chat_bloc.dart';
import 'package:sticker_swap_client/src/modules/message_chat/presenter/widgets/bottom_message_chat.dart';
import 'package:sticker_swap_client/src/modules/message_chat/presenter/widgets/message_localization.dart';
import 'package:sticker_swap_client/src/modules/message_chat/presenter/widgets/message_swap.dart';
import 'package:sticker_swap_client/src/modules/message_chat/presenter/widgets/message_tile.dart';

class MessageChatScreen extends StatefulWidget {
  final Chat chat;
  const MessageChatScreen({Key? key, required this.chat}) : super(key: key);

  @override
  State<MessageChatScreen> createState() => _MessageChatScreenState();
}

class _MessageChatScreenState extends ModularState<MessageChatScreen, MessageChatBloc> {


  @override
  void initState() {
    controller.getMessages(widget.chat);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mensagem"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
              child: StreamBuilder<List<Message>>(
                stream: controller.getMessagesView,
                builder: (_, snapshot) {
                  if(!snapshot.hasData)
                    return const Center(child: CircularProgressIndicator(),);

                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (_, index) {
                      if(snapshot.data![index] is MessageSimple)
                        return MessageTile(message: snapshot.data![index]);

                      if(snapshot.data![index] is MessageSwapStickers)
                        return MessageSwap();
                      else
                        return MessageLocalization(message: snapshot.data![index]);
                    },
                  );

                }
              )
          ),
          BottomMessageChat()
        ],
      ),
    );
  }
}
