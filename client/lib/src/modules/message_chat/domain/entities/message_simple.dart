import 'package:sticker_swap_client/src/modules/message_chat/domain/entities/message.dart';

class MessageSimple extends Message{
  MessageSimple({required super.id, required super.message, super.type=0});
}