import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smct/features/game/presentation/bloc/game_bloc.dart';

class NumPad extends StatelessWidget {
  NumPad({Key? key}) : super(key: key);

  final numPad = ['7', '8', '9', '4', '5', '6', '1', '2', '3'];

  @override
  Widget build(BuildContext context) {
    var textEditingController = context.watch<GameBloc>().textEditingController;
    var buttonsTextStyle = Theme.of(context)
        .textTheme
        .displaySmall!
        .copyWith(color: Theme.of(context).colorScheme.onSecondary);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 2,
      padding: const EdgeInsets.symmetric(
        horizontal: 50,
      ),
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        crossAxisSpacing: 20,
        mainAxisSpacing: 10,
        children: [
          for (var i in this.numPad)
            NumPadBtn(
              txt_edit_controller: textEditingController,
              buttons_text_style: buttonsTextStyle,
              text: i,
            ),
          ElevatedButton(
            onPressed: () {
              context.read<GameBloc>().textEditingController.clear();
            },
            child: Icon(
              Icons.clear,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 42,
            ),
            style: ElevatedButton.styleFrom(primary: Colors.redAccent),
          ),
          NumPadBtn(
              txt_edit_controller: textEditingController,
              buttons_text_style: buttonsTextStyle,
              text: '0'),
          ElevatedButton(
            onPressed: () {
              if (textEditingController.text != '') {
                context
                    .read<GameBloc>()
                    .add(GameSubmitAnswer(textEditingController.text));
                textEditingController.clear();
              }
            },
            child: Icon(
              Icons.check,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 42,
            ),
            style: ElevatedButton.styleFrom(primary: Colors.greenAccent),
          ),
        ],
      ),
    );
  }
}

class NumPadBtn extends StatelessWidget {
  const NumPadBtn({
    Key? key,
    required this.txt_edit_controller,
    required this.buttons_text_style,
    required this.text,
  }) : super(key: key);

  final TextEditingController txt_edit_controller;
  final TextStyle buttons_text_style;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        this.txt_edit_controller.text += text;
      },
      child: Text(
        text,
        style: buttons_text_style,
      ),
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).colorScheme.secondary,
        onPrimary: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
    );
  }
}
