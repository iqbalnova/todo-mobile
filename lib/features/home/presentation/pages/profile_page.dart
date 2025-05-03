import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/common/db/database_helper.dart';
import '../../../core/routes/app_routes.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../data/models/task_table.dart';
import '../../domain/usecases/get_all_tasks.dart';

class ProfilePage extends StatefulWidget {
  final GetIt locator;

  const ProfilePage({super.key, required this.locator});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  @override
  void initState() {
    context.read<AuthBloc>().add((CheckAuthStatusEvent()));
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthBloc>().add(CheckAuthStatusEvent());
    });
  }

  void _showSignOutDialog(BuildContext context) async {
    // Check if there are any tasks in the local database
    final GetAllTasks getAllTasks = widget.locator<GetAllTasks>();
    final tasksResult = await getAllTasks.execute();
    final taskList = tasksResult.getOrElse(() => []);

    // If no tasks exist, show a sign-out dialog without backup options
    if (taskList.isEmpty) {
      // ignore: use_build_context_synchronously
      _signOutWithoutBackup();
      return;
    }

    showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text(
            'Before signing out, would you like to back up your data to the cloud? All local data will be erased.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _backupAndSignOut();
              },
              child: const Text('Back Up & Sign Out'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _signOutWithoutBackup();
              },
              child: const Text('Sign Out Without Backup'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _backupAndSignOut() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await _backupDataToCloud(context);

      if (mounted) {
        context.read<AuthBloc>().add(SignOutEvent());
        await _clearUserData();
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                title: const Text('Backup Failed'),
                content: Text('An error occurred while backing up data: $e'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              ),
        );
        return;
      }
    }

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _signOutWithoutBackup() async {
    await _clearUserData();
    if (mounted) {
      context.read<AuthBloc>().add(SignOutEvent());
    }
  }

  Future<void> _backupDataToCloud(BuildContext context) async {
    final GetAllTasks getAllTasks = widget.locator<GetAllTasks>();
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("User not logged in")));
      return;
    }

    try {
      final uid = user.uid;

      // Fetch local tasks from SQLite
      final tasksResult = await getAllTasks.execute();
      final taskList =
          tasksResult.getOrElse(() => []).map((task) {
            final taskTable = TaskTable.fromEntity(task);
            return taskTable.toMap();
          }).toList();

      final backupData = {
        'uid': uid,
        'email': user.email,
        'displayName': user.displayName,
        'timestamp': FieldValue.serverTimestamp(),
        'someLocalData': {'tasks': taskList},
      };

      final backupRef = FirebaseFirestore.instance
          .collection('backups')
          .doc(uid);
      await backupRef.set(backupData);

      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text("Backup Successfully!")));
    } catch (e) {
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text("Backup failed: ${e.toString()}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          _handleUnauthenticated(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is Authenticated) {
              final User user = state.user;
              return Center(
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.account_circle,
                          size: 80,
                          color: Colors.blueGrey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          user.displayName ?? '-',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          user.email ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.logout),
                            label: const Text('Sign Out'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () {
                              _showSignOutDialog(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else if (state is AuthError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is Unauthenticated) {
              return const Center(child: Text('No user data.'));
            } else {
              return const Center();
            }
          },
        ),
      ),
    );
  }

  Future<void> _handleUnauthenticated(BuildContext context) async {
    await _clearUserData();
    Navigator.pushNamedAndRemoveUntil(
      // ignore: use_build_context_synchronously
      context,
      AppRoutes.login,
      (route) => false,
    );
  }

  Future<void> _clearUserData() async {
    await _secureStorage.delete(key: 'uid');
    await DatabaseHelper().deleteDatabaseFile();
  }
}
