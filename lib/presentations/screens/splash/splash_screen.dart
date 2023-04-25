import 'dart:async';

import 'package:flutter/material.dart';
import 'package:learn_ai/utils/app_utils.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sizer/sizer.dart';
import 'package:sqflite/sqflite.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_images.dart';
import '../home/home_view.dart';
import '../login/login_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var duration = const Duration(seconds: 5);
    return Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => !login ? LoginView() : HomePageView()));
  }

  int? level;
  bool login = false;
  checkUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("sessionToken") != null) {
      login = true;
    } else {
      databases();
    }
  }

  void _createDb(Database db) {
    db.execute(
      'CREATE TABLE questions(key INTEGER PRIMARY KEY, question TEXT,)',
    );
    Utils.printDebug("dbcreated");
  }

  Future<Database> databases() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(path.join(dbPath, 'mydatabase.db'), version: 1,
        onCreate: (db, version) async {
      await db.execute('''
          CREATE TABLE IF NOT EXISTS questions (
            id INTEGER PRIMARY KEY,
            question TEXT
          )
        ''');
    });
  }

  @override
  void initState() {
    checkUser();
    // startTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.kWhite,
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: SizedBox(
                  height: 30.h,
                  child: Image.asset(
                    AppImages.splash,
                    fit: BoxFit.fill,
                    // color: AppColors.kBlack,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
