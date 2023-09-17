import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/bloc/code.dart';
import 'package:untitled1/bloc/error_bloc.dart';
import 'package:vibration/vibration.dart';

class CreateCode extends StatefulWidget {
  const CreateCode({super.key});

  @override
  State<CreateCode> createState() => _CreateCodeState();
}

class _CreateCodeState extends State<CreateCode> {
  String code = "";
  @override
  Widget build(BuildContext context) {
    final blocError = context.watch<ErrorBloc>();
    final blocCode = context.watch<CodeBloc>();
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading:false,
          title: const Text('Create code'),
        ),
        body:Container(
            padding:const EdgeInsets.symmetric(horizontal: 50),
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                    decoration:const InputDecoration(
                      hintText: "Придумайте код из 4-х цифр",
                      border: OutlineInputBorder(),
                    ),
                    obscureText:true,
                    keyboardType:TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 4,
                    onChanged: (text){
                      code = text;
                    } // print(email);},
                ),
                const SizedBox(height: 10,),
                ElevatedButton(onPressed:()async{
                  if(code.trim().length==4){
                    blocCode.add(SetCode(code: code.trim()));
                    Navigator.pushNamed(context, '/login');
                  }else{
                    print("code is not valid");
                    blocError.add(const ChangeErrorEvent(error: "Неверный код!"));
                    bool data =await Vibration.hasVibrator()??false;
                    if (data) {
                      Vibration.vibrate();
                    }

                  }
                }, child:const Text("Save code"))
              ],
            ))
    );
  }
}







