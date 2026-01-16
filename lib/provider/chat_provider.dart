import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/data/model/body/message_body.dart';
import 'package:sixvalley_vendor_app/data/model/response/base/api_response.dart';
import 'package:sixvalley_vendor_app/data/model/response/chat_model.dart';
import 'package:sixvalley_vendor_app/data/model/response/message_model.dart';
import 'package:sixvalley_vendor_app/data/repository/chat_repo.dart';
import 'package:sixvalley_vendor_app/helper/api_checker.dart';

class ChatProvider extends ChangeNotifier {
  final ChatRepo? chatRepo;
  ChatProvider({required this.chatRepo});

  List<Chat>? _chatList;
  List<Chat>? get chatList => _chatList;
  List<Message>? _messageList;
  List<Message>? get messageList => _messageList;
  bool _isSendButtonActive = false;
  bool get isSendButtonActive => _isSendButtonActive;
  int _userTypeIndex = 0;
  int get userTypeIndex => _userTypeIndex;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  ChatModel? _chatModel;
  ChatModel? get chatModel => _chatModel;

  // Future<void> getChatList(BuildContext context, int offset,
  //     {bool reload = false}) async {
  //   if (reload) {
  //     _chatModel = null;
  //   }
  //   _isLoading = true;
  //   ApiResponse apiResponse = await chatRepo!
  //       .getChatList(_userTypeIndex == 0 ? 'customer' : 'delivery-man' : 'admin', offset);
  //   if (apiResponse.response != null &&
  //       apiResponse.response!.statusCode == 200) {
  //     if (offset == 1) {
  //       _chatModel = null;
  //       _chatModel = ChatModel.fromJson(apiResponse.response!.data);
  //     } else {
  //       _chatModel!.totalSize =
  //           ChatModel.fromJson(apiResponse.response!.data).totalSize;
  //       _chatModel!.offset =
  //           ChatModel.fromJson(apiResponse.response!.data).offset;
  //       _chatModel!.chat!
  //           .addAll(ChatModel.fromJson(apiResponse.response!.data).chat!);
  //     }
  //   } else {
  //     ApiChecker.checkApi(apiResponse);
  //   }
  //   _isLoading = false;
  //   notifyListeners();
  // }
  Future<void> getChatList(BuildContext context, int offset,
      {bool reload = false}) async {
    if (reload) {
      _chatModel = null;
    }
    _isLoading = true;

    String userType = _userTypeIndex == 0
        ? 'customer'
        : _userTypeIndex == 1
            ? 'delivery-man'
            : 'admin';
    print('PrintData:_____${userType}______');

    ApiResponse apiResponse = await chatRepo!.getChatList(userType, offset);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      if (offset == 1) {
        _chatModel = ChatModel.fromJson(apiResponse.response!.data);
      } else {
        _chatModel!.totalSize =
            ChatModel.fromJson(apiResponse.response!.data).totalSize;
        _chatModel!.offset =
            ChatModel.fromJson(apiResponse.response!.data).offset;
        _chatModel!.chat!
            .addAll(ChatModel.fromJson(apiResponse.response!.data).chat!);
      }
    } else {
      ApiChecker.checkApi(apiResponse);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> searchedChatList(BuildContext context, String search) async {
    ApiResponse apiResponse = await chatRepo!
        .searchChat(_userTypeIndex == 0 ? 'customer' : 'delivery-man', search);
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _chatModel = ChatModel(totalSize: 10, limit: '10', offset: '1', chat: []);
      apiResponse.response!.data.forEach((chat) {
        _chatModel!.chat!.add(Chat.fromJson(chat));
      });
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  Future<void> getMessageList(int? id, int offset) async {
    _messageList = [];
    ApiResponse apiResponse = await chatRepo!.getMessageList(
      _userTypeIndex == 0
          ? 'customer'
          : _userTypeIndex == 1
              ? 'delivery-man'
              : 'admin', // default/fallback to admin
      offset,
      _userTypeIndex == 0 || _userTypeIndex == 1 ? id : 0,
    );
    // ApiResponse apiResponse = await chatRepo!.getMessageList(
    //     _userTypeIndex == 0 ? 'customer' : 'delivery-man', offset, id);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _messageList!
          .addAll(MessageModel.fromJson(apiResponse.response!.data).message!);
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  Future<ApiResponse> sendMessage(
      MessageBody messageBody, BuildContext context) async {
    if (kDebugMode) {
      print('==message====>${messageBody.message}/ ${messageBody.userId}');
    }
    ApiResponse apiResponse = await chatRepo!.sendMessage(
        _userTypeIndex == 0
            ? 'customer'
            : _userTypeIndex == 1
                ? "delivery-man"
                : "admin",
        messageBody);
    print("ddddddddddddd_________${messageBody.userId }");
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      getMessageList(messageBody.userId =='null'?0 :int.parse(messageBody.userId ?? '0'), 1);
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    _isSendButtonActive = false;
    notifyListeners();
    return apiResponse;
  }

  void toggleSendButtonActivity() {
    _isSendButtonActive = !_isSendButtonActive;
    notifyListeners();
  }

  void setUserTypeIndex(BuildContext context, int index) {
    _userTypeIndex = index;
    _chatModel = null;
    getChatList(context, 1);
    notifyListeners();
  }
}
