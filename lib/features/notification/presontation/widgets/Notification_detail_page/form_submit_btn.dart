import 'package:flutter/material.dart';

class FormSubmitBtn extends StatelessWidget {
  final void Function() onPressed;
  final bool isUpdatePost;

  const FormSubmitBtn({
    Key? key,
    required this.onPressed,
    required this.isUpdatePost,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(style:ButtonStyle( backgroundColor: MaterialStateProperty.resolveWith<Color?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        // Return the color for the disabled state, e.g., gray.
        return Colors.grey;
      } else {
        // Return the color for the enabled state.
        return Color(0xFFEB5F52);
      }
    },
  ),),
        onPressed: onPressed,
        icon: isUpdatePost ? Icon(Icons.edit,color:  Color.fromARGB(255, 247, 243, 243),) : Icon(Icons.add),
        label: Text(isUpdatePost ? "Update" : "Add"));
  }
}