import 'package:flutter/material.dart';

Future<void> showSubtitleEditSheet(
  BuildContext context,
) {
  return showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      isDismissible: true,
      builder: (BuildContext context) {
        return const _SubtitleEditSheet();
      });
}

class _SubtitleEditSheet extends StatelessWidget {
  const _SubtitleEditSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildModal(context);
  }

  Widget _buildModal(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.longestSide - 64,
        margin: const EdgeInsets.only(top: 64),
        decoration: const BoxDecoration(
          color: Color.fromARGB(109, 0, 0, 0),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: _buildBody());
  }

  Widget _buildBody() {
    return Column(
      children: const [
        SizedBox(height: 10),
        Text(
          'テキストを編集',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
