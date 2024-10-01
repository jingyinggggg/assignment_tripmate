// import 'package:assignment_tripmate/firebase_options.dart';
// import 'package:flutter/material.dart';
// import 'package:assignment_tripmate/screens/welcome.dart';
// import 'package:firebase_core/firebase_core.dart';

// void main() async{
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
//   // Disable App Check for Firebase Storage
//   // FirebaseStorage.instance.useStorageEmulator('localhost', 9199); 

//   runApp(const MainApp());
// }

// class MainApp extends StatelessWidget {
//   const MainApp({super.key});

//   @override
//   Widget build (BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         scaffoldBackgroundColor: const Color(0xFFEDF2F6),
//       ),
//       home: const WelcomeScreen(),
//     );
//   }
// }

import 'dart:async';
import 'package:assignment_tripmate/firebase_options.dart';
import 'package:assignment_tripmate/screens/login.dart';
import 'package:assignment_tripmate/screens/tarvel_agent_sign_up.dart';
import 'package:assignment_tripmate/screens/user/homepage.dart';
import 'package:assignment_tripmate/screens/user/viewTourDetails.dart';
import 'package:assignment_tripmate/screens/user_sign_up.dart';
import 'package:assignment_tripmate/screens/welcome.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:app_links/app_links.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  Future<void> _initDeepLinks() async {
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      debugPrint('onAppLink: $uri');
      _handleDeepLink(uri);
    });
  }

  void _handleDeepLink(Uri uri) {
    // Parse the URI to navigate to the correct screen
    if (uri.pathSegments.isNotEmpty && uri.host == 'tripmate.com') {
      final path = uri.pathSegments[0];
      if (path == 'viewTourDetails') {
        final userId = uri.pathSegments[1];
        final countryName = uri.pathSegments[2];
        final cityName = uri.pathSegments[3];
        final tourId = uri.pathSegments[4];
        final fromAppLink = uri.pathSegments[5];

        // Navigate to ViewTourDetailsScreen
        context.go('/viewTourDetails/$userId/$countryName/$cityName/$tourId/$fromAppLink');
      }
    }
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GoRouter router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const WelcomeScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/userRegister',
          builder: (context, state) => const UserSignUpScreen(),
        ),
        GoRoute(
          path: '/travelAgentRegister',
          builder: (context, state) => const TravelAgentSignUpScreen(),
        ),
        GoRoute(
          path: '/viewTourDetails/:userId/:countryName/:cityName/:tourId/:fromAppLink',
          builder: (context, state) {
            final userId = state.pathParameters['userId']!;
            final countryName = state.pathParameters['countryName']!;
            final cityName = state.pathParameters['cityName']!;
            final tourId = state.pathParameters['tourId']!;
            final fromAppLink = state.pathParameters['fromAppLink']!;

            return ViewTourDetailsScreen(
              userId: userId,
              countryName: countryName,
              cityName: cityName,
              tourID: tourId,
              fromAppLink: fromAppLink, // Pass the parsed value
            );
          },
        ),
      ],
      errorBuilder: (context, state) {
        return Scaffold(
          body: Center(child: Text('Error: ${state.error}')),
        );
      },
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}


