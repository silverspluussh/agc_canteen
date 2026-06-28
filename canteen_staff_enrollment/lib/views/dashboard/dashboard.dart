import 'package:canteen_staff_enrollment/views/app_buttons.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/admin_auth_controller.dart';
import '../../core/theme/app_colors.dart';
import 'overview_page.dart';
import 'staff_directory_page.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  int _currentIndex = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final adminState = ref.watch(adminAuthProvider);

    final List<Widget> pages = [
      OverviewPage(
        onNavigateToStaff: () {
          setState(() {
            _currentIndex = 1;
          });
        },
      ),
      const StaffDirectoryPage(),
    ];

    return PopScope(
      canPop: false,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: AppColors.gold600,
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          centerTitle: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _currentIndex == 0
                    ? 'Dashboard Overview'.toUpperCase()
                    : 'Staff Directory'.toUpperCase(),
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      
              Text(
                _currentIndex == 0
                    ? 'Summarized overview of staff enrollments'
                    : "View all staff enrollment directory",
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
        drawer: Drawer(
          child: Column(
            children: [
              // Drawer Header
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Image.asset(
                    'assets/app_logo.png',
                    width: 48,
                    height: 48,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.admin_panel_settings,
                      color: AppColors.gold500,
                      size: 32,
                    ),
                  ),
                ),
                accountName: const Text(
                  'Canteen Administrator',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                accountEmail: Text(adminState.email ?? ''),
              ),
      
              // Navigation List Items
              ListTile(
                leading: const Icon(Icons.dashboard_outlined),
                title: const Text('Overview'),
                selected: _currentIndex == 0,
                selectedColor: Theme.of(context).colorScheme.primary,
                onTap: () {
                  setState(() {
                    _currentIndex = 0;
                  });
                  Navigator.pop(context); // Close Drawer
                },
              ),
              ListTile(
                leading: const Icon(Icons.group),
                title: const Text('Staff Directory'),
                selected: _currentIndex == 1,
                selectedColor: Theme.of(context).colorScheme.primary,
                onTap: () {
                  setState(() {
                    _currentIndex = 1;
                  });
                  Navigator.pop(context); // Close Drawer
                },
              ),
      
              const Spacer(),
              const Divider(),
      
              // Logout Action
              ListTile(
                leading: const Icon(Icons.logout, color: AppColors.error),
                title: const Text(
                  'Sign out',
                  style: TextStyle(
                    color: AppColors.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context); // Close Drawer
                  _showLogoutDialog(context, ref);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        body: pages[_currentIndex],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign out'),
        content: Text(
          'Are you sure you want to sign out from the staff enrollment application?',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          PrimaryButton(
            width: 120,
            height: 40,
            onPressed: () {
              Navigator.pop(context);
            },

            label: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),

          DestructiveButton(
            width: 120,

            onPressed: () {
              Navigator.pop(context);
              ref.read(adminAuthProvider.notifier).logout();
            },

            label: const Text(
              'Sign out',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
