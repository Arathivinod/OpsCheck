// import 'package:flutter/material.dart';
// import 'package:opscheck/screens/loginpage.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({Key? key}) : super(key: key);

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     gotoLogin();
//     super.initState();
//   }
  

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'OpsCheck',
//               style: TextStyle(
//                 color: Colors.blueAccent,
//                 fontSize: 26,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(
//                 height: 20), // Add spacing between text and progress indicator
//             SizedBox(
//               width:
//                   300, // Set the width of the SizedBox to control the size of the LinearProgressIndicator
//               child: LinearProgressIndicator(
//                 backgroundColor: Colors.blueAccent,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   Future<void> gotoLogin() async {
//     await Future.delayed(const Duration(seconds: 3));
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (ctx) => LoginScreen(changeLocale: _changeLocale),
//       ),
//     );
//   }
// }
