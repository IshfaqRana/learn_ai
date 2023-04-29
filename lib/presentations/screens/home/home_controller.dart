import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:learn_ai/data/models/ocr_data_model.dart';
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
  int id = 0;

  APIServices apiServices = APIServices();
  var database;

  @override
  void onInit() {
    openDB();
    // insertOneSampleData();
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
      id = chat.id ?? 0;
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

    await db.delete('questions', where: 'id = ?', whereArgs: [chat.id]);
    chats.remove(chat);
  }

  insertOneSampleData() {
    OcrDataModel ocrDataModel = OcrDataModel.fromJson({
      "status": true,
      "statusCode": 200,
      "message": "success",
      "payload": {
        "text": [
          "1) Flutter AOT or JIT?",
          "Answer: Flutter runs in JIT for faster compilation/debugging support in debug mode and AOT mode for better performance in profile and release mode.",
          "",
          "2) Flutter Trees:",
          "Answer:",
          "1. Widget Tree",
          "2. Element Tree",
          "3. Render Tree",
          "4. Layer Tree",
          "",
          "3) Flutter Rendering:",
          "Answer:",
          "1. Handle User Input",
          "2. Run animations",
          "3. Build the widget tree",
          "4. Layout the render object",
          "5. Paint the render object",
          "6. Composite everything into a single image",
          "7. Rasterize: show the output.",
          "",
          "4) Dependency Injection:",
          "Answer: Dependency Injection (DI) is a design pattern used to implement Inversion of Control. It allows the creation of dependent objects outside of a class and provides those objects to a class through different ways. Using DI, we move the creation and binding of the dependent objects outside of the class that depends on them. This brings a higher level of flexibility, decoupling, and easier testing."
        ],
        "url":
            "https://ocrchatgpt3.s3.us-east-2.amazonaws.com/public_images/a0985522-b935-473c-87d6-6e5a31175640-7db835a9-e0af-485f-a3c4-4b81fcb61e14.PNG"
      }
    });
    ChatModel chatModel =
        ChatModel(id: chats.length + 1, question: ocrDataModel.payload!.text);
    insertQuestion(chatModel);
    chats.add(chatModel);
  }

  getAnswer(path, context) async {
    loading.value = true;
    // var response = await apiServices.postImage(File(path));
    var ocrDataModel = await apiServices.getAnswer(File(path), context);
    if (ocrDataModel.status ?? false) {
      ChatModel chatModel =
          ChatModel(id: id + 1, question: ocrDataModel.payload!.text);
      id = id + 1;
      insertQuestion(chatModel);
      Utils.printDebug("Checking id");
      Utils.printDebug(chats.length);
      Utils.printDebug(chatModel.id);

      chats.add(chatModel);
      Get.offAll(() => DetailScreen(
            chat: chatModel,
          ));
    }
    loading.value = false;
  }
}
