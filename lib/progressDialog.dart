// import 'package:flutter/material.dart';
// import 'package:progress_dialog/progress_dialog.dart';
//
// ProgressDialog pr;
//
// void main() {
//   runApp(MaterialApp(
//     home: MyApp(),
//   ));
// }
//
// class MyApp extends StatelessWidget {
//   double percentage = 0.0;
//
//   @override
//   Widget build(BuildContext context) {
//
//     pr = new ProgressDialog(context,type: ProgressDialogType.Normal);
//
//     pr.style(message: 'Showing some progress...');
//
//     //Optional
//     pr.style(
//       message: 'Please wait...',
//       borderRadius: 10.0,
//       backgroundColor: Colors.white,
//       progressWidget: CircularProgressIndicator(),
//       elevation: 10.0,
//       insetAnimCurve: Curves.easeInOut,
//       progressTextStyle: TextStyle(
//           color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
//       messageTextStyle: TextStyle(
//           color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
//     );
//
//     return Scaffold(
//       body: Center(
//         child: RaisedButton(
//             child: Text(
//               'Show Dialog',
//               style: TextStyle(color: Colors.white),
//             ),
//             color: Colors.blue,
//             onPressed: () {
//               pr.show();
//
//               Future.delayed(Duration(seconds: 10)).then((onValue){
//                 print("PR status  ${pr.isShowing()}" );
//                 if(pr.isShowing())
//                   pr.hide().then((isHidden) {
//                     print(isHidden);
//                   });
//                 print("PR status  ${pr.isShowing()}" );
//               });
//
//             }),
//       ),
//     );
//   }
// }