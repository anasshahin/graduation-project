
import 'package:chat_app/services/news_provider.dart';
import 'package:chat_app/services/provider_management.dart';
import 'package:chat_app/screens/auth.dart';

import 'package:chat_app/screens/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,

  );

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<AdvertisementProvider>(create: (_)=>AdvertisementProvider(),
     ),
    ChangeNotifierProvider<NewsProvider>(create: (_)=>NewsProvider(),
     ),
  ],
    child:const MyApp(),
  ));}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green.shade900,
            primary: Colors.green.shade900,
          background:Colors.white,onPrimaryContainer: Colors.green.shade900,

        ),
     fontFamily: "Lemon",
     focusColor :Colors.green.shade900,
          //textTheme: TextTheme(),
          cardColor: const Color(0xff0F2310),
buttonTheme: ButtonThemeData(colorScheme: ColorScheme.fromSeed(
    primary: Colors.green.shade900 , seedColor:Colors.green.shade900 )
   ),
      //  navigationBarTheme: NavigationBarThemeData(co),
        useMaterial3: true
      ),
      //home:const MainBooksScreen(),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
            if(snapshot.connectionState==ConnectionState.waiting)
            {const SplashScreen();
            }
            if(snapshot.hasData){
              return  const MainScreenApp();
            }else {return const AuthScreen();}
      },
      ),

    );
  }
}


