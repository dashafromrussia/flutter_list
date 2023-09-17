import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/bloc/Allposts_bloc.dart';
import 'package:untitled1/bloc/background_bloc.dart';
import 'package:untitled1/bloc/one_itemBloc.dart';
import 'package:untitled1/bloc/saveUser_bloc.dart';

class OnePostScreen extends StatelessWidget {
  const OnePostScreen({Key? key}) : super(key: key);

  Widget build(BuildContext context) {//
    final postBloc = context.watch<PostsBloc>();
    final userData = context.watch<UserDataBloc>();
    final BackgroundBloc back = context.watch<BackgroundBloc>();
    final oneBloc = context.watch<OnePostBloc>();
   final Map<String,dynamic> data = oneBloc.state is OneSuccessState?(oneBloc.state as OneSuccessState).posts:{};
    return BlocListener<BackgroundBloc, StatusState>(
      listener: (context, state) {
        if (state is OnlineStatusState || state is BeginStatusState) {
          if (userData.state is SuccessSignInState){
            back.add(const MiddleStatusEvent());
            Navigator.pushNamed(context, '/code');
          }
        }
      },
      child:oneBloc.state is OneSuccessState?
      Scaffold(
        appBar: AppBar(
          leading: ElevatedButton(onPressed:(){
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/list', (Route<dynamic> route) => false);
          },
            child: const Text("back"),
          ),

          title: const Text('One art'),
        ),
          body:
      Container(child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            const CircleAvatar(
              backgroundImage: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQRZhrZm_bEQIfEztj_4w2fv4JPIaAGeD6a0gOk2m1bIsIYNA0EWrXEeDbVngVRYwV_Jn4&usqp=CAU"),
            ),
            const SizedBox(width:10),
            Text(data['name'],style: const TextStyle(color: Colors.black54,fontSize: 17),),
          ],
        ),
        const SizedBox(height: 7,),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(data['title'],style: const TextStyle(color: Colors.black,fontSize: 20)),
            const SizedBox(width:10),
            Text(data['time'],style: const TextStyle(color: Colors.black54,fontSize: 17)),
          ],
        ),
        const SizedBox(height: 10,),
        /* data['image']!=''?  Container(
          width:MediaQuery.of(context).size.width*0.7,
          height: MediaQuery.of(context).size.height*0.5,
          margin: const EdgeInsets.symmetric(vertical: 0.5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
          ),
          child: Image.memory(data['image'] as Uint8List,fit: BoxFit.cover),
        ):const SizedBox(),*/
        const SizedBox(height: 3,),
        data.containsKey('type')? Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Stack(
    children: [
    IconButton(onPressed:()async{
  oneBloc.add(const ChangeLike());
    }, icon:
    data['likes'].contains((userData.state as SuccessSignInState).myData['name']) ? const Icon(Icons.heart_broken_sharp, color: Colors.red):
    const Icon(Icons.heart_broken_rounded, color: Colors.black)),
    Positioned(
    left:37,
    bottom:11,
    child:Text("${data['likes'].length}")
    ),
    ],
    ),
            Text("comments: ${data['comments'].length??"0"}",style: const TextStyle(color: Colors.black54,fontSize: 17),),
            const SizedBox(width: 10,),
            Text("views: ${data['views'].toString()}",style: const TextStyle(color: Colors.black54,fontSize: 17),),
          ],
        ):const SizedBox(),
        const SizedBox(height: 10,),
        ElevatedButton(onPressed: (){
          Navigator.pushNamed(context, '/comments');
        }, child: const Text("К комментариям >"))
      ],),)):const SizedBox()
    );
  }
}
