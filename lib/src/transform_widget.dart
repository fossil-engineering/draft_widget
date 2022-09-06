part of 'draft_widget.dart';

class _TransformWidget extends StatelessWidget {
  const _TransformWidget({
    required this.id,
    required this.transformState,
    required this.focusPosition,
    required this.focusAngle,
    required this.focusState,
    required this.hoverPosition,
    required this.hoverAngle,
    required this.hoverState,
    required this.transformingState,
    required this.position,
    required this.angle,
    required this.child,
    required this.onEnd,
  });

  final int id;
  final ValueNotifier<Matrix4> transformState;
  final ValueNotifier<Rect?> focusPosition;
  final ValueNotifier<double> focusAngle;
  final ValueNotifier<int> focusState;
  final ValueNotifier<Rect?> hoverPosition;
  final ValueNotifier<double> hoverAngle;
  final ValueNotifier<int> hoverState;
  final ValueNotifier<bool> transformingState;
  final Rect position;
  final double angle;
  final Widget child;
  final VoidCallback onEnd;

  @override
  Widget build(BuildContext context) {
    return Positioned.fromRect(
      rect: position,
      child: Transform.rotate(
        angle: angle,
        child: GestureDetector(
          onTap: () {
            if (focusState.value != id) {
              focusState.value = id;
              focusPosition.value = position;
              focusAngle.value = angle;
            }
          },
          onPanUpdate: (details) {
            if (id != focusState.value) return;
            transformingState.value = true;
            hoverState.value = noPosition;
            hoverPosition.value = null;
            transformState.value = Matrix4.copy(transformState.value)
              ..translate(details.delta.dx, details.delta.dy);
          },
          onPanEnd: (_) {
            if (id == focusState.value) onEnd();
          },
          child: ValueListenableBuilder<Matrix4>(
            valueListenable: transformState,
            builder: (_, transform, child) {
              return id == focusState.value
                  ? Transform(transform: transform, child: child)
                  : child!;
            },
            child: MouseRegion(
              child: child,
              onEnter: (_) {
                if (hoverState.value != id &&
                    hoverState.value != focusState.value &&
                    !transformingState.value) {
                  hoverState.value = id;
                  hoverPosition.value = position;
                  hoverAngle.value = angle;
                }
              },
              onExit: (_) {
                if (hoverState.value == id) {
                  hoverState.value = noPosition;
                  hoverPosition.value = null;
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
