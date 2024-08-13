import 'package:flutter/material.dart';

class UiProvider extends ChangeNotifier {

  bool _isdark = false;
  bool get isDark => _isdark;

  final darkTheme = ThemeData(
      primaryColor: Colors.black,
      brightness: Brightness.dark,
      primaryColorDark: Colors.black

  );
  final lightTheme = ThemeData(
      primaryColor: Colors.white,
      brightness: Brightness.light,
      primaryColorDark: Colors.white
  );

  changeTheme(){

    _isdark =  !isDark;
    notifyListeners();
  }

  init(){
    notifyListeners();
  }

}