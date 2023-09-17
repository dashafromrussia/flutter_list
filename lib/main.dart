import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/bloc/background_bloc.dart';
import 'package:untitled1/bloc/code.dart';
import 'package:untitled1/bloc/cookie_bloc.dart';
import 'package:untitled1/bloc/error_bloc.dart';
import 'package:untitled1/bloc/login_bloc.dart';
import 'package:untitled1/bloc/password_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:untitled1/bloc/saveUser_bloc.dart';
import 'package:untitled1/di_container.dart';
import 'package:untitled1/screens/AboutMe.dart';
import 'package:untitled1/screens/auth_widget.dart';
import 'package:untitled1/screens/regist_widget.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';



abstract class AppFactory {
  Widget makeApp();
}

final appFactory = makeAppFactory();


/*abstract class MyAppNavigation {
  Map<String, Widget Function(BuildContext)> get routes;
  Route<Object> onGenerateRoute(RouteSettings settings);
  List<Route<dynamic>> onGenerateInitialRoutes(String initialRouteName);
}*/

abstract class ScreenFactory {
  Widget makeCodeScreen();
  Widget makeLoginScreen();
  Widget makeListScreen();
  Widget makeSignUpScreen();
  Widget makeCreateCodeScreen();
  Widget makeAboutMe();
  Widget makeDrawer(String drawer);
  Widget makeUpdateScreen(Map<String,dynamic> data);
  Widget makeCreateScreen();
  Widget makeWithOutScreen();
  Widget makeOneArtScreen(int id);
  Widget makeComments(int id);
  Widget makeMyData();
  Widget makeNotif();
}

void main() {
  runApp(appFactory.makeApp());
}



class MyApp extends StatelessWidget /*implements MyAppNavigation*/ {
  final ScreenFactory screenFactory;
 const MyApp({Key? key,required this.screenFactory}) : super(key: key);


  Map<String, Widget Function(BuildContext)> get routes => {
    '/notif':
    (_)=>screenFactory.makeNotif(),
    '/mydata':(_)=>
      screenFactory.makeMyData(),
    '/code':(_)=>
       screenFactory.makeCodeScreen(),
    '/login':(_)=>
        screenFactory.makeLoginScreen(),
    '/':(_)=>
        screenFactory.makeLoginScreen(),
    '/list':(_)=>
        screenFactory.makeListScreen(),
    '/regist':(_)=>
        screenFactory.makeSignUpScreen(),
    '/createcode':(_)=>
        screenFactory.makeCreateCodeScreen(),
    '/aboutme':(_)=> screenFactory.makeAboutMe(),
    '/create':(_)=> screenFactory.makeCreateScreen(),
    '/without':(_)=>screenFactory.makeWithOutScreen(),
  };


  List<Route> onGenerateInitialRoutes(String initialRouteName) {
    // TODO: implement onGenerateInitialRoutes
    throw UnimplementedError();
  }


  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    print("NAMEEEEEEEEEEEEEEEEEEEEEEEEE${settings.name}");
    switch (settings.name) {
      case '/updates':
        final arguments = settings.arguments;
        final Map<String,dynamic> args =arguments is Map? arguments as Map<String,dynamic>:{};
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => screenFactory.makeUpdateScreen(args),
        );
      case '/oneart':
        final arguments = settings.arguments;
        final int args =arguments is int ? arguments:0;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => screenFactory.makeOneArtScreen(args),
        );
      case '/comments':
        final arguments = settings.arguments;
        final int args =arguments is int ? arguments:0;
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => screenFactory.makeComments(args),
        );
      default:
        const widget = Text('Navigation error!!!');
        return MaterialPageRoute(builder: (_) => widget);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: routes,
       onGenerateRoute: onGenerateRoute,
       initialRoute:'/',
    );
  }
}








class CodeScreen extends StatelessWidget {
  const CodeScreen({Key? key}) : super(key: key);

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      final LocalAuthentication auth = LocalAuthentication();
      authenticated = await auth.authenticate(
        localizedReason:
        'Scan your fingerprint  to authenticate',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } on PlatformException catch (e) {
      throw(Exception());
    }
  }


  @override
  Widget build(BuildContext context) {
    final blocCode = context.watch<CodeBloc>();
    final blocError = context.watch<ErrorBloc>();
    final String code =blocCode.state is CodeSuccessState? (blocCode.state as CodeSuccessState).code : '';
    return Scaffold(
        appBar: AppBar(
           automaticallyImplyLeading:false,
          title: const Text('Plugin example app'),
        ),
        body:Container(
            padding:const EdgeInsets.symmetric(horizontal: 50),
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                    decoration:const InputDecoration(
                      hintText: "Enter code",
                      border: OutlineInputBorder(),
                    ),
                    obscureText:true,
                    keyboardType:TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 4,
                    onChanged: (text)async{
                      if(text.length==4){
                        if(text==code){
                          if(Navigator.canPop(context)){
                            Navigator.pop(context);
                          }else{
                            Navigator.pushNamed(context, '/list');
                            /*Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ListDataWidget()),
                            );*/
                          }
                        }else{
                          print("code is not valid");
                         blocError.add(const ChangeErrorEvent(error: "Неверный код!"));
                          bool data =await Vibration.hasVibrator()??false;
                          if (data) {
                            Vibration.vibrate();
                          }

                        }
                      }
                    } // print(email);},
                ),
                blocError.state is ChangeErrorState?
                const ErrorsWidget():const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(onPressed:()
                    async{
                      try{
                        await _authenticateWithBiometrics();
                        if(Navigator.canPop(context)){
                          Navigator.pop(context);
                        }else{
                          Navigator.pushNamed(context, '/list');
                         /* Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ListDataWidget()),
                          );*/
                        }
                      }catch(e){
                      }
                    }, icon: const Icon(Icons.fingerprint_rounded,size: 50,color: Colors.blue,)),
                    const SizedBox(width: 20,),
                    const Text("Войти по отпечатку пальца",textAlign: TextAlign.end,)
                  ],) ,

              ],
            ))
    );
  }
}





