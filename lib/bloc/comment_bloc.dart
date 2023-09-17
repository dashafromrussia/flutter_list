import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:untitled1/data/data.dart';


abstract class DataCommentEvent extends Equatable {
  const DataCommentEvent();

  @override
  List<Object> get props => [];
}

/*class AppData extends AppEvent {

}*/

class GetDataComments extends DataCommentEvent {

  const GetDataComments();
}


class GetSuccessComments extends DataCommentEvent {
  final List<Map<String,dynamic>> data;
  const GetSuccessComments({required this.data});
}

class SendComment extends DataCommentEvent{
  final Map<String,dynamic> data;
  const SendComment({required this.data});
}



abstract class DataCommentsState extends Equatable {
  const DataCommentsState();

  @override
  List<Object> get props => [];
}



class BeginLoadCommentsState extends DataCommentsState {

  const BeginLoadCommentsState();

  @override
  List<Object> get props => [];

}


class MiddleCommentState extends DataCommentsState{
  const MiddleCommentState();

}

class GetCommentState extends DataCommentsState{
  final List<Map<String,dynamic>> data;
  GetCommentState({required this.data}){
    print(data);
  }

}


class ErrorState extends DataCommentsState{
  const ErrorState();

}



class DataCommentBloc extends Bloc<DataCommentEvent,DataCommentsState>{
  RemoteConfing remoteConfing;
  List<Map<String,dynamic>> list = [];
  final int idpost;
  DataCommentBloc({required this.remoteConfing,required this.idpost}) : super(const MiddleCommentState()) {
    on<DataCommentEvent>((event,emit)async{
      print('gggfffff');
      if(event is GetDataComments){
        emit(const BeginLoadCommentsState());
        try{
          List<Map<String,dynamic>> data = await remoteConfing.getComments({"id":idpost});
          list = data;
          emit(GetCommentState(data: data));
        }catch(e){
          emit(const ErrorState());
        }finally{

        }
      }else if(event is SendComment){
        try{
          await remoteConfing.setComment(event.data);
          await remoteConfing.updateComments({'id':idpost,"comments":list.length+1});
          list.add(event.data);
        }catch(e){
          emit(const ErrorState());
        }
      }
    },
    );
    add(const GetDataComments());
  }


}