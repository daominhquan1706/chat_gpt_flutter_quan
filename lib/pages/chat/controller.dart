import 'package:chat_gpt_flutter_quan/models/ad_model.dart';
import 'package:chat_gpt_flutter_quan/service/ad_mod_service.dart';
import 'package:chat_gpt_flutter_quan/repositories/chat_gpt_repository.dart';
import 'package:chat_gpt_flutter_quan/utils/string_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

enum ChatType {
  welcome,
  loading,
  normalMessage,
  errorMessage,
  advertisement,
}

class ChatPageController extends GetxController {
  final isLoading = false.obs;
  final RxList<types.Message> messages = RxList<types.Message>([]);
  final user = const types.User(id: 'user');
  final chatGptUser = const types.User(id: 'chatGptUser');
  ChatPageController();
  AutoScrollController get scrollController =>
      Get.put<AutoScrollController>(AutoScrollController());
  List<Map<String, String>> contextMessages = [];

  AdModel bottomAd;
  int totalTokens = 0;
  // String idLoading;

  @override
  void onInit() {
    initMessage();
    if (!kIsWeb) {
      _loadBottomAd();
    }

    super.onInit();
  }

  void initMessage() {
    messages.insert(
      0,
      types.CustomMessage(
        author: chatGptUser,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: StringUtils.randomString(10),
        metadata: const {"type": ChatType.welcome},
      ),
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

  void _chat(String input) async {
    final idLoading = StringUtils.randomString(10);
    try {
      calculateAddAdvertisement();
      showChatLoading(idLoading);

      var result = await ChatGPTRepository.makeRequest(
        [
          ...contextMessages,
          {
            "role": "user",
            "content": input,
          },
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
          "stream": result,
        },
      );
      messages.insert(indexLoading, textMessage);
    } on DioError catch (e) {
      if (e.type == DioErrorType.cancel) {
        print("Request was canceled");
      }
    } catch (e) {
      final textMessage = types.CustomMessage(
        author: chatGptUser,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: StringUtils.randomString(10),
        metadata: {
          "type": ChatType.errorMessage,
          "error": kDebugMode ? e.toString() : 'Something went wrong',
        },
      );

      final index = messages.indexWhere((element) => element.id == idLoading);
      messages.removeAt(index);
      messages.insert(index, textMessage);
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
        metadata: const {
          'type': ChatType.loading,
        });

    messages.insert(0, imageMessage);
  }

  void handleSendPressed(types.PartialText message) {
    final textMessage = types.CustomMessage(
        author: user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: StringUtils.randomString(10),
        metadata: {
          "text": message.text,
        });

    messages.insert(0, textMessage);

    _chat(message.text);
    scrollController.scrollToIndex(0);
  }

  void calculateAddAdvertisement() {
    if (messages.length % 9 == 0) {
      Get.log("Add advertisement");
      messages.insert(
        0,
        types.CustomMessage(
          author: chatGptUser,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: StringUtils.randomString(10),
          metadata: {
            "type": ChatType.advertisement,
            "advertisement": AdModel(
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
    messages.clear();
    totalTokens = 0;
    initMessage();
  }

// Function to handle when the cancel button is pressed
  void handleCancelPressed(String id) {
    // Cancel the request with the given id
    Get.find<CancelToken>(tag: id).cancel();

    // Delete the CancelToken object with the given id
    Get.delete<CancelToken>(tag: id);
    messages.value = replaceLoadingMessage(
      id,
      messages,
      types.CustomMessage(
        author: chatGptUser,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: StringUtils.randomString(10),
        metadata: const {
          "type": ChatType.errorMessage,
          "error": 'Request was canceled',
        },
      ),
    );
  }

  static List<types.Message> replaceLoadingMessage(
      String idLoading, List<types.Message> messages, types.CustomMessage message) {
    // Find the index of the message with the given id
    final indexLoading = messages.indexWhere((element) => element.id == idLoading);

    // Remove the message from the list
    messages.removeAt(indexLoading);

    // Insert the new message into the list at the same index as the removed one
    messages.insert(indexLoading, message);
    return messages;
  }
}
