// import 'package:flutter/material.dart';

// // ignore: must_be_immutable
// class DropdownWidget extends StatefulWidget {
//   DropdownWidget(
//       {super.key,
//       required this.dropdownList,
//       required this.dropdownValue,
//       required this.callback});

//   String dropdownValue;
//   var dropdownList;
//   Function(String dropvalue) callback;

//   @override
//   State<DropdownWidget> createState() => _DropdownWidgetState();
// }

// class _DropdownWidgetState extends State<DropdownWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: DropdownButton(
//         value: widget.dropdownValue,
//         icon: const Icon(Icons.keyboard_arrow_down),
//         items: widget.dropdownList.map((items) {
//           return DropdownMenuItem(
//             value: items,
//             child: Text(
//               items,
//               style:
//                   Theme.of(context).textTheme.displayLarge!.copyWith(fontSize: 16),
//             ),
//           );
//         }).toList(),
//         underline: Container(),
//         iconEnabledColor: const Color(0xFF555555),
//         isExpanded: true,
//         elevation: 0,
//         onChanged: (newValue) {
//           setState(() {
//             widget.dropdownValue = "$newValue";
//             widget.callback(newValue.toString());
//           });
//         },
//       ),
//     );
//   }
// }
