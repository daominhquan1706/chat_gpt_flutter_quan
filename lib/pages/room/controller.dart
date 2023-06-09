import 'package:chat_gpt_flutter_quan/service/app_controller.dart';
import 'package:chat_gpt_flutter_quan/service/room_chat_service.dart';
import 'package:chat_gpt_flutter_quan/utils/string_utils.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

enum ChatType {
  welcome,
  loading,
  normalMessage,
  errorMessage,
  advertisement,
}

class RoomPageController extends GetxController {
  types.User get chatGptUser => Get.find<AppController>().chatGptUser;
  types.User get user => Get.find<AppController>().user;

  RxList<types.Room> rooms = RxList<types.Room>([]);

  RoomChatService get roomChatService => Get.find<RoomChatService>();

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  @override
  void onReady() {
    fetchRooms().then((_) {
      if (rooms.isNotEmpty) {
        // goToRoom(rooms.first.id);
      } else {
        // onCreateNewChat();
      }
    });

    super.onReady();
  }

  Future<void> onCreateNewChat() async {
    final roomId = StringUtils.randomString(10);
    await RoomChatService.createRoom(types.Room(
      id: roomId,
      lastMessages: const [],
      createdAt: DateTime.now().millisecondsSinceEpoch,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      type: types.RoomType.direct,
      users: [chatGptUser, user],
    ));
    goToRoom(roomId);
  }

  Future<void> goToRoom(String roomId) async {
    await Get.toNamed('/room/$roomId');
    await fetchRooms();
  }

  void onDeleteRoomPressed(types.Room room) {
    // show dialog confirm
    Get.defaultDialog(
      title: 'Delete room',
      middleText: 'Are you sure you want to delete this room?',
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      onConfirm: () {
        Get.back();
        RoomChatService.deleteRoom(room.id);
        rooms.value = rooms.where((element) => element.id != room.id).toList();
      },
    );
  }

  Future<void> fetchRooms() async {
    rooms.value = (await RoomChatService.getRooms())
      ..sort((a, b) => b.updatedAt!.compareTo(a.updatedAt!));
  }
}
