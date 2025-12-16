import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'presentation/screens/quiz_screen_provider.dart';
import 'data/providers/quiz_provider.dart';
import 'business_logic/quiz/quiz_bloc.dart';
import 'business_logic/quiz/quiz_event.dart';
import 'presentation/screens/quiz_screen_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'presentation/screens/weather_screen.dart';

void main() {
  runApp(
    // We inject the Provider at the root of the app
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => QuizProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TP2 Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr', ''), // French
        Locale('en', ''), // English fallback
      ],

      //TP2-Exercice1-Q1: Providers
      //=========================================================================================================================
      // home: const QuizScreenProvider(),
      //=========================================================================================================================

      
      
      
      //TP2-Exercice1-Q2: BLoC
      //=========================================================================================================================
      // home: BlocProvider(
      //   create: (context) => QuizBloc()..add(LoadQuiz()),
      //   child: const QuizScreenBloc(),
      // ),
      //=========================================================================================================================

      
      
      //TP2-Exercice2-Q2
      //=========================================================================================================================
      home: const WeatherScreen(),
      //=========================================================================================================================

      
    );
  }
}
