import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/bloc/background_bloc.dart';
import 'package:untitled1/bloc/saveUser_bloc.dart';



class AboutMeScreen extends StatelessWidget {
  final Widget drawer;
  const AboutMeScreen({super.key,required this.drawer});

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
          title: const Text('Settings'),
        ),
        body:Container (
          padding: const EdgeInsets.all(20),
          child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 5,),
            ElevatedButton(onPressed:(){
              Navigator.pushNamed(context, '/mydata');
            }, child: const Text("My data")),
            const SizedBox(height: 5,),
            ElevatedButton(onPressed:(){
              Navigator.pushNamed(context, '/notif');
            }, child: const Text("Notification")),
            const SizedBox(height: 5,),
            ElevatedButton(onPressed: (){
              userData.add(const ExitUser());
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
            }, child: const Text("exit")),
            const SizedBox(height: 5,),
            ElevatedButton(onPressed:(){
              userData.add(const DeleteUserData());
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
            }, child:const Text("del")),
            SizeBox(height:20),
            const Text("Version 1.0.0"),
          ],
        ),),
        drawer: drawer,
      ),
    );
  }
}
