import 'dart:async';
import 'package:bloc/bloc.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:local_auth/local_auth.dart';
import 'package:untitled1/screens/regist_widget.dart';

abstract class StatusEvent extends Equatable{
  const StatusEvent();
  @override
  List<Object> get props => [];
}

class MiddleStatusEvent extends StatusEvent{
  const MiddleStatusEvent();
}

class OnlineEvent extends StatusEvent{

  const OnlineEvent();
  @override
  List<Object> get props => [];
}
class OfflineEvent extends StatusEvent{

  const OfflineEvent();
  @override
  List<Object> get props => [];
}



abstract class StatusState extends Equatable{
  const StatusState();
  @override
  List<Object> get props => [];
}

class OnlineStatusState extends StatusState{

  const OnlineStatusState();
  @override
  List<Object> get props => [];
}
class OfflineStatusState extends StatusState{
  const OfflineStatusState();
  @override
  List<Object> get props => [];
}

class BeginStatusState extends StatusState{
  const BeginStatusState();
}

class MiddleStatusState extends StatusState{
  const MiddleStatusState();
}


Future<void> _authenticate() async {
  final LocalAuthentication auth = LocalAuthentication();
  bool authenticated = false;
  try {
   /* setState(() {
      _isAuthenticating = true;
      _authorized = 'Authenticating';
    });*/
    authenticated = await auth.authenticate(
      localizedReason: 'Let OS determine authentication method',
      options: const AuthenticationOptions(
        stickyAuth: true,
      ),
    );
    /* setState(() {
        _isAuthenticating = false;
      });*/
  } on PlatformException catch (e) {
    print(e);
    /*  setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });*/
    return;
  }

  //setState(() => _authorized = authenticated ? 'Authorized' : 'Not Authorized');
}


class BackgroundBloc extends Bloc<StatusEvent,StatusState>{

  BackgroundBloc() : super(const BeginStatusState()) {
    print("uuuuuuuuu");
   int count = 0;
   StreamSubscription<FGBGType> subscription = FGBGEvents.stream.listen((event) async{
         if(event==FGBGType.background){
           add(const OfflineEvent());
           print("OFFLINE");
         }else if(event==FGBGType.foreground){
           print("ONLINE");
           count++;
           print(count);
      //  await _authenticate();
           add(const OnlineEvent());
         }

           
      });
print("aaaaaaaaaaaaa");
    on<StatusEvent>((event,emit)async{
      if(event is OnlineEvent){
        emit(const OnlineStatusState());
      }else if(event is OfflineEvent){
        emit(const OfflineStatusState());
      }else if(event is MiddleStatusEvent){
        emit(const MiddleStatusState());
      }
    });

  }

}