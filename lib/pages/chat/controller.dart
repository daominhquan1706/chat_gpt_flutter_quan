import 'package:chat_gpt_flutter_quan/models/ad_model.dart';
import 'package:chat_gpt_flutter_quan/service/ad_mod_service.dart';
import 'package:chat_gpt_flutter_quan/repositories/chat_gpt_repository.dart';
import 'package:chat_gpt_flutter_quan/service/app_controller.dart';
import 'package:chat_gpt_flutter_quan/service/message_chat_service.dart';
import 'package:chat_gpt_flutter_quan/service/room_chat_service.dart';
import 'package:chat_gpt_flutter_quan/utils/string_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:google_mobile_ads/google_mobile_ads.dart';

enum ChatType {
  welcome,
  loading,
  normalMessage,
  errorMessage,
  advertisement,
  unknown,
}

class ChatPageController extends GetxController {
  final isLoading = false.obs;
  final RxList<types.Message> messages = RxList<types.Message>([]);
  // AutoScrollController scrollController = AutoScrollController();
  List<Map<String, String>> get contextMessages {
    final list = <Map<String, String>>[];
    for (var element in messages) {
      if (element is types.CustomMessage &&
          element.metadata?.containsKey('type') == true &&
          element.metadata!['type'] == ChatType.normalMessage.name) {
        list.add({
          'role': element.author.id == user.id ? 'user' : 'assistant',
          'content': element.metadata!['text'] ?? '',
        });
      }
    }
    return list.reversed.toList();
  }

  types.User get chatGptUser => Get.find<AppController>().chatGptUser;
  types.User get user => Get.find<AppController>().user;

  String? get roomId => Get.parameters['id'];
  late types.Room room;

  late AdModel bottomAd;
  int totalTokens = 0;
  // String idLoading;
  late TextEditingController messageController;
  late FocusNode messageFocusNode;
  //drawerkey
  late GlobalKey<ScaffoldState> scaffoldKey;

  @override
  void onInit() {
    scaffoldKey = GlobalKey<ScaffoldState>();
    messageController = TextEditingController();
    messageFocusNode = FocusNode();
    initMessage();
    if (roomId != null) {
      RoomChatService.getRoom(roomId!).then((value) {
        room = value;
      });
    }

    if (!kIsWeb) {
      _loadBottomAd();
    }

    super.onInit();
  }

  @override
  void onClose() {
    scaffoldKey.currentState?.dispose();
    messageController.dispose();
    messageFocusNode.dispose();

    super.onClose();
  }

  Future<void> initMessage() async {
    insertMessages(
      0,
      types.CustomMessage(
        author: chatGptUser,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: StringUtils.randomString(10),
        metadata: {
          'type': ChatType.welcome.name,
        },
      ),
    );

    messages.insertAll(
      0,
      roomId == null ? [] : (await MessageChatService.getMessages(roomId!))
        ..sort((a, b) => b.createdAt!.compareTo(a.createdAt!)),
    );
  }

  void _loadBottomAd() {
    bottomAd = AdModel(
      adUnitId: AdModService.bannerAdUnitId,
      adSize: AdSize(
        height: 52,
        width: Get.width.toInt(),
      ),
    )..generateAd();
  }

  void _chat(String input, {required types.CustomMessage userMessage}) async {
    final idLoading = StringUtils.randomString(10);
    try {
      calculateAddAdvertisement();
      showChatLoading(idLoading);

      var result = await ChatGPTRepository.generateChat(
        [
          ...contextMessages,
        ],
        idLoading: idLoading,
      );

      final indexLoading = messages.indexWhere((element) => element.id == idLoading);
      messages.removeAt(indexLoading);
      if (result == null) {
        return; // is Ok
      }

      final textMessage = types.CustomMessage(
        author: chatGptUser,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: StringUtils.randomString(10),
        metadata: {
          'type': ChatType.normalMessage.name,
          'stream': result,
          'roomId': roomId,
          'userMessageId': userMessage.id,
        },
      );
      insertMessages(indexLoading, textMessage);
    } on DioError catch (e) {
      if (e.type == DioErrorType.cancel) {
        print('Request was canceled');
      }
    } catch (e) {
      final textMessage = types.CustomMessage(
        author: chatGptUser,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: StringUtils.randomString(10),
        metadata: {
          'type': ChatType.errorMessage.name,
          'error': kDebugMode ? e.toString() : 'Something went wrong',
        },
      );

      final index = messages.indexWhere((element) => element.id == idLoading);
      messages.removeAt(index);
      insertMessages(index, textMessage);
    } finally {
      isLoading.value = false;
      messages.removeWhere((element) => element.id == idLoading);
    }
  }

  void showChatLoading(String idLoading) {
    final imageMessage = types.CustomMessage(
        author: chatGptUser,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: idLoading,
        metadata: {
          'type': ChatType.loading.name,
        });

    insertMessages(0, imageMessage);
  }

  void insertMessages(int position, types.CustomMessage message) {
    messages.insert(position, message);
    // chatKey?.currentState?.scrollToMessage(message?.id);
  }

  void handleSendPressed(types.PartialText message) {
    var randomString = StringUtils.randomString(10);
    final textMessage = types.CustomMessage(
        author: user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: randomString,
        metadata: {
          'type': ChatType.normalMessage.name,
          'text': message.text,
        });

    messages.insert(0, textMessage);

    MessageChatService.createMessage(roomId!, textMessage);

    _chat(message.text, userMessage: textMessage);
  }

  void calculateAddAdvertisement() {
    if (messages.length % 3 == 0) {
      Get.log('Add advertisement');
      insertMessages(
        0,
        types.CustomMessage(
          author: chatGptUser,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: StringUtils.randomString(10),
          metadata: {
            'type': ChatType.advertisement.name,
            'advertisement': AdModel(
              adSize: const AdSize(
                height: 250,
                width: 300,
              ),
            )..generateAd(),
          },
        ),
      );
    }
  }

  void handleClearHistoryPressed() {
    // show dialog confirm
    Get.defaultDialog(
      title: 'Clear history',
      middleText: 'Are you sure you want to clear the history?',
      textConfirm: 'Yes',
      textCancel: 'No',
      onConfirm: () {
        Get.back();
        MessageChatService.deleteAllMessages(roomId!);
        messages.clear();
        totalTokens = 0;
        initMessage();
      },
    );
  }

// Function to handle when the cancel button is pressed
  void handleCancelPressed(String id) {
    // Cancel the request with the given id
    Get.find<CancelToken>(tag: id).cancel();

    // Delete the CancelToken object with the given id
    Get.delete<CancelToken>(tag: id);
    final indexLoading = messages.indexWhere((element) => element.id == id);
    messages.removeAt(indexLoading);
    messages.insert(
        indexLoading,
        types.CustomMessage(
          author: chatGptUser,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: StringUtils.randomString(10),
          metadata: {
            'type': ChatType.errorMessage.name,
            'error': 'Request was canceled',
          },
        ));
  }

  void closeDrawer() {
    scaffoldKey.currentState?.openEndDrawer();
  }

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }
}
