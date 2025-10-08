import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:section_bar_navigator_system/feature/settings/data/model/screenmodel.dart';
import 'package:section_bar_navigator_system/feature/settings/presenter/settings_cubit.dart';

class RightArrowPointer extends StatelessWidget {
  final double height;
  final isRightHand;
  final Color color;
  const RightArrowPointer({this.height = 20, this.color = const Color(0x22FF0000), this.isRightHand = true, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: height * 0.6,
      height: height,
      child: CustomPaint(painter: _RightArrowPainter(color, isRightHand)),
    );
  }
}

class _RightArrowPainter extends CustomPainter {
  final Color color;
  final bool isRightHand;
  const _RightArrowPainter(this.color, this.isRightHand);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color;
    final Path path = Path();
    if (isRightHand) {
      // Triangle pointing to the right
      path.moveTo(0, 0);
      path.lineTo(size.width, size.height / 2);
      path.lineTo(0, size.height);
      path.close();
      canvas.drawPath(path, paint);
    } else {
      // Triangle pointing to the left
      path.moveTo(size.width, 0);
      path.lineTo(0, size.height / 2);
      path.lineTo(size.width, size.height);
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom hint widget for displaying the selected tag.
class CustomHintWidget extends StatelessWidget {
  final String text;
  final Color color;
  final double opacity;

  const CustomHintWidget({super.key, required this.text, required this.color, required this.opacity});

  @override
  Widget build(BuildContext context) {
    bool isRightHand = context.read<SettingsCubit>().handnessType == HandnessType.right;
    final size = MediaQuery.of(context).size;
    return AnimatedOpacity(
      opacity: opacity,
      duration: const Duration(milliseconds: 300),
      child: IgnorePointer(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isRightHand) RightArrowPointer(height: 24, color: color.withOpacity(0.6), isRightHand: isRightHand),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))],
              ),
              child: Text(
                text,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            if (isRightHand) RightArrowPointer(height: 24, color: color.withOpacity(0.6), isRightHand: isRightHand),
          ],
        ),
      ),
    );
  }
}

class ScrollHintSelector extends StatefulWidget {
  final List<ScreenModel> listData;
  final ValueChanged<int> onSelected;
  final ScrollController? externalScrollController;
  final List<String> tagList;
  final int currentSelectedIndex;

  const ScrollHintSelector({
    super.key,
    required this.listData,
    required this.onSelected,
    this.externalScrollController,
    required this.currentSelectedIndex,
    required this.tagList,
  });

  @override
  State<ScrollHintSelector> createState() => ScrollHintSelectorState();
}

class ScrollHintSelectorState extends State<ScrollHintSelector> {
  final GlobalKey _listKey = GlobalKey();
  String? _currentSelectedTag;
  String? _currentSelectedName;
  int currentSelectedIndex = 0;

  bool _isSnapping = false;
  Timer? _snapTimer;
  Timer? _hideOverlayTimer;
  double _overlayOpacity = 0;
  double? _selectedCenterOffset;

  late final List<GlobalKey> _itemKeys = List.generate(widget.listData.length, (_) => GlobalKey());

  @override
  void initState() {
    super.initState();
    context.read<SettingsCubit>().controller = widget.externalScrollController ?? ScrollController();
    _currentSelectedName = widget.listData[0].name;
    _currentSelectedTag = widget.tagList.first;
    context.read<SettingsCubit>().controller!.addListener(_onScroll);
    // Create the audio player.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _onScroll();
    });
  }

  @override
  void dispose() {
    _snapTimer?.cancel();
    _hideOverlayTimer?.cancel();
    if (widget.externalScrollController == null) {
      // context.read<SettingsCubit>().controller?.dispose();
    }
    super.dispose();
  }

  void _onScroll() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<SettingsCubit>();
      cubit.isScrolled = true;
      final BuildContext? listContext = _listKey.currentContext;
      if (listContext == null) return;
      final RenderBox box = listContext.findRenderObject() as RenderBox;
      final double listCenter = box.size.height / 2;
      for (int i = 0; i < widget.listData.length; i++) {
        final GlobalKey key = _itemKeys[i];
        final BuildContext? context = key.currentContext;
        if (context == null) continue;
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        final Offset offset = renderBox.localToGlobal(Offset.zero, ancestor: box);
        final double itemCenter = offset.dy + renderBox.size.height / 2;
        if ((itemCenter - listCenter).abs() < renderBox.size.height / 2) {
          final ScreenModel newSelected = widget.listData[i];
          if (_currentSelectedName != newSelected.name) {
            cubit.screenList[cubit.currentSelectedIndex].currentSelectedScreenIndex = 0;
            _currentSelectedName = newSelected.name;
            _currentSelectedTag = widget.tagList[i];
            if (cubit.vibrationEnabled) {
              HapticFeedback.vibrate();
            }
            currentSelectedIndex = widget.listData.indexWhere((element) => element.name == _currentSelectedName);
            widget.onSelected(currentSelectedIndex);

            _selectedCenterOffset = itemCenter;
            if (mounted) setState(() {});
          }
          break;
        }
      }
      cubit.setCurrentScrollPosition(cubit.controller?.offset);
    });
    showWidgetOnScroll();
  }

  void showWidgetOnScroll() {
    if (mounted) {
      setState(() {
        _overlayOpacity = 1.0;
      });
    }

    _hideOverlayTimer?.cancel();
    _hideOverlayTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _overlayOpacity = 0.0;
        });
        if (!context.read<SettingsCubit>().isFloatingScreen) {
          final size = MediaQuery.of(context).size;
          context.read<SettingsCubit>().setFloatingScreenState(size.width);
        }
      }
    });
  }

  void hideOverlay() {
    if (mounted) {
      setState(() {
        _overlayOpacity = 0.0;
      });
      if (!context.read<SettingsCubit>().isFloatingScreen) {
        final size = MediaQuery.of(context).size;
        context.read<SettingsCubit>().setFloatingScreenState(size.width);
      }
    }
  }

  Future<void> _snapToNearestTag(double containerHeight) async {
    if (!mounted) return;
    final BuildContext? listContext = _listKey.currentContext;
    if (listContext == null) return;

    final RenderBox box = listContext.findRenderObject() as RenderBox;
    final double listCenter = box.size.height / 2;

    double minDistance = double.infinity;
    int nearestIndex = 0;

    for (int i = 0; i < widget.listData.length; i++) {
      final GlobalKey key = _itemKeys[i];
      final BuildContext? context = key.currentContext;
      if (context == null) continue;

      final RenderBox renderBox = context.findRenderObject() as RenderBox;
      final Offset offset = renderBox.localToGlobal(Offset.zero, ancestor: box);
      final double itemCenter = offset.dy + renderBox.size.height / 2;
      final double distance = (itemCenter - listCenter).abs();

      if (distance < minDistance) {
        minDistance = distance;
        nearestIndex = i;
      }
    }

    final GlobalKey key = _itemKeys[nearestIndex];
    final BuildContext? context = key.currentContext;
    if (context != null) {
      final RenderBox renderBox = context.findRenderObject() as RenderBox;
      final Offset offset = renderBox.localToGlobal(Offset.zero, ancestor: box);
      final double itemCenter = offset.dy + renderBox.size.height / 2;
      final double targetOffset = context.read<SettingsCubit>().controller!.offset + (itemCenter - listCenter);

      if ((context.read<SettingsCubit>().controller!.offset - targetOffset).abs() > 8.0) {
        _isSnapping = true;
        if (context.read<SettingsCubit>().vibrationEnabled) {
          HapticFeedback.vibrate();
        }

        await context.read<SettingsCubit>().controller!.animateTo(targetOffset, duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
        _isSnapping = false;
      }
    }
  }

  double _getItemHeight(BuildContext context) {
    const TextStyle textStyle = TextStyle(fontSize: 18);
    final TextPainter textPainter = TextPainter(
      text: const TextSpan(text: 'A', style: textStyle),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    return textPainter.height + 32;
  }

  double _calculateHintWidth(String text) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    final double textWidth = textPainter.width;
    const double paddingHorizontal = 16.0 * 2;
    const double arrowWidth = 24.0 * 0.6;
    return textWidth + paddingHorizontal + arrowWidth;
  }

  double _calculateHintHalfHeight() {
    final TextPainter textPainter = TextPainter(
      text: const TextSpan(
        text: 'A',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    final double textHeight = textPainter.height;
    const double paddingVertical = 8.0 * 2;
    final double hintHeight = textHeight + paddingVertical;
    return hintHeight / 2;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Visibility(
      visible: size.shortestSide > 600 ? true : !context.watch<SettingsCubit>().isFloatingScreen,
      child: Align(
        alignment: context.watch<SettingsCubit>().handnessType == HandnessType.right ? Alignment.centerRight : Alignment.centerLeft,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double containerHeight = constraints.maxHeight;
            final double itemHeight = _getItemHeight(context);
            return Container(
              width: 60,
              height: containerHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification notification) {
                      if (_isSnapping) return false;
                      showWidgetOnScroll();
                      if (notification is ScrollEndNotification ||
                          (notification is UserScrollNotification && notification.direction == ScrollDirection.idle)) {
                        _snapTimer?.cancel();
                        _snapTimer = Timer(const Duration(milliseconds: 300), () {
                          _snapToNearestTag(containerHeight);
                        });
                      }
                      return false;
                    },
                    child:ListView.builder(
                      // physics: NeverScrollableScrollPhysics(),
  key: _listKey,
  controller: context.watch<SettingsCubit>().controller,
  itemCount: widget.tagList.length,
  padding: EdgeInsets.only(
    top: containerHeight / 2 - itemHeight / 2,
    bottom: containerHeight / 2 - itemHeight / 2,
  ),
  itemBuilder: (BuildContext context, int index) {
    final String tag = widget.tagList[index];
    final bool selected = widget.tagList[index] == _currentSelectedTag;
    
    return GestureDetector(
      onTap: () async {
        final GlobalKey key = _itemKeys[index];
        final BuildContext? context = key.currentContext;
        if (context != null) {
          final BuildContext? listContext = _listKey.currentContext;
          if (listContext != null) {
            final RenderBox box = listContext.findRenderObject() as RenderBox;
            final RenderBox renderBox = context.findRenderObject() as RenderBox;
            final Offset offset = renderBox.localToGlobal(Offset.zero, ancestor: box);
            final double itemCenter = offset.dy + renderBox.size.height / 2;
            final double listCenter = box.size.height / 2;
            final double scrollOffset = context.read<SettingsCubit>().controller!.offset + (itemCenter - listCenter);
            _isSnapping = true;
            await context.read<SettingsCubit>().controller!.animateTo(
              scrollOffset,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
            );
            _isSnapping = false;
            if (mounted) {
              setState(() {
                _currentSelectedTag = widget.tagList[index];
                _currentSelectedName = widget.listData[index].name;
                currentSelectedIndex = index;
              });
            }
            widget.onSelected(index);
            showWidgetOnScroll();
          }
        }
      },
      behavior: HitTestBehavior.translucent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          key: _itemKeys[index],
          alignment: Alignment.center,
          height:selected? 48:38,
          width: selected? 48:38,
          decoration: BoxDecoration(
            // Simple color scheme
            color: selected 
              ? widget.listData[index].tabColor 
              : widget.listData[index].tabColor.withOpacity(0.1),
            
            // Clean circular shape
            shape: BoxShape.circle,
             
            // Subtle shadow for depth
            boxShadow: selected 
              ?  [
                    BoxShadow(
                      color: widget.listData[index].tabColor.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                      spreadRadius: 2,
                    ),
                    BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(-2, -2),
                    ),
                  ]
              : [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
          ),
          child: Text(
            tag,
            style: TextStyle(
              fontSize: selected ? 18 : 16,
              fontWeight:FontWeight.bold,
              color: selected 
                ? Colors.white 
                : widget.listData[index].tabColor,
            ),
          ),
        ),
      ),
    );
  },
)
                  ),
                  if (_currentSelectedName != null)
                    if (context.watch<SettingsCubit>().handnessType == HandnessType.right)
                      Positioned(
                        left: -_calculateHintWidth(_currentSelectedName!),
                        top: (containerHeight / 2) - _calculateHintHalfHeight(),
                        child: CustomHintWidget(
                          opacity: _overlayOpacity,
                          text: _currentSelectedName!,
                          color: widget.listData[currentSelectedIndex].tabColor,
                        ),
                      ),
                  if (context.watch<SettingsCubit>().handnessType == HandnessType.left)
                    Positioned(
                      right: -_calculateHintWidth(_currentSelectedName!),
                      top: (containerHeight / 2) - _calculateHintHalfHeight(),
                      child: CustomHintWidget(
                        opacity: _overlayOpacity,
                        text: _currentSelectedName!,
                        color: widget.listData[currentSelectedIndex].tabColor,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

