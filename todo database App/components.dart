import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:one/shared/components/cubit/cubit.dart';

Widget defaultButton(
    {
      double width = double.infinity,
      Color background = Colors.blue,
      double radius = 10.0,
      required Function function,
      required String text,
      bool isUpperCase = true,
    }) =>
    Container(
      height: 40.0,
      width: width,
      child: MaterialButton(
          onLongPress: () {},
          onPressed: (){
             function();
          },
          child: Text(
            isUpperCase ? text.toUpperCase() : text.toLowerCase(),
            style: TextStyle(color: Colors.white),
          )),
      decoration: BoxDecoration(
        borderRadius: BorderRadiusDirectional.circular(radius),
        color: background,
      ),
    );

Widget defaultFormFeild({
  required TextEditingController controller,
  required TextInputType type,
  Function? onSubmit, //Add question mark
  Function? onChange, //Add question mark
  required Function validate,
  required var label,
  bool isPassword =false,
  IconData? suffix,
  Function? suffixPressed,
  required IconData prefix,
  Function? onTap()?,
}) =>
    TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: type,
      onChanged: onChange != null? onChange() : null,
      onFieldSubmitted: onSubmit != null? onSubmit() : null,
      onTap: onTap != null? onTap : null,
      validator: (value)
      {
        return validate(value);
      },
      decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(prefix),
          suffixIcon: suffix !=null? IconButton(icon: Icon(suffix),
            onPressed:(){
              suffixPressed!();
            } ,):null,
          border: OutlineInputBorder()
      ),
    );

Widget buildTaskItem(Map model,context) =>
    Dismissible(
      key: Key(model["id"].toString()),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              child: Text("${model["time"]}"),

            ),
            SizedBox(width: 20.0,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("${model["title"]}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text("${model["date"]} ",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 20.0,),
            IconButton(
                onPressed: ()
                  {
                    AppCubit.get(context).UpdateData(
                        status: "done", id: model["id"]);
                  },
                icon: Icon(
                    Icons.check_box,
                    color: Colors.green,)
            ),
            IconButton(
                onPressed: ()
                  {
                    AppCubit.get(context).UpdateData(status: "Archived", id: model["id"]);

                  },
                icon: Icon(
                    Icons.archive,
                    color: Colors.black26,)
            ),

          ],
  ),
),
      onDismissed: (direction)
      {
        AppCubit.get(context).DeleteData(id: model["id"],);
      },
    );
Widget tasksBuilder({required List<Map> tasks}) => ConditionalBuilder(
  condition: tasks.length > 0,
  builder: (context)=>ListView.separated(
    itemBuilder: (context,index)=> buildTaskItem(tasks[index],context),
    separatorBuilder: (context,index)=>Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 20,
      ),
      child: Container(
        width: double.infinity,
        height: 1,
        color: Colors.grey[300],
      ),
    ),
    itemCount: tasks.length,
  ),
  fallback: (context)=>Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.menu,
          size: 100,
          color: Colors.grey,),
        Text("No Tasks yet please add some Tasks",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey
            )),
      ],
    ),
  ),
);