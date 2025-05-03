import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import '../../../core/routes/app_routes.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';

class ProfilePage extends StatelessWidget {
  final GetIt locator;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  ProfilePage({super.key, required this.locator});
  // TODO
  // 1. Backup data saat signout (Tambahkan loading seakan backup)
  // 2. Ada alert untuk user apakah mau restore data dari cloud ketika sehabis login

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator<AuthBloc>()..add(CheckAuthStatusEvent()),
      child: BlocListener<AuthBloc, AuthState>(
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
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
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
                return Center(child: Text('No user data.'));
              } else {
                return const Center();
              }
            },
          ),
        ),
      ),
    );
  }

  Future<void> _handleUnauthenticated(BuildContext context) async {
    await _clearUserData(); // misalnya menghapus database dan secure storage
    Navigator.pushNamedAndRemoveUntil(
      // ignore: use_build_context_synchronously
      context,
      AppRoutes.login,
      (route) => false,
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text(
            'You will be signed out, and all user data will be deleted from secure storage and the database. Do you want to proceed?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _clearUserData();
                // ignore: use_build_context_synchronously
                context.read<AuthBloc>().add(SignOutEvent());
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              },
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menghapus data dari secure storage dan database
  Future<void> _clearUserData() async {
    await _secureStorage.delete(key: 'uid');

    // Hapus data dari database, jika menggunakan SQLite atau database lain
    // Contoh menggunakan SQLite:
    // await DatabaseHelper.instance.clearUserData();  // Sesuaikan dengan metode yang sesuai
  }
}
