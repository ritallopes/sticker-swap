import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/subjects.dart';
import 'package:sticker_swap_client/src/core/entities/user.dart';
import 'package:sticker_swap_client/src/modules/chat/domain/entities/chat.dart';
import 'package:sticker_swap_client/src/modules/message_chat/domain/entities/message.dart';
import 'package:sticker_swap_client/src/modules/message_chat/domain/entities/message_place.dart';
import 'package:sticker_swap_client/src/modules/message_chat/domain/entities/message_simple.dart';
import 'package:sticker_swap_client/src/modules/message_chat/domain/usecases/get_messages.dart';
import 'package:sticker_swap_client/src/modules/message_chat/presenter/widgets/message_localization.dart';
import 'package:sticker_swap_client/src/utils/consts/status_message_confirm.dart';

class MessageChatBloc{
  final User _user = Modular.get<User>();
  final IGetMessages _getMessagesUseCase = Modular.get<IGetMessages>();

  late List<Message> messages;
  TextEditingController textController = TextEditingController();

  final BehaviorSubject<List<Message>> _messagesStream = BehaviorSubject();
  Stream<List<Message>> get getMessagesView => _messagesStream.stream;


  void getMessages(Chat chat) async{
    messages = await _getMessagesUseCase.call(idChat: chat.id);
    _messagesStream.sink.add(messages);
  }

  bool isMyMessage(Message message)=> message.idSender == _user.id;


  void avaliableLocalization({
    required MessagePlace messagePlace,
    required int newStatus
  }){
    if(messagePlace.status == StatusMessageConfirm.wait){
      messagePlace.status = newStatus;
      _messagesStream.sink.add(messages);
    }
  }

  void sendMessage(){
    if(textController.text.isNotEmpty){
      messages.add(
        MessageSimple(id: 1, message: textController.text, idSender: _user.id!)
      );
      textController.clear();
      _messagesStream.sink.add(messages);
    }
  }

  void dispose(){
    textController.dispose();
    _messagesStream.close();
  }
  
}