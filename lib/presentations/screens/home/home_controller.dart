import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:learn_ai/utils/app_utils.dart';
import 'package:sqflite/sqflite.dart';

import '../../../data/apis/api_calls.dart';
import '../../../data/models/chat_model.dart';
import '../answer_screen/detail_screen.dart';

class HomeController extends GetxController {
  RxBool loading = false.obs;
  RxBool isLoading = false.obs;
  Rx<UserChats> userChats = UserChats(chats: []).obs;
  RxList<ChatModel> chats = [ChatModel(question: [], id: 0)].obs;

  APIServices apiServices = APIServices();
  var database;

  @override
  void onInit() {
    openDB();

    getUserChats();
    super.onInit();
  }

  Future<Database> openDB() async {
    Database database = await openDatabase("mydatabase.db");
    return database;
  }

  getUserChats() async {
    isLoading.value = true;
    chats.value = [];
    final db = await openDB();
    final List<Map<String, dynamic>> maps = await db.query('questions');
    Utils.printDebug(maps.length);
    for (int i = 0; i < maps.length; i++) {
      Map<String, dynamic> mapList = maps[i];
      final items = List<String>.from(json.decode(mapList.values.elementAt(1)));
      ChatModel chat = ChatModel(
        id: mapList.values.elementAt(0),
        question: items,
      );
      Utils.printDebug("Keys are :${chat.id}");
      chats.add(chat);
    }

    isLoading.value = false;
  }

  Future<void> insertQuestion(ChatModel chat) async {
    Database db = await openDB();
    final questions = json.encode(chat.question);
    DBInsertion dbInsertion = DBInsertion(id: chat.id, question: questions);
    await db.insert(
      'questions',
      dbInsertion.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteQuestion(ChatModel chat) async {
    Database db = await openDB();

    await db
        .delete('questions', where: 'question = ?', whereArgs: [chat.question]);
    chats.remove(chat);
  }

  getAnswer(path, context) async {
    loading.value = true;
    // var response = await apiServices.postImage(File(path));
    var ocrDataModel = await apiServices.getAnswer(File(path), context);
    if (ocrDataModel.status ?? false) {
      ChatModel chatModel =
          ChatModel(id: chats.length + 1, question: ocrDataModel.payload!.text);
      insertQuestion(chatModel);
      chats.add(chatModel);
      Get.offAll(() => DetailScreen(
            chat: chatModel,
          ));
    }
    loading.value = false;
  }
}
