// // ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, file_names, library_private_types_in_public_api

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class LanguageButton extends StatelessWidget {
//   LanguageButton({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<LocaleCubit, LocaleState>(
//       builder: (context, state) {
//         final cubit = LocaleCubit.of(context);

//         return Material(
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(15),
//               color: Colors.red,
//             ),
//             child: DropdownButton<Locale>(
//               style: TextStyle(color: Colors.white),
//               icon: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Icon(Icons.language),
//               ),
//               iconEnabledColor: Colors.white,
//               underline: Container(),
//               dropdownColor: Colors.red,
//               items: [
//                 DropdownMenuItem(
//                   value: Locale('en'),
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       'English',
//                     ),
//                   ),
//                 ),
//                 DropdownMenuItem(
//                   value: Locale('ar'),
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       'العربية',
//                     ),
//                   ),
//                 ),
//               ],
//               onChanged: (Locale? v) {
//                 if (v!.languageCode == "en" && !AppLocalizations.of(context)!.isEnLocale) {
//                   cubit.toEnglish();
//                 } else {
//                   cubit.toArabic();
//                 }
//               },
//               value: cubit.locale,
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
