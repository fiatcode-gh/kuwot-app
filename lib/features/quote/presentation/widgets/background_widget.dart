import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuwot/features/quote/presentation/bloc/background_bloc.dart';
import 'package:kuwot/features/quote/presentation/widgets/background_painter.dart';

class BackgroundWidget extends StatelessWidget {
  const BackgroundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BackgroundBloc, BackgroundState>(
      builder: (context, state) {
        if (state is BackgroundReady) {
          return CustomPaint(
            painter: BackgroundPainter(state.style),
            size: Size.infinite,
          );
        }
        return const ColoredBox(color: Colors.black);
      },
    );
  }
}
