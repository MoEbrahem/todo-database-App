import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one/shared/components/cubit/cubit.dart';
import 'package:one/shared/components/cubit/states.dart';

import '../../shared/components/components.dart';
class DoneTasksScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>
      (
      listener: (context,states){},
      builder: (context,states){
       var tasks =AppCubit.get(context).doneTasks;
       return tasksBuilder(tasks: tasks);
      },
    );
  }
}
