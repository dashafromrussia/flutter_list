import 'package:untitled1/bloc/Allposts_bloc.dart';
import 'package:untitled1/bloc/background_bloc.dart';
import 'package:untitled1/bloc/code.dart';
import 'package:untitled1/bloc/comment_bloc.dart';
import 'package:untitled1/bloc/cookie_bloc.dart';
import 'package:untitled1/bloc/draft_bloc.dart';
import 'package:untitled1/bloc/drawer_bloc.dart';
import 'package:untitled1/bloc/error_bloc.dart';
import 'package:untitled1/bloc/login_bloc.dart';
import 'package:untitled1/bloc/mypostbloc.dart';
import 'package:untitled1/bloc/one_itemBloc.dart';
import 'package:untitled1/bloc/password_bloc.dart';
import 'package:untitled1/bloc/saveUser_bloc.dart';
import 'package:untitled1/bloc/update_bloc.dart';
import 'package:untitled1/data/data.dart';
import 'package:untitled1/data/draft_secure.dart';
import 'package:untitled1/data/secure_data.dart';
import 'package:untitled1/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/screens/AboutMe.dart';
import 'package:untitled1/screens/CommentsScreen.dart';
import 'package:untitled1/screens/DrawerWidget.dart';
import 'package:untitled1/screens/MyDataScreen.dart';
import 'package:untitled1/screens/auth_widget.dart';
import 'package:untitled1/screens/createCode_widget.dart';
import 'package:untitled1/screens/createpost_widget.dart';
import 'package:untitled1/screens/notif_screen.dart';
import 'package:untitled1/screens/regist_widget.dart';
import 'package:untitled1/screens/signup_widget.dart';
import 'package:untitled1/screens/update_widget.dart';

AppFactory makeAppFactory() => _AppFactoryDefault();

class _AppFactoryDefault implements AppFactory {
  final _diContainer = _DIContainer();

  _AppFactoryDefault();

  /* @override
  Widget makeApp() {
    return
     MyApp(screenFactory: _diContainer.makeScreenFactory());
  }*/
  @override
  Widget makeApp() => MultiBlocProvider(
      providers: [
        BlocProvider<CookieBloc>(
            create: (context) => _diContainer._makeCookieBloc()),
        BlocProvider<UserDataBloc>(
            create: (context) =>_diContainer._makeUserDataBLoc()),
        BlocProvider<BackgroundBloc>(
            lazy: false,
            create: (context) =>_diContainer._makeBackgroundBloc()),
      ],
      child: MyApp(screenFactory: _diContainer.makeScreenFactory()));
}




class _DIContainer {

  _DIContainer();


  final RemoteConfing _makeRemote= DataBaseConfig();

 final SecureData _secureData = SecureDataProvider();

  ScreenFactory makeScreenFactory() => ScreenFactoryDefault(this);

  CookieBloc _makeCookieBloc()=> CookieBloc(cookieData: _secureData);

  CodeBloc _makeCodeBloc()=> CodeBloc(codeData: _secureData);

  ErrorBloc _errorBloc()=> ErrorBloc();

  EmailBloc _emailBloc()=> EmailBloc();

  PassBloc _passBloc()=> PassBloc();

  BackgroundBloc _makeBackgroundBloc()=> BackgroundBloc();

  UserDataBloc _makeUserDataBLoc()=> UserDataBloc(dataBase: _makeRemote,secureData:_secureData);

  PostsBloc _makePostsBloc()=> PostsBloc(dataBase: _makeRemote,secureData: _secureData);

  MyPostsBloc _makeMyPostsBloc()=> MyPostsBloc(dataBase: _makeRemote,secureData: _secureData);

  UpdateBloc _makeUpdateBloc()=> UpdateBloc(dataBase: _makeRemote, secureData: _secureData);

  DraftData _makeDraft()=>  SecureDraftProvider();

  DraftBloc _makeDraftBloc()=> DraftBloc(draftData: _makeDraft());

 DrawerBloc _makeDrawer(String select)=> DrawerBloc(select:select);

 OnePostBloc _makeOneBloc(int id)=>OnePostBloc(dataBase:_makeRemote, secureData: _secureData, id: id);

 DataCommentBloc _makeComments(int id)=> DataCommentBloc(remoteConfing: _makeRemote, idpost: id);
}


class ScreenFactoryDefault implements ScreenFactory {
  final _DIContainer _diContainer;


  ScreenFactoryDefault(this._diContainer);


  @override
  Widget makeCodeScreen() {
 return MultiBlocProvider(
     providers: [
       BlocProvider<ErrorBloc>(
           create: (context) =>_diContainer._errorBloc()),
       BlocProvider<CodeBloc>(
           create: (context) =>_diContainer._makeCodeBloc()),
     ],
     child: const CodeScreen());
  }

  @override
  Widget makeListScreen() {
  return  MultiBlocProvider(
      providers: [
        BlocProvider<DraftBloc>(
            create: (context) =>_diContainer._makeDraftBloc()),
        BlocProvider<MyPostsBloc>(
            create: (context) =>_diContainer._makeMyPostsBloc()),
        BlocProvider<PostsBloc>(
            create: (context) =>_diContainer._makePostsBloc()),
        BlocProvider<ErrorBloc>(
            create: (context) =>_diContainer._errorBloc()),
        /*BlocProvider<BackgroundBloc>(
            create: (context) =>_diContainer._makeBackgroundBloc()),*/
      ],
      child: ListDataWidget(drawer:makeDrawer('Main'),));
  }

  @override
  Widget makeUpdateScreen(Map<String,dynamic> data) {
    return  MultiBlocProvider(
        providers: [
          BlocProvider<DraftBloc>(
              create: (context) =>_diContainer._makeDraftBloc()),
          BlocProvider<UpdateBloc>(
              create: (context) =>_diContainer._makeUpdateBloc()),
          BlocProvider<PostsBloc>(
              create: (context) =>_diContainer._makePostsBloc()),
          BlocProvider<ErrorBloc>(
              create: (context) =>_diContainer._errorBloc()),
          /*BlocProvider<BackgroundBloc>(
            create: (context) =>_diContainer._makeBackgroundBloc()),*/
        ],
        child: UpdateWidget(data:data));
  }

  @override
  Widget makeLoginScreen() {
return MultiBlocProvider(
    providers: [
      BlocProvider<PassBloc>(
          create: (context) =>_diContainer._passBloc()),
      BlocProvider<ErrorBloc>(
          create: (context) =>_diContainer._errorBloc()),
      BlocProvider<EmailBloc>(
          create: (context) =>_diContainer._emailBloc()),
    ],
    child: const Login());
  }

  @override
  Widget makeSignUpScreen() {
    return MultiBlocProvider(
        providers: [
          BlocProvider<ErrorBloc>(
              create: (context) =>_diContainer._errorBloc()),
        ],
        child: const SignUp());
  }

  @override
  Widget makeCreateCodeScreen() {
    return MultiBlocProvider(
        providers: [
          BlocProvider<CodeBloc>(
              create: (context) =>_diContainer._makeCodeBloc()),
          BlocProvider<ErrorBloc>(
              create: (context) =>_diContainer._errorBloc()),
        ],
        child: const CreateCode());
  }

  @override
  Widget makeAboutMe() {
    return  AboutMeScreen(drawer: makeDrawer('About'),);
  }

  @override
  Widget makeDrawer(String select) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DrawerBloc>(
            create: (context) => _diContainer._makeDrawer(select)),
      ],
      child: DrawerWidget(),
    );
  }

  @override
  Widget makeCreateScreen() {
    return MultiBlocProvider(
    providers: [
      BlocProvider<DraftBloc>(
          create: (context) =>_diContainer._makeDraftBloc()),
    BlocProvider<UpdateBloc>(
    create: (context) =>_diContainer._makeUpdateBloc()),
    BlocProvider<PostsBloc>(
    create: (context) =>_diContainer._makePostsBloc()),
    BlocProvider<ErrorBloc>(
    create: (context) =>_diContainer._errorBloc()),
    ],
    child: const CreateWidget());
  }


  @override
  Widget makeWithOutScreen() {
   return MultiBlocProvider(
        providers: [
          BlocProvider<PostsBloc>(
              create: (context) =>_diContainer._makePostsBloc()),
          BlocProvider<ErrorBloc>(
              create: (context) =>_diContainer._errorBloc()),
        ],
        child: const WithOutReg());
  }

  @override
  Widget makeOneArtScreen(int id) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<OnePostBloc>(
              create: (context) =>_diContainer._makeOneBloc(id)),
          BlocProvider<ErrorBloc>(
              create: (context) =>_diContainer._errorBloc()),
        ],
        child: const WithOutReg());
  }

  @override
  Widget makeComments(int id) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<DataCommentBloc>(
              create: (context) =>_diContainer._makeComments(id)),
          BlocProvider<ErrorBloc>(
              create: (context) =>_diContainer._errorBloc()),
        ],
        child:Comments(id: id));
  }

  @override
  Widget makeMyData() {
  return const Mydata();
  }
  @override
  Widget makeNotif() {
    return const NotifScreen();
  }

}

