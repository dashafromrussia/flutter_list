import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:untitled1/data/data.dart';
import 'package:untitled1/data/secure_data.dart';

abstract class UserDataEvent extends Equatable {
  const UserDataEvent();

  @override
  List<Object> get props => [];
}

/*class AppData extends AppEvent {

}*/
class GetCookData extends UserDataEvent {
  const GetCookData();
}
class ExitUser extends UserDataEvent {
  const ExitUser();
}
class GetUserData extends UserDataEvent {
  final String email;
  final String pass;
  const GetUserData({required this.email,required this.pass});
}

class SetUserData extends UserDataEvent{
  final Map<String,dynamic> data;
  const SetUserData({required this.data});
}

class DeleteUserData extends UserDataEvent {
  const DeleteUserData();
}
class UpdateUserData extends UserDataEvent {
  final Map<String,dynamic> data;
  const UpdateUserData({required this.data});
}




abstract class UserDataState extends Equatable {
  const UserDataState();

  @override
  List<Object> get props => [];
}


class UserDataSuccessState extends UserDataState {

  const UserDataSuccessState();

  @override
  List<Object> get props => [];

}

class UserDataFailState extends UserDataState {
  const UserDataFailState();

}
class UserWrongPassState extends UserDataState {
  const UserWrongPassState ();

}

class UserDataUnExitState extends UserDataState {
  const UserDataUnExitState();

}


class MiddleUserState extends UserDataState {
  const MiddleUserState();

}
class SuccessSignInState extends UserDataState {
  final Map<String,dynamic> myData;
  const SuccessSignInState({required this.myData});

}
class SuccessExitState extends UserDataState {
  const SuccessExitState();

}
class SuccessDeleteState extends UserDataState {
  const SuccessDeleteState();

}

class SuccessUpdateState extends UserDataState {
  const SuccessUpdateState();

}

class UserDataBloc extends Bloc<UserDataEvent,UserDataState>{
 final SecureData secureData;
  final RemoteConfing dataBase;

  UserDataBloc({required this.dataBase,required this.secureData}) : super(const MiddleUserState()) {
  Map<String,dynamic> myData = {};
    on<UserDataEvent>((event,emit)async{
      if(event is SetUserData){
       try{
         final int insertId = await dataBase.setUserData(event.data);
         emit(const UserDataSuccessState());
       }catch(e){
         emit(const UserDataUnExitState());
         await  Future.delayed(const Duration(seconds: 2), () {
           emit(const UserDataFailState()); // Prints after 1 second.
         });
       }
      }else if(event is GetUserData){
        emit(const MiddleUserState());
        try{
          final result = await dataBase.getUserData({"email":event.email.trim(),"password":event.pass.trim()});
          await secureData.setSessionId(value: event.email, key:'cookie');
          myData = result;
          emit(SuccessSignInState(myData:myData));
        }catch(e){
          emit(const UserWrongPassState());
        await  Future.delayed(const Duration(seconds: 2), () {
          emit(const UserDataFailState()); // Prints after 1 second.
          });
        }
      }else if(event is GetCookData){
       // emit(const MiddleState());
        final getCook = await secureData.getSessionId('cookie');
        final String cook = getCook??"";
        if(cook!=""){
          final result = await dataBase.getUserCookData({"email":cook.trim()});
          myData = result;
          emit(SuccessSignInState(myData:myData));
        }else{
          emit(const UserDataFailState());
        }
        print(state);
      }
      else if(event is DeleteUserData){
        final getCook = await secureData.getSessionId('cookie');
        final String cook = getCook??"";
       await dataBase.deleteUserData({"email":cook});
       await secureData.deleteSessionId("cookie");
        emit(const UserDataFailState());
      }else if(event is UpdateUserData){
        emit(const MiddleUserState());
        await dataBase.updateUserData(event.data);
        myData["name"] = event.data["name"];
        myData["surname"] = event.data["surname"];
       // myData = {...myData,...event.data};
        emit(SuccessSignInState(myData:myData));
      }else if(event is ExitUser){
        await secureData.deleteSessionId("cookie");
        emit(const UserDataFailState());
      }
    },
    );
   add(const GetCookData());

  }
}