import 'package:flutter/material.dart';

class SizeReportingWidget extends StatefulWidget {
  final Widget child;
  final ValueChanged<Size> onSizeChange;

  const SizeReportingWidget({
    Key? key,
    required this.child,
    required this.onSizeChange,
  }) : super(key: key);

  @override
  State<SizeReportingWidget> createState() => _SizeReportingWidgetState();
}

class _SizeReportingWidgetState extends State<SizeReportingWidget> {
  Size? _oldSize;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _notifySize());
    return widget.child;
  }

  void _notifySize() {
    if (!mounted) {
      return;
    }
    final size = context.size;
    if (_oldSize != size && size != null) {
      _oldSize = size;
      widget.onSizeChange(size);
    }
  }
}

class ExpandablePageView extends StatefulWidget {
  final List<Widget> children;
  final Function(int)? onPageChanged;
  final PageController pageController;
  final GlobalKey<FormFieldState>? pageKey;

  const ExpandablePageView({
    Key? key,
    required this.children, this.onPageChanged, required this.pageController, this.pageKey,
  }) : super(key: key);

  @override
  State<ExpandablePageView> createState() => _ExpandablePageViewState();
}

class _ExpandablePageViewState extends State<ExpandablePageView>
    with TickerProviderStateMixin {

  late List<double> _heights;
  int _currentPage = 0;


  double get _currentHeight => _heights[_currentPage];

  @override
  void initState() {
    _heights = widget.children.map((e) => 0.0).toList();
    super.initState();

    widget.pageController.addListener(() {
        final newPage = widget.pageController.page?.round() ?? 0;
        if (_currentPage != newPage) {
            _currentPage = newPage;
            if(mounted){
          setState(() {});
        }
      }
      });

  }


  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      key: widget.pageKey,
      curve: Curves.easeInOutCubic,
      duration: const Duration(milliseconds: 100),
      tween: Tween<double>(begin: _heights[0], end: _currentHeight),
      builder: (context, value, child) => SizedBox(height: value, child: child),
      child: PageView(
        controller: widget.pageController,
        onPageChanged: widget.onPageChanged,
        children: _sizeReportingChildren
            .asMap() //
            .map((index, child) => MapEntry(index, child))
            .values
            .toList(),
      ),
    );
  }

  List<Widget> get _sizeReportingChildren => widget.children
      .asMap() //
      .map(
        (index, child) => MapEntry(
      index,
      OverflowBox(
        //needed, so that parent won't impose its constraints on the children, thus skewing the measurement results.
        minHeight: 0,
        maxHeight: double.infinity,
        alignment: Alignment.topCenter,
        child: SizeReportingWidget(
          onSizeChange: (size) =>
              setState(() => _heights[index] = size.height),
          child: Align(child: child),
        ),
      ),
    ),
  )
      .values
      .toList();
}