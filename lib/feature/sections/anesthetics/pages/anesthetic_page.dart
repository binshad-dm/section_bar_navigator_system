
import 'package:flutter/material.dart';
import 'package:section_bar_navigator_system/feature/sections/anesthetics/pages/tabs/anesthetic.dart';
import 'package:section_bar_navigator_system/feature/sections/anesthetics/pages/tabs/anesthetic_immediate_page.dart';
import 'package:section_bar_navigator_system/feature/sections/anesthetics/pages/tabs/post_anesthetic_page.dart';
import 'package:section_bar_navigator_system/feature/sections/anesthetics/pages/tabs/pre_anesthetic_evaluation_page.dart';

/// The main content screen widget.
class AnestheticPage extends StatefulWidget {
  const AnestheticPage({super.key});

  @override
  State<AnestheticPage> createState() => _AnestheticPageState();
}

class _AnestheticPageState extends State<AnestheticPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> tabs = [
    {
      'title': 'Immediate',
      'icon': Icons.medical_services,
      'screen': AnestheticImmediatePage(),
    },
    {
      'title': 'Post',
      'icon': Icons.medical_information,
      'screen': PostAnestheticPage(),
    },
    {
      'title': 'Pre-Eval',
      'icon': Icons.assessment,
      'screen': PreAnestheticEvaluationPage(),
    },
    {'title': 'General', 'icon': Icons.medication, 'screen': AnestheticTab()},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(248, 245, 245, 245),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.grey.shade300, width: 0.5),
            ),
            child: SizedBox(
              height: 30,
              child: TabBar(
                dividerHeight: 0,
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Theme.of(context).primaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey.shade600,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
              
                  overflow: TextOverflow.ellipsis,
                ),
                tabs: tabs.map((tab) {
                  return Tab(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isSmallScreen =
                            MediaQuery.of(context).size.width < 400;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(tab['icon'], size: isSmallScreen ? 16 : 18),
                            SizedBox(width: isSmallScreen ? 4 : 8),
                            Flexible(
                              child: Text(
                                tab['title'],
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 11 : 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: tabs.map((tab) => tab['screen'] as Widget).toList(),
      ),
    );
  }

  /// Resets the current tab index to the start.
  Future<void> setCurrentIndextoStart() async {
    _tabController.animateTo(0);
  }
}
