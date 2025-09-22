
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:section_bar_navigator_system/feature/settings/presenter/settings_cubit.dart';
import 'package:section_bar_navigator_system/feature/settings/presenter/state/settings_state.dart';
import 'package:section_bar_navigator_system/feature/settings/view/index_bar_reordering_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(        iconTheme: IconThemeData(color: Colors.white, applyTextScaling: true),
       
      

        elevation: 0,
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        title: const Text("Settings", style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white)),
        centerTitle: true,
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          final cubit = context.read<SettingsCubit>();
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildSection("Hand Preference", [
                  _buildHandPreferenceCard(cubit),
                ]),
                const SizedBox(height: 24),
                _buildSection("Interaction", [
                  _buildVibrationCard(cubit),
                  _buildSettingCard(
                    context,
                    title: "Reorder Section Bar",
                    subtitle: "Customize section arrangement",
                    icon: Icons.reorder,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const IndexBarReorderingScreen()),
                    ),
                  ),
                ]),
                const SizedBox(height: 24),
                _buildSection("Data", [
                  _buildSettingCard(
                    context,
                    title: "Factory Reset",
                    subtitle: "Clear all local data",
                    icon: Icons.delete_forever,
                    iconColor: Colors.red.shade600,
                    onTap: () => _showResetDialog(context),
                  ),
                ]),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildHandPreferenceCard(SettingsCubit cubit) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _buildHandOption(
            "Left Hand",
            Icons.back_hand,
            HandnessType.left,
            cubit.handnessType,
            cubit.setHandnessType,
          ),
          const SizedBox(width: 16),
          _buildHandOption(
            "Right Hand",
            Icons.front_hand,
            HandnessType.right,
            cubit.handnessType,
            cubit.setHandnessType,
          ),
        ],
      ),
    );
  }

  Widget _buildHandOption(
    String label,
    IconData icon,
    HandnessType value,
    HandnessType groupValue,
    Function(HandnessType) onChanged,
  ) {
    final isSelected = value == groupValue;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(value),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue.shade50 : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? Colors.blue.shade300 : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.blue.shade600 : Colors.grey.shade600,
                size: 28,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? Colors.blue.shade700 : Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVibrationCard(SettingsCubit cubit) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.vibration, color: Colors.orange.shade600),
      ),
      title: const Text("Indexbar Vibration", style: TextStyle(fontWeight: FontWeight.w500)),
      subtitle: const Text("Haptic feedback on interaction"),
      trailing: Switch.adaptive(
        value: cubit.vibrationEnabled,
        onChanged: cubit.toggleVibration,
        activeColor: Colors.blue.shade600,
      ),
    );
  }

  Widget _buildSettingCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    final color = iconColor ?? Colors.blue.shade600;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
      onTap: onTap,
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange.shade600),
            const SizedBox(width: 8),
            const Text("Reset Data"),
          ],
        ),
        content: const Text("This will permanently delete all local data. This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          FilledButton(
            onPressed: () async{
              SharedPreferences _prefes = await SharedPreferences.getInstance();
             await _prefes.clear();
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade600),
            child: const Text("Reset"),
          ),
        ],
      ),
    );
  }
}