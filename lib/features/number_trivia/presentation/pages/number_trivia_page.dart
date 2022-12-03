import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_with_clean_architecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter_with_clean_architecture/features/number_trivia/presentation/widgets/loading_widget.dart';
import 'package:flutter_with_clean_architecture/features/number_trivia/presentation/widgets/message_display.dart';
import 'package:flutter_with_clean_architecture/features/number_trivia/presentation/widgets/trivia_display.dart';
import 'package:flutter_with_clean_architecture/injection_container.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Number Trivia'), centerTitle: true),
      body: buildBody(context),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(height: 10),
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  if (state is NumberTriviaEmptyState) {
                    return const MessageDisplay(message: 'Start searching!');
                  } else if (state is NumberTriviaLoadingState) {
                    return const LoadingWidget();
                  } else if (state is NumberTriviaLoadedState) {
                    return TriviaDisplay(trivia: state.trivia);
                  } else if (state is NumberTriviaErrorState) {
                    return MessageDisplay(message: state.message);
                  } else {
                    return const MessageDisplay(message: 'No State Error!');
                  }
                },
              ),
              const SizedBox(height: 10),
              const TriviaControls(),
            ],
          ),
        ),
      ),
    );
  }
}

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    super.key,
  });

  @override
  State<TriviaControls> createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Input a number',
            isDense: true,
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: addConcrete,
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(double.maxFinite, 36),
                ),
                child: const Text('Search'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton(
                onPressed: addRandom,
                style: OutlinedButton.styleFrom(
                  fixedSize: const Size(double.maxFinite, 36),
                ),
                child: const Text('Search'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void addConcrete() {
    context.read<NumberTriviaBloc>().add(GetTriviaForConcreteNumber(controller.text));
    controller.clear();
  }

  void addRandom() {
    context.read<NumberTriviaBloc>().add(const GetTriviaForRandomNumber());
    controller.clear();
  }
}
