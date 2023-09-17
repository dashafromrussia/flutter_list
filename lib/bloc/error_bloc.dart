import 'dart:async';
import 'package:bloc/bloc.dart';
import 'dart:convert';
import 'package:equatable/equatable.dart';


abstract class ErrorEvent extends Equatable{
  const ErrorEvent();
  @override
  List<Object> get props => [];
}

class ChangeErrorEvent extends ErrorEvent{
  final String error;
  const ChangeErrorEvent({required this.error});
  @override
  List<Object> get props => [error];
}




abstract class ErrorState extends Equatable{
  const ErrorState();
  @override
  List<Object> get props => [];
}

class ChangeErrorState extends ErrorState{
  final String error;
  const ChangeErrorState({required this.error});
  @override
  List<Object> get props => [error];
}
class BeginErrorState extends ErrorState{
  const BeginErrorState();
}

class MiddleErrorState extends ErrorState{
  const MiddleErrorState();
}
class EmailErrorState extends ErrorState{
  const EmailErrorState();
}




class ErrorBloc extends Bloc<ErrorEvent,ErrorState>{

  ErrorBloc() : super(const BeginErrorState()){
    on<ErrorEvent>((event,emit)async{
      if(event is ChangeErrorEvent){
        emit(const MiddleErrorState());
        emit(ChangeErrorState(error: event.error));
      }
    });

  }

}