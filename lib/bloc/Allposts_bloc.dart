import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:untitled1/data/data.dart';
import 'package:untitled1/data/secure_data.dart';

abstract class AllBlocEvent extends Equatable {
  const AllBlocEvent();

  @override
  List<Object> get props => [];
}

/*class AppData extends AppEvent {

}*/

class GetPostsData extends AllBlocEvent {
  const GetPostsData();
}
class SwipeData extends AllBlocEvent {
  const SwipeData();
}

class GetSearchPostsData extends AllBlocEvent {
  final String search;
  const GetSearchPostsData({required this.search});
}

class GetMyPosts extends AllBlocEvent {

  const GetMyPosts();
}



abstract class AllBlocState extends Equatable {
  const AllBlocState();

  @override
  List<Object> get props => [];
}


class PostSuccessState extends AllBlocState {
  final List<Map<String,dynamic>> posts;
  const PostSuccessState(this.posts);

  @override
  List<Object> get props => [posts];

}

class PostsBeginState extends AllBlocState {
  const PostsBeginState();

}

class SwipeBeginState extends AllBlocState {
  final List<Map<String,dynamic>> posts;
  const SwipeBeginState(this.posts);

}

class PostsFailState extends AllBlocState {
  const PostsFailState();

}

class MiddlePostsState extends AllBlocState  {
  const MiddlePostsState();

}



class PostsBloc extends Bloc<AllBlocEvent,AllBlocState>{
  final RemoteConfing dataBase;
  final SecureData secureData;
  PostsBloc({required this.dataBase,required this.secureData}) : super(const PostsBeginState()) {
    print("I AM POST");
    List<Map<String,dynamic>> posts =[];
    on<AllBlocEvent>((event,emit)async{
      if(event is GetPostsData){
          try{
            final result = await dataBase.getListData();
            emit(PostSuccessState(result));
            posts = [...result];
          //  print(result);
          }catch(e){
            emit(const PostsFailState());
          }

      }else if(event is GetSearchPostsData){
        emit(const MiddlePostsState());
        final List<Map<String,dynamic>> listSearch =event.search==''? posts : posts.where((element){
          print(element['title'].toLowerCase().contains(event.search.toLowerCase()));
          return element['title'].toLowerCase().contains(event.search.toLowerCase());}).toList();
        emit(PostSuccessState(listSearch));
      }else if(event is SwipeData){
        emit(SwipeBeginState(posts));
        try{
          final result = await dataBase.getListData();
          emit(PostSuccessState(result));
          posts = [...result];
          //  print(result);
        }catch(e){
          emit(PostSuccessState(posts));
        }
      }
    },
    );
    add(const GetPostsData());
  }
}