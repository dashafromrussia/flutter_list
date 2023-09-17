import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/bloc/background_bloc.dart';
import 'package:untitled1/bloc/comment_bloc.dart';
import 'package:untitled1/bloc/saveUser_bloc.dart';

class Comments extends StatefulWidget {
  final int id;
  const Comments({Key? key,required this.id}) : super(key: key);

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  String comment = '';

  @override
  Widget build(BuildContext context) {//
    final userData = context.watch<UserDataBloc>();
    final BackgroundBloc back = context.watch<BackgroundBloc>();
    final DataCommentBloc commentBloc = context.watch<DataCommentBloc>();
    List<Map<String,dynamic>> list = commentBloc.state is GetCommentState?
    (commentBloc.state as GetCommentState).data:[];

    const textStyle = TextStyle(
      fontSize: 16,
      color: Color(0xFF212529),
    );
    const textFieldDecorator = InputDecoration(
      border: OutlineInputBorder(),
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      isCollapsed: true,
      fillColor: Colors.red,
      focusColor: Colors.red,
      hoverColor: Colors.red,
    );
    return BlocListener<BackgroundBloc, StatusState>(
      listener: (context, state) {
        if (state is OnlineStatusState || state is BeginStatusState) {
          if (userData.state is SuccessSignInState){
            back.add(const MiddleStatusEvent());
            Navigator.pushNamed(context, '/code');
          }
        }
      },
      child:Container(padding: EdgeInsets.all(30),
      child: ListView(
        children: [
          const SizedBox(height: 10,),
          Container(
              padding:const EdgeInsets.only(bottom: 20),
              child: const Text("Комментарии :",style:TextStyle(fontSize: 17),)
          ),
          const SizedBox(height: 20),
          const Text(
            'Ваш комментарий :',
            style: textStyle,
          ),
          const SizedBox(height: 5),
          TextField(
            //controller: ,
              maxLength: 20,
              decoration: textFieldDecorator,
              onChanged: (text){
               comment = text;
              } // print(email);},
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: ()async{
            String datat = DateTime.now().toString();
            datat = datat.substring(0,10);
            List<String> list = datat.split("-").reversed.toList();
            Map<String, dynamic> fin = {
              'id': list.length+1,
              'idpost': widget.id,
              'name':userData.state is SuccessSignInState?(userData.state as SuccessSignInState).myData['name']:'',
              'surname':userData.state is SuccessSignInState?(userData.state as SuccessSignInState).myData['surname']:'',
              'comment': comment,
              'time': list.join('-'),
            };
            commentBloc.add(SendComment(data: fin));
          }, child:Text('Отправить')),
          SizedBox(height: 10,),
          ...list.map((e) =>
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(e["time"].toString(),style: const TextStyle(color: Colors.black,fontSize: 12),),
                    SizedBox(height: 5,),
                    Text(e["surname"].toString(),style: const TextStyle(color: Colors.black,fontSize: 15),),
                    const SizedBox(height: 5,),
                    Text(e["name"].toString(),style: const TextStyle(color: Colors.black,fontSize: 15),),
                    const SizedBox(height: 5,),
                    Text(e["comment"].toString(),style: const TextStyle(color: Colors.black,fontSize: 20),),
                    const SizedBox(height: 10,),
                    Row(children: [
                      const Expanded(child: const Divider(color: Colors.black54,height: 2,))
                    ],
                    ),
                  ],
                )
                ,
              )
          )
        ],
      ),
      ),
    );
  }
}
