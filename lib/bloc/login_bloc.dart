import 'dart:async';
import 'package:bloc/bloc.dart';
import 'dart:convert';
import 'package:equatable/equatable.dart';


abstract class EmailEvent extends Equatable{
  const EmailEvent();
  @override
  List<Object> get props => [];
}

class ChangeEmailEvent extends EmailEvent{
  final String email;
  const ChangeEmailEvent({required this.email});
  @override
  List<Object> get props => [email];
}




abstract class EmailState extends Equatable{
  const EmailState();
  @override
  List<Object> get props => [];
}

class ChangeEmailState extends EmailState{
  final String email;
  const ChangeEmailState({required this.email});
  @override
  List<Object> get props => [email];
}
class BeginEmailState extends EmailState{
  const BeginEmailState();
}

class MiddleEmailState extends EmailState{
  const MiddleEmailState();
}
class EmailErrorState extends EmailState{
  const EmailErrorState();
}




class EmailBloc extends Bloc<EmailEvent,EmailState>{

  EmailBloc() : super(const BeginEmailState()){
    on<EmailEvent>((event,emit)async{
      if(event is ChangeEmailEvent){
        emit(const MiddleEmailState());
        emit(ChangeEmailState(email: event.email));
      }
    });

  }

}