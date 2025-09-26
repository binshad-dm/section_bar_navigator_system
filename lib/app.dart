
import 'package:floating_draggable_widget/floating_draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:section_bar_navigator_system/core/theme/app_theme.dart';
import 'package:section_bar_navigator_system/core/widgets/index_bar/index_bar_widget.dart';
import 'package:section_bar_navigator_system/feature/settings/presenter/settings_cubit.dart';
import 'package:section_bar_navigator_system/feature/settings/presenter/state/settings_state.dart';


class App extends StatefulWidget {
  const App({super.key, required this.navigatorKey, this.dx, this.dy});

  final GlobalKey<NavigatorState> navigatorKey;
  final dx;
  final dy;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    bool isDragging = false;
    final size = MediaQuery.of(context).size.shortestSide;
    final mediaQuery = MediaQuery.of(context).size;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SettingsCubit()),
      ],
      child: MaterialApp(
        navigatorKey: widget.navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Medicine Prescription',
        theme: AppTheme.doctorPrescriptionTheme,

        home: size > 600
            ? HomeScreen()
            : BlocBuilder<SettingsCubit, SettingsState>(
                builder: (context, state) => FloatingDraggableWidget(
                  resizeToAvoidBottomInset: false,
                  mainScreenWidget: HomeScreen(isDisableIndexBar: !context.watch<SettingsCubit>().isFloatingScreen),
                  onDragging: (p0) {
                    isDragging = p0;
                  },
                  onDragEvent: (dx, dy) {
                    context.read<SettingsCubit>().setfloatingButtonCurrentPosition(dx, dy);
                    if (!isDragging) {
                      print("ds");
                      if (dx >= MediaQuery.of(context).size.width / 2) {
                        context.read<SettingsCubit>().setHandnessType(HandnessType.right);
                      } else {
                        context.read<SettingsCubit>().setHandnessType(HandnessType.left);
                      }
                    }
                  },
                  dx: context.read<SettingsCubit>().floatingWidgetCurrentDx ?? widget.dx ?? mediaQuery.width - 45,

                  dy: context.read<SettingsCubit>().floatingWidgetCurrentDy ?? widget.dy ?? mediaQuery.height / 2 - 22.5,

                  floatingWidget: context.watch<SettingsCubit>().isFloatingScreen
                      ? InkWell(
                          onTap: () {
                            context.read<SettingsCubit>().setNormalScreenState(context);
                          },
                          child: Opacity(opacity: 0.5, child: CircleAvatar(child: Text("S"))),
                        )
                      : SizedBox(),
                  autoAlign: true,
                  floatingWidgetWidth: 45,
                  floatingWidgetHeight: 45,
                ),
              ),
      ),
    );
  }
}
