import 'package:chat_gpt_flutter_quan/service/message_chat_service.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get_storage/get_storage.dart';

class RoomChatService extends GetxService {
  Future<RoomChatService> init() async {
    return this;
  }

  //create room
  static Future<types.Room> createRoom(types.Room room) async {
    final box = GetStorage();
    final rooms = box.read<List>('rooms') ?? [];
    rooms.add(room.toJson());
    await box.write('rooms', rooms);
    return room;
  }

  //get room
  static Future<types.Room> getRoom(String roomId) async {
    final box = GetStorage();
    final rooms = box.read<List>('rooms') ?? [];
    final room = rooms.firstWhere((element) => element['id'] == roomId);
    return types.Room.fromJson(room);
  }

  //get rooms
  static Future<List<types.Room>> getRooms() async {
    final box = GetStorage();
    final rooms = box.read<List>('rooms') ?? [];
    return rooms.map((e) => types.Room.fromJson(e)).toList();
  }

  //update room
  static Future<types.Room> updateRoom(types.Room room) async {
    final box = GetStorage();
    final rooms = box.read<List>('rooms') ?? [];
    final index = rooms.indexWhere((element) => element['id'] == room.id);
    rooms[index] = room.toJson();
    await box.write('rooms', rooms);
    return room;
  }

  //delete room
  static Future<void> deleteRoom(String roomId) async {
    final box = GetStorage();
    final rooms = box.read<List>('rooms') ?? [];
    final index = rooms.indexWhere((element) => element['id'] == roomId);
    rooms.removeAt(index);
    await box.write('rooms', rooms);
    await MessageChatService.deleteAllMessages(roomId);
  }
}
