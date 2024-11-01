import "package:flutter/material.dart";

class XAxisScrollableChart extends StatefulWidget {
  final double minX;
  final double maxX;
  final int visibleXSize;
  final Widget Function(double minX, double maxX) itemBuilder;
  final double xScrollOffset;

  const XAxisScrollableChart({
    super.key,
    required this.minX,
    required this.maxX,
    required this.itemBuilder,
    this.visibleXSize = 5,
    this.xScrollOffset = 0.01,
  });

  @override
  State<XAxisScrollableChart> createState() => _LinePlotState();
}

class _LinePlotState extends State<XAxisScrollableChart> {
  late double minX;
  late double maxX;
  late double xRange;
  late double currentMinX;
  late double currentMaxX;
  late int visibleRange;

  @override
  void initState() {
    super.initState();
    _handleX();
  }

  @override
  void didUpdateWidget(covariant XAxisScrollableChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.minX != oldWidget.minX || widget.maxX != oldWidget.maxX) {
      setState(_handleX);
    }
  }

  void _handleX() {
    visibleRange = widget.visibleXSize - 1;
    minX = widget.minX;
    maxX = widget.maxX;
    xRange = maxX - minX;
    currentMaxX = maxX;
    currentMinX = maxX - visibleRange;
    if (currentMinX < minX) {
      currentMinX = minX;
      currentMaxX = minX + visibleRange;
    }
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onHorizontalDragUpdate: (dragUpdateDetails) {
          final primaryDelta = dragUpdateDetails.primaryDelta ?? 0.0;
          var tempMinX = currentMinX;
          var tempMaxX = currentMaxX;
          if (primaryDelta.isNegative) {
            tempMinX += xRange * widget.xScrollOffset;
            tempMaxX += xRange * widget.xScrollOffset;
          } else {
            tempMinX -= xRange * widget.xScrollOffset;
            tempMaxX -= xRange * widget.xScrollOffset;
          }

          if (tempMinX < minX) {
            setState(() {
              currentMinX = minX;
            });
            return;
          }

          if (tempMaxX > maxX) {
            setState(() {
              currentMaxX = maxX;
            });
            return;
          }

          setState(() {
            currentMinX = tempMinX;
            currentMaxX = tempMaxX;
          });
        },
        child: widget.itemBuilder(currentMinX, currentMaxX),
      );
}
