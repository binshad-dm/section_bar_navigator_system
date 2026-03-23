import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:section_bar_navigator_system/core/widgets/index_bar/index_bar_components.dart';
import 'package:section_bar_navigator_system/feature/settings/presenter/settings_cubit.dart';
import 'package:section_bar_navigator_system/feature/settings/presenter/state/settings_state.dart';

/// The main home screen widget for the app.
class HomeScreen extends StatefulWidget {
  final bool isDisableIndexBar;
  final bool showAppBar;
  const HomeScreen({
    super.key,
    this.isDisableIndexBar = false,
    this.showAppBar = true,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _hintSelectorController = ScrollController();
  final GlobalKey<ScrollHintSelectorState> _hintSelectorKey =
      GlobalKey<ScrollHintSelectorState>();

  int _pointerCount = 0;
  List<String> tagList = [];
  final Map<int, Offset> _lastPointerPositions = {};
  final Map<int, Offset> _lastPointerDeltas = {};

  @override
  void initState() {
    // tagList calculation moved to SettingsCubit
    super.initState();
  }

  @override
  void dispose() {
    _hintSelectorController.dispose();
    super.dispose();
  }

  _handlePointerDown(PointerDownEvent event, isCheckNeeded) {
    if (isCheckNeeded &&
        context.read<SettingsCubit>().isFloatingScreen &&
        _pointerCount == 2) {
      context.read<SettingsCubit>().setNormalScreenState(context);
    }
    _pointerCount++;
    _lastPointerPositions[event.pointer] = event.position;
    _lastPointerDeltas[event.pointer] = Offset.zero;
  }

  _handlePointerUp(PointerUpEvent event, isCheckNeeded) {
    if (isCheckNeeded &&
        context.read<SettingsCubit>().isFloatingScreen &&
        _pointerCount == 2) {
      context.read<SettingsCubit>().setNormalScreenState(context);
    }
    _pointerCount = (_pointerCount - 1).clamp(0, 2);
    _lastPointerPositions.remove(event.pointer);
    _lastPointerDeltas.remove(event.pointer);
  }

  _handlePointerMove(PointerMoveEvent event, isCheckNeeded) {
    if (isCheckNeeded &&
        context.read<SettingsCubit>().isFloatingScreen &&
        _pointerCount == 2) {
      context.read<SettingsCubit>().setNormalScreenState(context);
    }
    if (_pointerCount == 2 && _lastPointerPositions.length == 2) {
      final int pointerA = _lastPointerPositions.keys.first;
      final int pointerB = _lastPointerPositions.keys.last;

      final Offset lastPos = _lastPointerPositions[event.pointer]!;
      final Offset delta = event.position - lastPos;
      _lastPointerDeltas[event.pointer] = delta;
      _lastPointerPositions[event.pointer] = event.position;

      final Offset deltaA = _lastPointerDeltas[pointerA]!;
      final Offset deltaB = _lastPointerDeltas[pointerB]!;

      if (deltaA.dy.abs() > deltaA.dx.abs() &&
          deltaB.dy.abs() > deltaB.dx.abs() &&
          deltaA.dy.sign == deltaB.dy.sign &&
          deltaA.dy.abs() > 0 &&
          deltaB.dy.abs() > 0) {
        final double avgDelta = (deltaA.dy + deltaB.dy) / 2;
        final double newOffset = _hintSelectorController.offset + avgDelta;
        if (_hintSelectorController.hasClients) {
          _hintSelectorController.jumpTo(
            newOffset.clamp(
              _hintSelectorController.position.minScrollExtent,
              _hintSelectorController.position.maxScrollExtent,
            ),
          );
        }
      }
    }
  }

  void _handleScreenTap() {
    _hintSelectorKey.currentState?.hideOverlay();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.shortestSide;
    final cubit = context.read<SettingsCubit>();

    return Scaffold(
      backgroundColor: const Color.fromARGB(248, 255, 254, 254),
      appBar: widget.showAppBar
          ? PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: BlocSelector<SettingsCubit, SettingsState, int>(
                selector: (state) => cubit.currentSelectedIndex,
                builder: (context, selectedIndex) {
                  return AppBar(
                    centerTitle: true,
                    backgroundColor: cubit.screenList[selectedIndex].tabColor,
                    title: Text(
                      cubit.screenList[selectedIndex].name,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            )
          : null,
      body: Stack(
        children: [
          Listener(
            onPointerDown: (event) {
              _handlePointerDown(event, size < 600);
            },
            onPointerUp: (event) {
              _handlePointerUp(event, size < 600);
            },
            onPointerCancel: (_) {
              _pointerCount = 0;
              _lastPointerPositions.clear();
              _lastPointerDeltas.clear();
            },
            onPointerMove: (event) {
              _handlePointerMove(event, size < 600);
            },
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _handleScreenTap,
              child: BlocSelector<SettingsCubit, SettingsState, int>(
                selector: (state) => cubit.currentSelectedIndex,
                builder: (context, selectedIndex) {
                  return Row(
                    children: [
                      if (size > 600 &&
                          !cubit.screenList[selectedIndex].isScreenFullWidth)
                        const Expanded(child: SizedBox(height: double.infinity)),
                      Expanded(
                        flex: size > 600 ? 4 : 1,
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: size > 600 &&
                                    cubit.screenList[selectedIndex]
                                        .isScreenFullWidth &&
                                    cubit.handnessType == HandnessType.right
                                ? 60
                                : 0,
                            left: size > 600 &&
                                    cubit.screenList[selectedIndex]
                                        .isScreenFullWidth &&
                                    cubit.handnessType == HandnessType.left
                                ? 60
                                : 0,
                          ),
                          child: SizedBox(
                            width: size > 600 ? size / 1.3 : size,
                            child: cubit.screenList[selectedIndex].screens,
                          ),
                        ),
                      ),
                      if (size > 600 &&
                          !cubit.screenList[selectedIndex].isScreenFullWidth)
                        const Expanded(child: SizedBox(height: double.infinity)),
                    ],
                  );
                },
              ),
            ),
          ),
          if (size > 600)
            Listener(
              onPointerDown: (event) {
                _handlePointerDown(event, size < 600);
              },
              onPointerUp: (event) {
                _handlePointerUp(event, size < 600);
              },
              onPointerCancel: (_) {
                _pointerCount = 0;
                _lastPointerPositions.clear();
                _lastPointerDeltas.clear();
              },
              onPointerMove: (event) {
                _handlePointerMove(event, size < 600);
              },
              child: GestureDetector(
                onTap: _handleScreenTap,
                child: Row(
                  children: [
                    if (!cubit
                        .screenList[cubit.currentSelectedIndex]
                        .isScreenFullWidth)
                      Expanded(
                        child: Container(
                          color: const Color.fromARGB(255, 239, 239, 239),
                          height: double.infinity,
                        ),
                      ),
                    Expanded(flex: size > 600 ? 4 : 1, child: SizedBox()),

                    if (!cubit
                        .screenList[cubit.currentSelectedIndex]
                        .isScreenFullWidth)
                      Expanded(
                        child: Container(
                          color: const Color.fromARGB(255, 239, 239, 239),
                          height: double.infinity,
                        ),
                      ),
                  ],
                ),
              ),
            ),

          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ScrollHintSelector(
              key: _hintSelectorKey,
              tagList: cubit.tagList,
              listData: cubit.screenList,
              onSelected: (int tag) {
                cubit.setcurrentSelectedIndex(tag);
              },
              currentSelectedIndex: cubit.currentSelectedIndex,
              externalScrollController: _hintSelectorController,
            ),
          ),
        ],
      ),
    );
  }
}
