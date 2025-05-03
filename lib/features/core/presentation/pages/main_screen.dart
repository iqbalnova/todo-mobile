import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:todoapp/features/home/presentation/bloc/task/task_bloc.dart';
import 'package:todoapp/features/home/presentation/pages/profile_page.dart';

import '../../../home/presentation/pages/home_page.dart';
import '../../common/styles.dart';

class MainScreen extends StatefulWidget {
  final GetIt locator;
  const MainScreen({super.key, required this.locator});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final int _totalPages = 2; // Total number of pages in BottomNavigationBar

  void _setIndex(int index) {
    if (_isValidIndex(index)) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  bool _isValidIndex(int index) {
    return index >= 0 && index < _totalPages;
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return BlocProvider(
          create: (context) => widget.locator<TaskBloc>(),
          child: HomePage(locator: widget.locator),
        );
      case 1:
        return ProfilePage(locator: widget.locator);
      default:
        return const OnDevScreen();
    }
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Colors.grey,
      currentIndex: _currentIndex,
      onTap: _setIndex,
      items: _bottomNavigationBarItems(),
    );
  }

  List<BottomNavigationBarItem> _bottomNavigationBarItems() {
    return const [
      BottomNavigationBarItem(icon: Icon(Icons.checklist), label: 'All Todo'),
      BottomNavigationBarItem(
        icon: Icon(Icons.person_rounded),
        label: 'Profile',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: buildBottomNavigationBar(),
      body: _buildBody(),
    );
  }
}

class OnDevScreen extends StatelessWidget {
  const OnDevScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("ON DEV", style: AppTextStyle.subtitle1()));
  }
}
