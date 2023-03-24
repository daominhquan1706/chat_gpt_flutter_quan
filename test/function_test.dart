import 'package:chat_gpt_flutter_quan/pages/chat/controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

void main() {
  const chatGptUser = types.User(id: 'chatGptUser');

  test(
      'handleCancelPressed should remove the message with the given id and insert a new error message',
      () {
    // Arrange
    final messages = [
      types.CustomMessage(
        author: chatGptUser,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: '1',
        metadata: const {
          "type": ChatType.loading,
        },
      ),
      types.CustomMessage(
        author: chatGptUser,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: '3',
        metadata: const {
          "type": ChatType.normalMessage,
        },
      ),
    ];
    final expectedMessages = [
      types.CustomMessage(
        author: chatGptUser,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: '2',
        metadata: const {
          "type": ChatType.errorMessage,
          "error": 'Request was canceled',
        },
      ),
      types.CustomMessage(
        author: chatGptUser,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: '3',
        metadata: const {
          "type": ChatType.normalMessage,
        },
      ),
    ];

    // Act
    ChatPageController.replaceLoadingMessage(
      '1',
      messages,
      types.CustomMessage(
        author: chatGptUser,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: '2',
        metadata: const {
          "type": ChatType.errorMessage,
          "error": 'Request was canceled',
        },
      ),
    );

    // Assert
    expect(messages, expectedMessages);
  });
}
