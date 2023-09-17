import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:untitled1/data/secure_data.dart';

abstract class CookieEvent extends Equatable {
  const CookieEvent();

  @override
  List<Object> get props => [];
}

/*class AppData extends AppEvent {

}*/

class GetCookie extends CookieEvent {
  const GetCookie();
}

class SetCookie extends CookieEvent{
  final String cookie;
  const SetCookie({required this.cookie});
}

class DeleteCookie extends CookieEvent {
  const DeleteCookie();
}


abstract class CookieState extends Equatable {
  const CookieState();

  @override
  List<Object> get props => [];
}


class CookieSuccessState extends CookieState {
  final String cookie;
  const CookieSuccessState(this.cookie);

  @override
  List<Object> get props => [cookie];

}

class CookieFailState extends CookieState {
  const CookieFailState();

}

class MiddleState extends CookieState {
  const MiddleState();

}



class CookieBloc extends Bloc<CookieEvent,CookieState>{
  static String cookie = "cookie";
 final SecureData cookieData;
  CookieBloc({required this.cookieData}) : super(const CookieFailState()) {
    on<CookieEvent>((event,emit)async{
      if(event is GetCookie){
        final result = await cookieData.getSessionId(cookie);
        final String cookieResult = result is String ? result : '';
        print(cookieResult);
        print("cookkkk");
        emit(CookieSuccessState(cookieResult));
      }else if(event is SetCookie){
        await cookieData.setSessionId(key: cookie,value: event.cookie);
        emit(const MiddleState());
        emit(CookieSuccessState(event.cookie));
      }else if(event is DeleteCookie){
        await cookieData.deleteSessionId(cookie);
        emit(const CookieFailState());
      }
    },
    );
    add(const GetCookie());
  }
}