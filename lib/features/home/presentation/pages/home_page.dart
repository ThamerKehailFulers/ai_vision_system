import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/navigation_cubit.dart';
import '../../../dashboard/presentation/pages/dashboard_page.dart';
import '../../../camera/presentation/pages/camera_page.dart';
import '../../../detection/presentation/pages/detection_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../detection/presentation/cubit/detection_cubit.dart';
import '../../../detection/data/repositories/detection_repository_impl.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationCubit(),
      child: const _HomePageContent(),
    );
  }
}

class _HomePageContent extends StatelessWidget {
  const _HomePageContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        return Scaffold(
          body: IndexedStack(
            index: state.selectedIndex,
            children: [
              DashboardPage(),
              CameraPage(),
              BlocProvider(
                create: (context) =>
                    DetectionCubit(DetectionRepositoryImpl())..loadDetections(),
                child: DetectionPage(),
              ),
              ProfilePage(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: state.selectedIndex,
            onTap: (index) => context.read<NavigationCubit>().selectTab(index),
            type: BottomNavigationBarType.fixed,
            backgroundColor: const Color(0xFF0A0A0A),
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_outlined),
                activeIcon: Icon(Icons.dashboard),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.videocam_outlined),
                activeIcon: Icon(Icons.videocam),
                label: 'C4 Camera',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.security_outlined),
                activeIcon: Icon(Icons.security),
                label: 'Detections',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}
