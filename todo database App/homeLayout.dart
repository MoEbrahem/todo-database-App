import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:one/modules/archivedTasks/achived_tasks.dart';
import 'package:one/modules/doneTasks/done_tasks.dart';
import 'package:one/shared/components/components.dart';
import 'package:one/shared/components/cubit/cubit.dart';
import 'package:one/shared/components/cubit/states.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


import '../modules/NewTasks/new_tasks.dart';
import '../shared/components/constants.dart';
class HomeLayout extends StatelessWidget
{


  Database? dataBase;
  var scaffoldKey =GlobalKey<ScaffoldState>();
  var _formKey =GlobalKey<FormState>();

  var titleController=TextEditingController();
  var timeController=TextEditingController();
  var dateController=TextEditingController();




  @override
  Widget build(BuildContext context)
  {
    return BlocProvider(
      create: (BuildContext context)=>AppCubit()..createDataBase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (BuildContext context ,AppStates state)
        {
          if (state is AppInsertDataBaseState){
            Navigator.pop(context);
          }
        },
        builder: (context,state) {
          AppCubit cubit= AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                  cubit.titles[cubit.currentIndex]
              ),
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDataBaseLoadingState,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) => Center(child: CircularProgressIndicator()),),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (_formKey.currentState!.validate())
                  {
                    // insertDataBase(
                    //   date: dateController.text,
                    //   time: timeController.text,
                    //   title: titleController.text,
                    // ).then((value) {
                    //   getDataFromDataBase(dataBase).then((value) {
                    //
                    //       Navigator.pop(context);
                    //       isBottomSheetShown = false;
                    //       fabIcon = Icons.edit;
                    //       tasks = value;
                    //
                    //   });
                    // });
                    cubit.insertDataBase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text
                    );
                  }
                }
                else
                {
                  scaffoldKey.currentState!.showBottomSheet(
                        (context) => Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(20.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultFormFeild(
                                    controller: titleController,
                                    type: TextInputType.text,
                                    validate: (String value) {
                                      if (value.isEmpty) {
                                        return 'the title must not be Empty';
                                      }

                                      return null;
                                    },

                                    label: "Task Title",
                                    prefix: Icons.title
                                ),
                                SizedBox(height: 15,),
                                defaultFormFeild(
                                    controller: timeController,
                                    type: TextInputType.datetime,
                                    onTap: () {
                                      showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      ).then((value) =>
                                      timeController.text =
                                          value!.format(context).toString(),
                                      );
                                    },
                                    validate: (String value) {
                                      if (value.isEmpty) {
                                        return "time must not be Empty";
                                      }
                                      return null;
                                    },
                                    label: "Task Time",
                                    prefix: Icons.watch_later_outlined
                                ),
                                SizedBox(height: 15,),
                                defaultFormFeild(
                                    controller: dateController,
                                    type: TextInputType.datetime,
                                    onTap: () {
                                      showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime.parse("2023-12-03")
                                      ).then((value) =>
                                      dateController.text =
                                          DateFormat.yMMMd().format(value!),
                                      );
                                    },
                                    validate: (String value) {
                                      if (value.isEmpty) {
                                        return "date must not be Empty";
                                      }
                                      return null;
                                    },
                                    label: "Task Date",
                                    prefix: Icons.calendar_today
                                ),
                              ],
                            ),
                          ),
                        ),
                    elevation: 20.0,
                  ).closed.then((value) {
                    cubit.changeBottomSheetState(
                        isShow: false, icon: Icons.edit);
                  });
                  cubit.changeBottomSheetState(
                      isShow: true, icon: Icons.add);
                }
              },
              child: Icon(cubit.fabIcon,),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.ChangeIndex(index);
              },
              items:
              [
                BottomNavigationBarItem(
                    icon: Icon(Icons.menu),
                    label: "Tasks"
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline),
                    label: "Done"
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined),
                    label: "Archived"
                ),
              ],
            ),
          );

        }
      ),

    );
   }


  // Future insertDataBase({
  //    required String title,
  //    required String time,
  //    required String date,
  //   })
  // async
  // {
  //  return await dataBase?.transaction((txn)
  //  {
  //     txn.rawInsert(
  //      'INSERT INTO tasks( title, date, time, status) VALUES(" $title","$date","$time","new")'
  //     ).then((value) {
  //       print("$value inserted successfuly");
  //     }).catchError((error){
  //       print("Error when inserting new Record ${error.toString()}");
  //     });
  //     return null;
  //   });
  // }
}
