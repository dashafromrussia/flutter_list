import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:untitled1/data/data.dart';
import 'package:untitled1/data/secure_data.dart';

abstract class UpdateEvent extends Equatable {
  const UpdateEvent();

  @override
  List<Object> get props => [];
}

/*class AppData extends AppEvent {

}*/

class UpdatePostEvent extends UpdateEvent {
  final Map<String,dynamic> data;
  const UpdatePostEvent({required this.data});
}

class SavePostEvent extends UpdateEvent {
  final Map<String,dynamic> data;
  const SavePostEvent({required this.data});
}

class DeletePostEvent extends UpdateEvent {
  final Map<String,dynamic> data;
  const DeletePostEvent({required this.data});
}
abstract class UpdateState extends Equatable {
  const UpdateState();

  @override
  List<Object> get props => [];
}

//update
class UpdateSuccessState extends UpdateState {
  const UpdateSuccessState();


}

class UpdateBeginState extends UpdateState {
  const UpdateBeginState();

}

class UpdateFailState extends UpdateState {
  const UpdateFailState();

}
//save
class SaveSuccessState extends UpdateState {
  const SaveSuccessState();


}

class SaveBeginState extends UpdateState {
  const SaveBeginState();

}

class SaveFailState extends UpdateState {
  const SaveFailState();

}

//delete
class DeleteSuccessState extends UpdateState {
  const DeleteSuccessState();


}

class DeleteBeginState extends UpdateState {
  const DeleteBeginState();

}

class DeleteFailState extends UpdateState {
  const DeleteFailState();

}

class UpdateBloc extends Bloc<UpdateEvent,UpdateState>{
  final RemoteConfing dataBase;
  final SecureData secureData;
  UpdateBloc({required this.dataBase,required this.secureData}) : super(const UpdateBeginState()) {

    on<UpdateEvent>((event,emit)async{
      if(event is UpdatePostEvent){
        try{
          final result = await dataBase.updatePost(event.data);
          emit(const UpdateSuccessState());
          //  print(result);
        }catch(e){
          emit(const UpdateFailState());
        }
      }else if(event is SavePostEvent){
        try{
          final cookData = await secureData.getSessionId('cookie');
          final String cook = cookData??'';
          final body = {"name":cook,...event.data,"comments":0,"views":0,"likes":[]};
          final result = await dataBase.setPostData(body);
          emit(const SaveSuccessState());
          //  print(result);
        }catch(e){
          emit(const SaveFailState());
        }
      }else if(event is DeletePostEvent){
        try{
          final result = await dataBase.deletePostData(event.data);
          emit(const DeleteSuccessState());
          //  print(result);
        }catch(e){
          emit(const DeleteFailState());
        }
      }
    },
    );
  }
}