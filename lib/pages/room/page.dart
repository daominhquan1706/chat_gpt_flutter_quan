import 'package:chat_gpt_flutter_quan/pages/chat/widgets/chat_bubble_widget.dart';
import 'package:chat_gpt_flutter_quan/pages/room/controller.dart';
import 'package:chat_gpt_flutter_quan/service/app_controller.dart';
import 'package:chat_gpt_flutter_quan/service/message_chat_service.dart';
import 'package:chat_gpt_flutter_quan/utils/constants.dart';
import 'package:chat_gpt_flutter_quan/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:intl/intl.dart';

class RoomPage extends GetView<RoomPageController> {
  final String partnerFullname;
  final String partnerId;
  const RoomPage({
    Key key,
    this.partnerFullname,
    this.partnerId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        centerTitle: false,
        elevation: 0,
      ),
      body: Obx(
        () => ListView.separated(
          itemCount: controller.rooms.length,
          itemBuilder: (context, index) {
            final room = controller.rooms[index];
            return _buildRoomItem(room, index);
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider(height: 1);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.onCreateNewChat();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildRoomItem(types.Room room, int index) {
    return InkWell(
      onTap: () {
        controller.goToRoom(room);
      },
      child: Card(
        color: Colors.white,
        child: Column(
          children: [
            ListTile(
              title: Text(
                toTimeAgo(DateTime.fromMicrosecondsSinceEpoch(room.createdAt * 1000)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  height: 24 / 15,
                  letterSpacing: 0.15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  controller.onDeleteRoomPressed(room);
                },
              ),
            ),
            Container(
              color: Colors.grey.shade200,
              child: FutureBuilder(
                future: MessageChatService.getMessages(room.id),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final messages = snapshot.data as List<types.Message>;
                    if (messages.isNotEmpty) {
                      return Column(
                        children: [
                          _buildChatMessage(messages[messages.length - 2]),
                          16.verticalSpace,
                          _buildChatMessage(messages[messages.length - 1]),
                        ],
                      ).paddingAll(16);
                    }
                  }
                  return Container(
                    height: 1,
                    color: Colors.grey,
                  );
                },
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                const Text(
                  'View All Messages',
                  style: TextStyle(
                    fontSize: 15,
                    height: 24 / 15,
                    letterSpacing: 0.15,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue,
                  ),
                ).paddingOnly(bottom: 5),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                  color: Colors.blue,
                ),
              ],
            ).paddingSymmetric(horizontal: 16),
          ],
        ),
      ),
    );
  }

  String toTimeAgo(DateTime date) {
    final difference = DateTime.now().difference(date);

    if (difference.inDays > 7) {
      return DateFormat('dd/MM/yyyy').format(date);
    } else if (difference.inDays >= 1) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inSeconds >= 1) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'just now';
    }
  }

  _buildChatMessage(types.Message message) {
    final isChatGPT = message.author.id == Get.find<AppController>().chatGptUser.id;
    return Align(
      alignment: isChatGPT ? Alignment.centerLeft : Alignment.centerRight,
      child: ChatBubbleWidget(
        message: message,
        nextMessageInGroup: false,
        child: Text(
          message.metadata['text'].toString(),
          style: AppConstant.textStyle.copyWith(color: isChatGPT ? Colors.black : Colors.white),
        ).paddingSymmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
