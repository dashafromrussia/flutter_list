import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/bloc/error_bloc.dart';
import 'package:untitled1/bloc/saveUser_bloc.dart';
import 'package:untitled1/screens/auth_widget.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String password = 'qqqqqqqq';
  String doublePassword = 'qqqqqqqq';
  String email = 'hero@gmail.com';
  @override
  Widget build(BuildContext context) {
    final blocError = context.watch<ErrorBloc>();
    final userData = context.watch<UserDataBloc>();
    const textStyle = TextStyle(
      fontSize: 16,
      color: Color(0xFF212529),
    );
    const textFieldDecorator = InputDecoration(
      border: OutlineInputBorder(),
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    );
   return BlocListener<UserDataBloc, UserDataState>(
      listener: (context, state) {
        if (state is UserDataSuccessState) {
          Navigator.pushNamed(context, '/createcode');
        }
      },
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading:false,
            title: const Text('Plugin example app'),
          ),
      body: Container(
        padding: const EdgeInsets.all(30),
        child:ListView(
          children: [
            const Text(
              'Email',
              style: textStyle,
            ),
            const SizedBox(height: 5),
            TextField(
                maxLength: 40,
                decoration: textFieldDecorator,
                onChanged: (text){
                 email = text;
                } // print(email);},
            ),
            const SizedBox(height: 20),
            const Text(
              'Password',
              style: textStyle,
            ),
            const SizedBox(height: 5),
            TextField(
                maxLength: 20,
                decoration: textFieldDecorator,
                obscureText: true,
                onChanged: (text) {
                   password = text;
                }
            ),
            const SizedBox(height: 20),
            const Text(
              'Repeat password',
              style: textStyle,
            ),
            const SizedBox(height: 5),
            TextField(
                maxLength: 20,
                decoration: textFieldDecorator,
                obscureText: true,
                onChanged: (text) {
                  doublePassword = text;
                }
            ),
            const SizedBox(height: 20),
            blocError.state is ChangeErrorState?
            const ErrorsWidget():const SizedBox(),
            ElevatedButton(onPressed:(){
                if(email.trim().isEmpty || password.trim().isEmpty|| doublePassword.trim().isEmpty){
                  blocError.add(const ChangeErrorEvent(error: "Заполните поля!"));
                  return;
                }else if(password.trim().length<8){
                  blocError.add(const ChangeErrorEvent(error: "Пароль не может быть менее 8 символов!!"));
                  return;
                }else if(!EmailValidator.validate(email.trim())){
                 blocError.add(const ChangeErrorEvent(error: "Невалидная почта"));
                   return;
                }else if(password.trim()!=doublePassword.trim()){
                    blocError.add(const ChangeErrorEvent(error: "Пароли не совпадают!"));
                    return;
                }else{
                  try{
                    userData.add(SetUserData(data: {"email":email,"password":password,"name":"","surname":""}));
                    blocError.add(const ChangeErrorEvent(error:""));
                    if(userData.state is UserDataSuccessState){
                      Navigator.pushNamed(context, '/createcode');
                    }
                  }catch(e){
                    blocError.add(const ChangeErrorEvent(error:"Ошибка в отправке данных!"));
                  }

                  return;
                }
            }, child:const Text('Sign up')),
           const SizedBox(height: 10,),
           GestureDetector(
             onTap: (){
               Navigator.pushNamed(context, '/login');
             },
             child:const Text("К авторизации >") ,
           ),
           const SizedBox(height: 20,),
           userData.state is UserDataUnExitState? const Text("Ошибка в отправке данных!",style: TextStyle(color: Colors.deepOrange),):const SizedBox(),
          ],
        ),
      ),
      ),
    );

  }
}
