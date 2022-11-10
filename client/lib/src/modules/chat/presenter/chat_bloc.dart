import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rxdart/subjects.dart';
import 'package:sticker_swap_client/src/core/entities/user.dart';
import 'package:sticker_swap_client/src/modules/chat/domain/entities/chat.dart';
import 'package:sticker_swap_client/src/modules/chat/domain/usecases/get_chats.dart';

class ChatBloc{

  final User _user = Modular.get<User>();
  final IGetChats _getChatsUseCase = Modular.get<IGetChats>();

  TextEditingController searchController = TextEditingController();

  final BehaviorSubject<List<Chat>> _chatsStream = BehaviorSubject();
  Stream<List<Chat>> get getChatsView => _chatsStream.stream;


  void getChats() async{
    List<Chat> chats = await _getChatsUseCase.call(idUser: _user.id!);
    _chatsStream.sink.add(chats);
  }

  void openChat(Chat chat){
    Modular.to.pushNamed("/message_chat", arguments: chat);
  }

  void onSearch(){}


  void dispose(){
    _chatsStream.close();
    searchController.dispose();
  }

}