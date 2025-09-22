import 'dart:ui';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:section_bar_navigator_system/feature/settings/presenter/settings_cubit.dart';
import 'package:section_bar_navigator_system/feature/settings/presenter/state/settings_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IndexBarReorderingScreen extends StatefulWidget {
  const IndexBarReorderingScreen({super.key});

  @override
  State<IndexBarReorderingScreen> createState() => _IndexBarReorderingScreenState();
}

class _IndexBarReorderingScreenState extends State<IndexBarReorderingScreen> {

  String generateFallbackTag(String word, Set<String> usedTags) {
    // Simple fallback implementation
    for (int i = 1; i <= 99; i++) {
      String candidate = '${word[0].toUpperCase()}$i';
      if (!usedTags.contains(candidate)) {
        return candidate;
      }
    }
    return '${word[0].toUpperCase()}99';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bloc = context.read<SettingsCubit>();

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text("Reorder Sections", style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        actions: [
          TextButton(
            onPressed: () {
             context.read<SettingsCubit>().resetReorderedSection();
            },
            child: Text(
              'Reset',
              style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Instructions Card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: theme.colorScheme.onSurfaceVariant, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Click and drag the handle to reorder items',
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ),
                ],
              ),
            ),

            // Preview Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Preview',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.onSurfaceVariant),
              ),
            ),
            const SizedBox(height: 8),

            // Preview tabs
            Container(
              height: 80,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: bloc.screenList.length,
                itemBuilder: (context, index) {
                  final tag = generateUniqueTag(bloc.screenList.map((e) => e.name).toList(), index);
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: Column(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: bloc.screenList[index].tabColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: bloc.screenList[index].tabColor.withOpacity(0.3), width: 1),
                          ),
                          child: Center(
                            child: Text(
                              tag,
                              style: TextStyle(color: bloc.screenList[index].tabColor, fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 8),

            // Section title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Sections',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.onSurfaceVariant),
              ),
            ),
            const SizedBox(height: 8),

            // Reorderable list
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: ReorderableListView.builder(
                    buildDefaultDragHandles: false, // Disable default drag handles
                    proxyDecorator: proxyDecorator,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      final tag = generateUniqueTag(bloc.screenList.map((e) => e.name).toList(), index);

                      return Container(
                        key: Key("$index"),
                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 2, offset: const Offset(0, 1))],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: bloc.screenList[index].tabColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: bloc.screenList[index].tabColor.withOpacity(0.3)),
                            ),
                            child: Center(
                              child: Text(
                                tag,
                                style: TextStyle(color: bloc.screenList[index].tabColor, fontWeight: FontWeight.w600, fontSize: 12),
                              ),
                            ),
                          ),
                          title: Text(bloc.screenList[index].name, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500)),
                          subtitle: Text('Tab ${index + 1}', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                          trailing: ReorderableDragStartListener(
                            index: index,
                            child: MouseRegion(
                              cursor: SystemMouseCursors.grab,
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surfaceVariant.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(8),
                                  // border: Border.all(
                                  //   color: theme.colorScheme.outline.withOpacity(0.3),
                                  //   width: 1,
                                  // ),
                                ),
                                child: Icon(
                                  Icons.drag_handle,
                                  color: theme.colorScheme.onSurfaceVariant,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: bloc.screenList.length,
                    onReorder: (oldIndex, newIndex) async {
                      setState(() {
                        if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }
                        final item = bloc.screenList.removeAt(oldIndex);
                        bloc.screenList.insert(newIndex, item);
                      });
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setStringList("SectionList", bloc.screenList.map((e) => e.name).toList());
                      // Provide haptic feedback
                      HapticFeedback.lightImpact();
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final animValue = Curves.easeInOut.transform(animation.value);
        final elevation = lerpDouble(2, 12, animValue)!;
        final scale = lerpDouble(1, 1.05, animValue)!;

        return Transform.scale(
          scale: scale,
          child: Material(
            elevation: elevation,
            borderRadius: BorderRadius.circular(12),
            shadowColor: Colors.black.withOpacity(0.2),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).colorScheme.surface,
                border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.3), width: 2),
              ),
              child: child,
            ),
          ),
        );
      },
      child: child,
    );
  }
}