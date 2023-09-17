import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/bloc/background_bloc.dart';
import 'package:untitled1/bloc/saveUser_bloc.dart';

class NotifScreen extends StatelessWidget {
  const NotifScreen({Key? key}) : super(key: key);
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
          title: const Text('Notification'),
        ),
        body:Container (
          padding: const EdgeInsets.all(20),
          child:const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
               SizedBox(height: 10,),
              Row(
                children: [
                  SwitchExample(),
                  SizedBox(width: 20,),
                  Text("New post")
                ],
              ),
               SizedBox(height: 10,),
              Row(
                children: [
                  SwitchExample(),
                  SizedBox(width: 20,),
                  Text("New likes")
                ],
              ),
               SizedBox(height: 10,),
              Row(
                children: [
                  SwitchExample(),
                  SizedBox(width: 20,),
                  Text("New comments")
                ],
              ),
               SizedBox(height: 10,),

            ],
          ),),

      ),
    );
  }
}


class SwitchExample extends StatefulWidget {
  const SwitchExample({super.key});

  @override
  State<SwitchExample> createState() => _SwitchExampleState();
}

class _SwitchExampleState extends State<SwitchExample> {
  bool light = true;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: light,
      activeColor: Colors.red,
      onChanged: (bool value) {
        setState(() {
          light = value;
        });
      },
    );
  }
}

