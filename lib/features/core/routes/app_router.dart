import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/features/home/presentation/bloc/task/task_bloc.dart';
import '../../home/domain/entities/task.dart';
import '../../home/presentation/pages/task_detail_page.dart';
import '../../home/presentation/pages/task_form_page.dart';
import '../../auth/presentation/bloc/auth_bloc.dart';
import '../presentation/pages/main_screen.dart';
import '../presentation/pages/splash_screen.dart';
import '../../home/presentation/pages/profile_page.dart';
import '../../auth/presentation/pages/login_page.dart';
import '../../auth/presentation/pages/register_page.dart';
import '../injection.dart' as di;
import 'app_routes.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (context) {
        return Builder(
          builder: (BuildContext context) {
            switch (settings.name) {
              case AppRoutes.splash:
                return SplashScreen();
              case AppRoutes.login:
                return BlocProvider(
                  create: (context) => di.locator<AuthBloc>(),
                  child: const LoginPage(),
                );
              case AppRoutes.register:
                return BlocProvider(
                  create: (context) => di.locator<AuthBloc>(),
                  child: const RegisterPage(),
                );
              case AppRoutes.main:
                return MainScreen(locator: di.locator);
              case AppRoutes.profile:
                return ProfilePage(locator: di.locator);
              case AppRoutes.taskForm:
                final task = settings.arguments as Task?;
                return BlocProvider(
                  create: (context) => di.locator<TaskBloc>(),
                  child: TaskFormPage(task: task),
                );
              case AppRoutes.taskDetail:
                final Map<String, dynamic> args =
                    settings.arguments as Map<String, dynamic>;
                return TaskDetailPage(task: args['detailData']);
              default:
                return Scaffold(
                  body: Center(
                    child: Text(
                      'Page not found :(',
                      style: TextStyle(
                        fontSize: 30,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                );
            }
          },
        );
      },
    );
  }
}
