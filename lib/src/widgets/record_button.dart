import 'package:flutter/material.dart';

class RecordButton extends StatelessWidget {
  const RecordButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: const Icon(Icons.mic),
      style: TextButton.styleFrom(
        side: BorderSide.none,
        backgroundColor: Theme.of(context).primaryColor,
        shape: const CircleBorder(),
        minimumSize: const Size(
          50,
          50,
        ),
      ),
    );
  }
}
