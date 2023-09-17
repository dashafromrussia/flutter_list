import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:untitled1/data/secure_data.dart';

abstract class CodeEvent extends Equatable {
  const CodeEvent();

  @override
  List<Object> get props => [];
}

/*class AppData extends AppEvent {

}*/

class GetCode extends CodeEvent {
  const GetCode();
}

class SetCode extends CodeEvent{
  final String code;
  const SetCode({required this.code});
}

class DeleteCode extends CodeEvent {
  const DeleteCode();
}


abstract class CodeState extends Equatable {
  const CodeState();

  @override
  List<Object> get props => [];
}


class CodeSuccessState extends CodeState {
  final String code;
  const CodeSuccessState(this.code);

  @override
  List<Object> get props => [code];

}

class CodeFailState extends CodeState {
  const CodeFailState();

}

class MiddleCodeState extends CodeState {
  const MiddleCodeState();

}



class CodeBloc extends Bloc<CodeEvent,CodeState>{
  static String code = "code";
 final SecureData codeData;
  CodeBloc({required this.codeData}) : super(const CodeFailState()) {
    on<CodeEvent>((event,emit)async{
      if(event is GetCode){
        final result = await codeData.getSessionId(code);
        final String cookieResult = result is String ? result : '';
        emit(CodeSuccessState(cookieResult));
      }else if(event is SetCode){
        await codeData.setSessionId(key: code,value: event.code);
        emit(const MiddleCodeState());
        emit(CodeSuccessState(event.code));
      }else if(event is DeleteCode){
        await codeData.deleteSessionId(code);
        emit(const CodeFailState());
      }
    },
    );
    add(const GetCode());
  }
}