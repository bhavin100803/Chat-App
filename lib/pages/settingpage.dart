import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/provider.dart';

class Home1 extends StatelessWidget {
  const Home1({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = context.watch<UiProvider>();
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<UiProvider>(
          builder: (context , UiProvider notifier,child) {
            return Column(
              children: [
                ListTile(
                  // leading: Icon(Icons.dark_mode),
                  title: Text("Dark Mode"),
                  trailing: Switch(
                      value: notifier.isDark,
                      onChanged: (value)=>theme.changeTheme()
                  ),
                )
              ],
            );
          }
      ),
    );
  }
}