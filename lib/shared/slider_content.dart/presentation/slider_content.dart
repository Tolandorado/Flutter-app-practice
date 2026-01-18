import 'package:flutter/material.dart';

class SliderContent extends StatefulWidget {
  final List<Widget> children;

  const SliderContent({super.key, required this.children});

  @override
  State<SliderContent> createState() => OnboardContentState();
}

class OnboardContentState extends State<SliderContent> {
  late final PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void goTo(int page, {bool animate = true}) {
    final currentPage = _controller.page?.round() ?? _controller.initialPage;

    if (page < 0 || page > widget.children.length - 1 || page == currentPage) {
      return;
    }

    animate
        ? _controller.animateToPage(
            page,
            duration: Duration(milliseconds: 300),
            curve: Curves.ease,
          )
        : _controller.jumpToPage(page);
  }

  void next() => goTo((_controller.page ?? 0).round() + 1);

  void prev() => goTo((_controller.page ?? 0).round() - 1);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            children: [
              const SizedBox(height: 20),
              Expanded(
                child: PageView(
                  controller: _controller,
                  children: widget.children,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
