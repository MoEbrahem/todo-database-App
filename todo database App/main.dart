// @dart=2.9
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:one/modules/bmi/BMI_Calculator.dart';
import 'package:one/modules/login/login.dart';
import 'package:one/screen/HomePage.dart';
import 'package:one/messenger/Messanger.dart';
import 'package:one/modules/counter/counter_screen.dart';
import 'package:one/modules/users/usersModel.dart';
import 'package:one/shared/bloc_observer.dart';
import 'layout/homeLayout.dart';
void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(),
          home:HomeLayout(),

        );
  }
}



