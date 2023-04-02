import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get_storage/get_storage.dart';

class MessageChatService extends GetxService {
  Future<MessageChatService> init() async {
    return this;
  }

  //create message
  static Future<types.Message> createMessage(
      String roomId, types.Message message) async {
    final box = GetStorage();
    final messages = box.read<List>('messages_$roomId') ?? [];
    messages.add(message.toJson());
    await box.write('messages_$roomId', messages);
    return message;
  }

  //get messages
  static Future<List<types.Message>> getMessages(String roomId) async {
    final box = GetStorage();
    final messages = box.read<List>('messages_$roomId') ?? [];
    return messages.map((e) => types.Message.fromJson(e)).toList();
  }

  //delete message
  static Future<void> deleteMessage(
      String roomId, types.Message message) async {
    final box = GetStorage();
    final messages = box.read<List>('messages_$roomId') ?? [];
    messages.removeWhere((e) => e['id'] == message.id);
    await box.write('messages_$roomId', messages);
  }

  //update message
  static Future<void> updateMessage(
      String roomId, types.Message message) async {
    final box = GetStorage();
    final messages = box.read<List>('messages_$roomId') ?? [];
    messages.removeWhere((e) => e['id'] == message.id);
    messages.add(message.toJson());
    await box.write('messages_$roomId', messages);
  }

  //delete all messages
  static Future<void> deleteAllMessages(String roomId) async {
    final box = GetStorage();
    await box.remove('messages_$roomId');
  }
}
