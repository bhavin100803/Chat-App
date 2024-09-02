import 'package:chatapp/models/UserModel.dart';
import 'package:chatapp/models/firebasehelper.dart';
import 'package:chatapp/pages/homepage.dart';
import 'package:chatapp/pages/splashscreen.dart';
import 'package:chatapp/provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';


var uuid = Uuid();

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyBjRzt6I1Y6bkebXgw7PsPAOsJtzFIOQLc",
        appId: "1:612689158470:android:09597bcacb595b903b0547",
        messagingSenderId: "612689158470",
        projectId: "chat-app-1a9c4",
        // Your web Firebase config options
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  User? currentUser = FirebaseAuth.instance.currentUser;
  if(currentUser != null) {
    // Logged In
    UserModel? thisUserModel = await FirebaseHelper.getUserModelById(currentUser.uid);
    if(thisUserModel != null) {
      runApp(MyAppLoggedIn(userModel: thisUserModel, firebaseUser: currentUser));
    }
    else {
      runApp(MyApp());
    }
  }
  else {
    // Not logged in
    runApp(MyApp());
  }
}


// void main()async{
//   // WidgetsFlutterBinding.ensureInitialized();
//   // await Firebase.initializeApp();
//   runApp(MaterialApp(
//     home: ContactListScreen(),
//     debugShowCheckedModeBanner: false,
//   ));
// }

// Not Login
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext Context)=>UiProvider()..init(),
      child: Consumer<UiProvider>(
          builder: (context,UiProvider notifire,child) {
            return MaterialApp(
              themeMode: notifire.isDark? ThemeMode.dark : ThemeMode.light,
              darkTheme: notifire.isDark? notifire.darkTheme : notifire.lightTheme,
              home: Splashscreen(),
              debugShowCheckedModeBanner: false,
            );
          }
      ),
    );
        // routes: {"login": (context) => Mylogin(), "home": (context) => MyHome()},
        //  initialRoute: "login",
       // home: ()
    // );
  }
}


//  Already Login
class MyAppLoggedIn extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;

  const MyAppLoggedIn({Key? key, required this.userModel, required this.firebaseUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext Context)=>UiProvider()..init(),
      child: Consumer<UiProvider>(
          builder: (context,UiProvider notifire,child) {
            return MaterialApp(
              themeMode: notifire.isDark? ThemeMode.dark : ThemeMode.light,
              darkTheme: notifire.isDark? notifire.darkTheme : notifire.lightTheme,
              home: HomePage(userModel: userModel, firebaseUser: firebaseUser),
              debugShowCheckedModeBanner: false,
            );
          }
      ),
    );
  }
}
