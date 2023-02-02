import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one/modules/archivedTasks/achived_tasks.dart';
import 'package:one/shared/components/constants.dart';
import 'package:one/shared/components/cubit/states.dart';
import 'package:sqflite/sqflite.dart';

import '../../../modules/NewTasks/new_tasks.dart';
import '../../../modules/doneTasks/done_tasks.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);
  int currentIndex=0;
  Database? dataBase;
  List<Map> newTasks =[];
  List<Map> doneTasks =[];
  List<Map> archivedTasks =[];
  List<Widget> screens =
  [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen()
  ];
  List<String> titles=
  [
    "New Tasks",
    "Done Tasks",
    "Archived Tasks",
  ];
  void ChangeIndex(int index)
  {
   currentIndex =index ;
   emit(AppChangeBottomNavBarStates());
  }

  Future createDataBase()  async
  {
    // String databasepath= await getDatabasesPath();
    // String path =join(databasepath,"todo.db");
    // var mydb =
     openDatabase(
        // path,
      "todo.dp",
        version: 1,

        onCreate:(Database db,int version)
        async {
          print("dataBase created");
          await db.execute(
              'CREATE TABLE tasks ("id" INTEGER PRIMARY KEY ,"title" TEXT ,"date" TEXT ,"time" TEXT ,"status" TEXT)'
          ).then((value)
          {
            print("table Created");
          }).catchError((error)
          {
            print("Error when create table ${error.toString()}");
          });
        },
        onOpen: (dataBase)
        {
          getDataFromDataBase(dataBase);
          print("dataBase opened");
        }
    ).then((value)
    {
      dataBase=value;
      emit(AppCreateDataBaseState());
    });
    // return mydb;
  }
  void getDataFromDataBase(dataBase)
  {
    newTasks=[];
    doneTasks=[];
    archivedTasks=[];
    emit(AppGetDataBaseLoadingState());
     dataBase!.rawQuery(
        "SELECT * FROM tasks"
    ).then((value)
    {
      value.forEach((element) {
        if(element["status"]=='new')
          newTasks.add(element);

        else if(element["status"]=='done')
          doneTasks.add(element);
        else
          archivedTasks.add(element);
      });
      emit(AppGetDataBaseState());

    });
  }

   insertDataBase({
    required String title,
    required String time,
    required String date,
  }) async
  {
     await dataBase?.transaction((txn)
    {
      txn.rawInsert( 'INSERT INTO tasks( title, date, time, status) VALUES(" $title","$date","$time","new")'
      ).then((value)
      {
        print("$value inserted sucessfully");
        emit(AppInsertDataBaseState());
        getDataFromDataBase(dataBase);

      }).catchError((error){
        print("Error when Inserting DataBase ${error.toString()}");
      });
      return null;
    });
    // Database? mydb =await db ;
    // int response =await mydb!

    // return response ;
  }


  // static Database? _db;
  //
  // Future<Database?> get db
  // async  {
  //   if(_db ==null){
  //     _db = await createDataBase();
  //     return _db ;
  //   }else{
  //     return _db ;
  //   }
  // }



  void UpdateData({
  required String status,
  required int id
  }) async
  {
       dataBase!.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]
       ).then((value)
       {
         getDataFromDataBase(dataBase);
         emit(AppUpdateDataBaseState());
       }
       );

  }
  void DeleteData({
    required int id
  }) async
  {
    dataBase!.rawDelete(
        'DELETE FROM tasks WHERE id = ?',
        [id]
    ).then((value)
    {
      getDataFromDataBase(dataBase);
      emit(AppDeleteDataBaseState());
    }
    );

  }
  // Future updateDataBase(String sql) async
  // {
  //   Database? mydb =await db ;
  //   int response =await mydb!.rawUpdate(sql);
  //   return response ;
  // }

  // Future deleteDataBase(String sql) async
  // {
  //   Database? mydb =await db ;
  //   int response =await mydb!.rawDelete(sql);
  //   return response ;
  // }
  bool isBottomSheetShown = false;
  IconData fabIcon=Icons.edit;

  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
    })
  {
    isBottomSheetShown = isShow;
    fabIcon =icon;
    emit(AppChangeBottomSheetState());
  }
}
