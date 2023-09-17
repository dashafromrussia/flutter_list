import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/bloc/background_bloc.dart';
import 'package:untitled1/bloc/saveUser_bloc.dart';

class Mydata extends StatefulWidget {
  const Mydata({Key? key}) : super(key: key);

  @override
  State<Mydata> createState() => _MydataState();
}

class _MydataState extends State<Mydata> {
  String name ="";
  String surname = "";
  @override
  Widget build(BuildContext context) {
    final userData = context.watch<UserDataBloc>();
    final BackgroundBloc back = context.watch<BackgroundBloc>();
    return BlocListener<BackgroundBloc, StatusState>(
      listener: (context, state) {
        if (state is OnlineStatusState || state is BeginStatusState) {
          if (userData.state is SuccessSignInState){
            back.add(const MiddleStatusEvent());
            Navigator.pushNamed(context, '/code');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          // automaticallyImplyLeading:false,
          title: const Text('About me'),
        ),
        body:Container(
          padding:const EdgeInsets.all(10),
          child: Column(
          children: [
            TextFormField(
                decoration:const  InputDecoration(
                  labelText: "Enter name",
                  hintText: "Enter name",
                  icon: Icon(Icons.accessibility_outlined),
                ),
                maxLength: 30,
                onChanged: (text) {
                  name = text;
                  setState(() {

                  });
                }
            ),
            const SizedBox(height: 10,),
            TextFormField(
                decoration:const  InputDecoration(
                  labelText: "Enter surname",
                  hintText: "Enter surname",
                  icon: Icon(Icons.text_snippet_outlined),
                ),
                maxLength: 30,
                onChanged: (text) {
                  surname = text;
                  setState(() {

                  });
                }
            ),
            ElevatedButton(onPressed: (){
              userData.add(UpdateUserData(data:{'name':name,"surname":surname}));
            }, child:const Text("send data")),
            const SizedBox(height: 10,),
          ],
        ),)
      ),
    );
  }
}
