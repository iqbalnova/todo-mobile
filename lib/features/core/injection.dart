import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:todoapp/features/home/data/datasources/task_local_datasource.dart';
import 'package:todoapp/features/home/data/repositories/task_repository_impl.dart';
import 'package:todoapp/features/home/domain/repositories/task_repository.dart';
import 'package:todoapp/features/home/domain/usecases/delete_task.dart';
import 'package:todoapp/features/home/domain/usecases/get_all_tasks.dart';
import 'package:todoapp/features/home/domain/usecases/get_task_by_id.dart';
import 'package:todoapp/features/home/domain/usecases/insert_task.dart';
import 'package:todoapp/features/home/domain/usecases/update_task.dart';
import 'package:todoapp/features/home/presentation/bloc/task/task_bloc.dart';

import '../auth/presentation/bloc/auth_bloc.dart';
import 'common/db/database_helper.dart';
import 'routes/app_router.dart';

final locator = GetIt.instance;

Future<void> init() async {
  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());
  locator.registerLazySingleton<FlutterSecureStorage>(
    () => FlutterSecureStorage(),
  );

  // Register Core Services
  locator.registerSingleton<AppRouter>(AppRouter());

  // Register FirebaseAuth instance
  locator.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  // External
  locator.registerLazySingleton(() => http.Client());

  // Bloc
  locator.registerFactory<AuthBloc>(
    () => AuthBloc(firebaseAuth: locator<FirebaseAuth>()),
  );
  locator.registerFactory<TaskBloc>(
    () => TaskBloc(
      getAllTasks: locator(),
      deleteTask: locator(),
      updateTask: locator(),
      insertTask: locator(),
    ),
  );

  // use case
  locator.registerLazySingleton(() => InsertTask(locator()));
  locator.registerLazySingleton(() => GetAllTasks(locator()));
  locator.registerLazySingleton(() => GetTaskById(locator()));
  locator.registerLazySingleton(() => UpdateTask(locator()));
  locator.registerLazySingleton(() => DeleteTask(locator()));

  // repository
  locator.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(localDataSource: locator()),
  );

  // data sources
  locator.registerLazySingleton<TaskLocalDataSource>(
    () => TaskLocalDataSourceImpl(databaseHelper: locator()),
  );
}
