import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/bloc/cookie_bloc.dart';
import 'package:untitled1/bloc/error_bloc.dart';
import 'package:untitled1/bloc/login_bloc.dart';
import 'package:untitled1/bloc/password_bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'package:local_auth/local_auth.dart';
import 'package:untitled1/bloc/saveUser_bloc.dart';
import 'package:untitled1/screens/regist_widget.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    final blocPass = context.watch<PassBloc>();
    final blocEmail = context.watch<EmailBloc>();
    final blocError = context.watch<ErrorBloc>();
    final userData = context.watch<UserDataBloc>();

    const textStyle = TextStyle(
      fontSize: 16,
      color: Color(0xFF212529),
    );
    const textFieldDecorator = InputDecoration(
      border: OutlineInputBorder(),
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      isCollapsed: true,
      fillColor: Colors.red,
      focusColor: Colors.red,
      hoverColor: Colors.red,
    );
    return
      BlocListener<UserDataBloc, UserDataState>(
        listener: (context, state) {
      if (state is SuccessSignInState) {
        if (userData.state is SuccessSignInState){
          Navigator.pushNamedAndRemoveUntil(context, '/code',(Route<dynamic> route) => false);
          /* Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                MultiBlocProvider(
                    providers: [
                      BlocProvider<ErrorBloc>(
                          create: (context) =>ErrorBloc()),
                      BlocProvider<CodeBloc>(
                          create: (context) => CodeBloc()),
                    ],
                    child: const CodeScreen())),
          );*/
        }
      }
    },
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading:false,
              title: const Text('Auth'),
            ),
            body:
            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const _ErrorMessageWidget(),
                  const Text(
                    'Email',
                    style: textStyle,
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    //   maxLength: 20,
                      decoration: textFieldDecorator,
                      onChanged: (text){
                        blocEmail.add(ChangeEmailEvent(email: text));
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
                        blocPass.add(ChangePassEvent(password: text));
                      }
                  ),
                  blocError.state is ChangeErrorState?
                  const ErrorsWidget():const SizedBox(),
                  Center(child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      userData.state is UserWrongPassState? const Text("You are wrong"):const SizedBox(),
                      ElevatedButton(onPressed:(){
                        if(blocEmail.state is ChangeEmailState && blocPass.state is ChangePassState){
                          if((blocEmail.state as ChangeEmailState).email.trim().isEmpty || (blocPass.state as ChangePassState).password.trim().isEmpty){
                            blocError.add(const ChangeErrorEvent(error: "Заполните поля!"));
                            return;
                          }else if((blocPass.state as ChangePassState).password.trim().length<8){
                            blocError.add(const ChangeErrorEvent(error: "Пароль не может быть менее 8 символов!!"));
                            return;
                          }else if(!EmailValidator.validate((blocEmail.state as ChangeEmailState).email.trim())){
                            blocError.add(const ChangeErrorEvent(error: "невалидная почта"));
                            return;
                          }else{
                            blocError.add(const ChangeErrorEvent(error:""));
                            userData.add(GetUserData(email: (blocEmail.state as ChangeEmailState).email.trim(), pass:(blocPass.state as ChangePassState).password.trim()));
                          }
                        }else{
                          blocError.add(const ChangeErrorEvent(error: "Заполните поля!"));
                        }

                      }, child:const Text('Войти')),
                      const SizedBox(width:15),
                      ElevatedButton(onPressed: (){
                        Navigator.pushNamed(context, '/list');
                        /*Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ListDataWidget()),
                );*/
                      }, child: const Text("Войти без регистрации")),
                      GestureDetector(
                        child: const Text("Регистрация"),
                        onTap: (){
                          Navigator.pushNamed(context, '/regist');
                        },
                      )
                    ],
                  ))
                ],
              ),)),
      );

  }
}

class ErrorsWidget extends StatelessWidget {
  const ErrorsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final blocError = context.watch<ErrorBloc>();
    return(blocError.state as ChangeErrorState).error!="" ?
    Column(
      children: [
        const SizedBox(height: 25),
        Text((blocError.state as ChangeErrorState).error,style:const TextStyle(color:Colors.red)),
        const SizedBox(height: 25)
      ],
    )
        :
    const SizedBox();
  }
}
