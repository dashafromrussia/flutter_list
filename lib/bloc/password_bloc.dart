import 'dart:async';
import 'package:bloc/bloc.dart';
import 'dart:convert';
import 'package:equatable/equatable.dart';


abstract class PassEvent extends Equatable{
  const PassEvent();
  @override
  List<Object> get props => [];
}

class ChangePassEvent extends PassEvent{
  final String password;
  const ChangePassEvent({required this.password});
  @override
  List<Object> get props => [password];
}




abstract class PassState extends Equatable{
  const PassState();
  @override
  List<Object> get props => [];
}

class ChangePassState extends PassState{
  final String password;
  const ChangePassState({required this.password});
  @override
  List<Object> get props => [password];
}
class BeginPassState extends PassState{
  const BeginPassState();
}

class MiddlePassState extends PassState{
  const MiddlePassState();
}
class PassErrorState extends PassState{
  const PassErrorState();
}




class PassBloc extends Bloc<PassEvent,PassState>{

  PassBloc() : super(const BeginPassState()){
    on<PassEvent>((event,emit)async{
      if(event is ChangePassEvent){
        emit(const MiddlePassState());
        emit(ChangePassState(password: event.password));
      }
    });

  }

}