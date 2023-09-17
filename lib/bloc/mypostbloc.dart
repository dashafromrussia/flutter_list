import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:untitled1/data/data.dart';
import 'package:untitled1/data/secure_data.dart';

abstract class MyPostBlocEvent extends Equatable {
  const MyPostBlocEvent();

  @override
  List<Object> get props => [];
}

/*class AppData extends AppEvent {

}*/



class GetMySearchPostsData extends MyPostBlocEvent {
  final String search;
  const GetMySearchPostsData({required this.search});
}

class GetMyPosts extends MyPostBlocEvent {

  const GetMyPosts();
}



abstract class MyPostBlocState extends Equatable {
  const MyPostBlocState();

  @override
  List<Object> get props => [];
}


class MyPostSuccessState extends MyPostBlocState {
  final List<Map<String,dynamic>> posts;
  const MyPostSuccessState(this.posts);

  @override
  List<Object> get props => [posts];

}

class MyPostsBeginState extends MyPostBlocState {
  const MyPostsBeginState();

}

class MyPostsFailState extends MyPostBlocState {
  const MyPostsFailState();

}

class MyMiddlePostsState extends MyPostBlocState {
  const MyMiddlePostsState();

}



class MyPostsBloc extends Bloc<MyPostBlocEvent,MyPostBlocState>{
  final RemoteConfing dataBase;
  final SecureData secureData;
  MyPostsBloc({required this.dataBase,required this.secureData}) : super(const MyPostsBeginState()) {
    List<Map<String,dynamic>> posts =[];

    on<MyPostBlocEvent>((event,emit)async{
      if(event is GetMyPosts){
        try{
          final cookData = await secureData.getSessionId('cookie');
          print("cookie data${cookData}");
          final String cook = cookData??'';
          final result = await dataBase.getMyListData({"name":cook});
          emit(MyPostSuccessState(result));
          posts = [...result];
          print(result);
        }catch(e){
          emit(const MyPostsFailState());
        }
      }else if(event is GetMySearchPostsData){
        emit(const MyMiddlePostsState());
        final List<Map<String,dynamic>> listSearch =event.search==''? posts : posts.where((element){
          print(element['title'].toLowerCase().contains(event.search.toLowerCase()));
          return element['title'].toLowerCase().contains(event.search.toLowerCase());}).toList();
        emit(MyPostSuccessState(listSearch));
      }
    },
    );
    add(const GetMyPosts());
  }
}