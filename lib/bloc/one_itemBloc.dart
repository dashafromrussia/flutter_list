import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:untitled1/data/data.dart';
import 'package:untitled1/data/secure_data.dart';

abstract class OneBlocEvent extends Equatable {
  const OneBlocEvent();

  @override
  List<Object> get props => [];
}

/*class AppData extends AppEvent {

}*/



class GetOneData extends OneBlocEvent {

  const GetOneData();
}

class ChangeLike extends OneBlocEvent {

  const ChangeLike();
}

class ChangeViews extends OneBlocEvent {

  const ChangeViews();
}


abstract class OneBlocState extends Equatable {
  const OneBlocState();

  @override
  List<Object> get props => [];
}


class OneSuccessState extends OneBlocState {
  final Map<String,dynamic> posts;
  const OneSuccessState(this.posts);
  @override
  List<Object> get props => [posts];

}

class OneBeginState extends OneBlocState {
  const OneBeginState();

}

class OneFailState extends OneBlocState{
  const OneFailState();

}

class OneMiddlePostsState extends OneBlocState{
  const OneMiddlePostsState();

}

/*class LikesBloc extends Bloc<LikesEvent,LikesState>{

  RemoteConfing remoteConfing = DataBaseConfig();
  LikesBloc() : super(const MiddleLikesState()) {
    on<LikesEvent>((event,emit)async{
      if(event is GetLike){
        List<String> midoldLikes = [];
        emit(const MiddleLikesState());
        print(event.oldLikes);
        print(event.ip);
        print(event.id);
        if(event.oldLikes.contains(event.ip)){
          midoldLikes = event.oldLikes.where((element) => element!=event.ip).toList();
        }else{
          midoldLikes =[...event.oldLikes,event.ip];
        }
        try{
          await remoteConfing.getLike(midoldLikes, event.id);
          emit(ChangeLikesState(data:midoldLikes));
        }catch(e){
          const ErrorState();
        }

      }
    },
    );
  }

}*/

class OnePostBloc extends Bloc<OneBlocEvent,OneBlocState>{
  final int id;
  final RemoteConfing dataBase;
  final SecureData secureData;
  OnePostBloc({required this.dataBase,required this.secureData,required this.id}) : super(const OneBeginState()) {
    Map<String,dynamic> posts = {};
    on<OneBlocEvent>((event,emit)async{
      if(event is GetOneData){
        try{
          posts=await dataBase.getOneData({"id":id});
          await dataBase.setViews({"id":id,'views':posts['views']+1});
          posts['views']++;
          emit(OneSuccessState(posts));
        }catch(e){
          const OneFailState();
        }
      }else if(event is ChangeLike){
        const OneMiddlePostsState();
        String cook = await secureData.getSessionId("cookie")??'';
        if(posts["likes"].contains(cook)){
        posts["likes"] = posts["likes"].where((element) => element!=cook).toList();
        }else{
          posts["likes"]=[...posts["likes"],cook];
        }
        try{
          await dataBase.setLikes({'id':id,'likes': posts["likes"]});
          emit(OneSuccessState(posts));
        }catch(e){
        }
      }
    },
    );
    add(const GetOneData());
  }
}