import 'dart:async';

import 'package:flutter/material.dart';
import 'package:learn_ai/utils/app_utils.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

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
    var duration = const Duration(seconds: 3);
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
    startTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      duration: const Duration(seconds: 10), //Default value
      interval:
          const Duration(seconds: 1), //Default value: Duration(seconds: 0)
      color: AppColors.hardBlue, //Default value
      colorOpacity: 0, //Default value
      enabled: true, //Default value
      direction: const ShimmerDirection.fromLTRB(),
      child: Scaffold(
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
          )),
    );
  }
}
