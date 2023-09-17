import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:untitled1/data/draft_secure.dart';
import 'package:untitled1/data/secure_data.dart';

abstract class DraftEvent extends Equatable {
  const DraftEvent();

  @override
  List<Object> get props => [];
}

/*class AppData extends AppEvent {

}*/

class GetDraft extends DraftEvent{
  const GetDraft();
}

class HasDraft extends DraftEvent{
  const HasDraft();
}

class SetDraft extends DraftEvent{
  final String type;
  final Map<String,dynamic> draft;
  const SetDraft({required this.draft,required this.type});
}

class DeleteDraft extends DraftEvent{
  final String id;
  const DeleteDraft({required this.id});
}


abstract class DraftState extends Equatable {
  const DraftState();

  @override
  List<Object> get props => [];
}


class DraftSuccessState extends DraftState {
  final List<Map<String,dynamic>> draft;
  const DraftSuccessState(this.draft);


}

class DraftFailState extends DraftState {
  const DraftFailState();

}

class MiddleDraftState extends DraftState {
  const MiddleDraftState();

}



class DraftBloc extends Bloc<DraftEvent,DraftState>{
  static String draft = "draft";
  final DraftData draftData;
  DraftBloc({required this.draftData}) : super(const DraftFailState()) {
    on<DraftEvent>((event,emit)async{
      if(event is GetDraft){
        final result = await draftData.getData(draft);
        print(result);
        print("draft");
        emit(DraftSuccessState(result));
      }else if(event is SetDraft){
        List<Map<String,dynamic>> getdraft = await draftData.getData("draft");
        if(event.type=='yes' && getdraft.isNotEmpty){
          getdraft  = getdraft.map((e){
            if(event.draft['id']==e['id']){
              e = {...event.draft};
            }
            return e;
          }).toList();
        }else{
          getdraft.add(event.draft);
        }
        await draftData.setData(value: getdraft, key: draft);
        emit(const MiddleDraftState());
        emit(DraftSuccessState(getdraft));
      }else if(event is DeleteDraft){
        final getdraft = await draftData.getData("draft");
        await draftData.setData(value: getdraft.where((element) => element['id']!=event.id).toList(), key: draft);
        emit(const MiddleDraftState());
        emit(DraftSuccessState(getdraft));
      }
    },
    );
    add(const GetDraft());
  }
}