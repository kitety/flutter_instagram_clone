import 'package:api_repository/api_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram_clone/app/app.dart';
import 'package:flutter_instagram_clone/todos/cubit/todos_cubit.dart';

class App extends StatelessWidget {
  const App({required this.apiRepository, super.key});

  final ApiRepository apiRepository;

  @override
  Widget build(BuildContext context) {
    // return RepositoryProvider.value(
    //   value: apiRepository,
    //   child: const AppView(),
    // );
    return BlocProvider(
      create: (context) => TodosCubit(apiRepository: apiRepository),
      child: const AppView(),
    );
  }
}
