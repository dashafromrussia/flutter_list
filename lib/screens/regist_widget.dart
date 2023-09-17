import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/bloc/Allposts_bloc.dart';
import 'package:untitled1/bloc/background_bloc.dart';
import 'package:untitled1/bloc/code.dart';
import 'package:untitled1/bloc/cookie_bloc.dart';
import 'package:untitled1/bloc/draft_bloc.dart';
import 'package:untitled1/bloc/error_bloc.dart';
import 'package:untitled1/bloc/mypostbloc.dart';
import 'package:untitled1/bloc/saveUser_bloc.dart';
import 'package:untitled1/main.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';

class ListDataWidget extends StatelessWidget {
  final Widget drawer;
  const ListDataWidget({Key? key,required this.drawer}) : super(key: key);

  Widget build(BuildContext context) {//
    final postBloc = context.watch<PostsBloc>();
    final userData = context.watch<UserDataBloc>();
    final BackgroundBloc back = context.watch<BackgroundBloc>();
    final CookieBloc cookie = context.watch<CookieBloc>();
   // final String cook = cookie.state is CookieSuccessState? (cookie.state as CookieSuccessState).cookie : '';
    return BlocListener<BackgroundBloc, StatusState>(
      listener: (context, state) {
        if (state is OnlineStatusState || state is BeginStatusState) {
          if (userData.state is SuccessSignInState){
            back.add(const MiddleStatusEvent());
            Navigator.pushNamed(context, '/code');
        }
        }
      },
       child:DefaultTabController(
          initialIndex: 0,
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              leading: ElevatedButton(onPressed:(){
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/create', (Route<dynamic> route) => false);
              },
                child: const Text("+ Add post"),
              ),
              bottom: const TabBar(
                tabs: [
                  Tab(text:"All",),
                  Tab(text:"My",),
                ],
              ),
              title: const Text('Posts'),
            ),
            body: const TabBarView(
              children: [
                AllPosts(),
                MyPosts()
              ],
            ),
          ),
        ),

    );
  }
}

class WithOutReg extends StatelessWidget {
  const WithOutReg({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        leading: ElevatedButton(onPressed:(){
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
        },
          child: const Text("back"),
        ),

        title: const Text('Posts'),
      ),
      body:
         const AllPosts(),
    );
  }
}




class AllPosts extends StatelessWidget {
  const AllPosts({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = context.watch<UserDataBloc>();
    final postBloc = context.watch<PostsBloc>();
    final List<Map<String,dynamic>> allposts =postBloc.state is PostSuccessState ? (postBloc.state as PostSuccessState).posts:
    postBloc.state is SwipeBeginState?(postBloc.state as SwipeBeginState).posts :[];
    return postBloc.state is PostSuccessState|| postBloc.state is SwipeBeginState? Container(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      child: Column(children: [
        postBloc.state is SwipeBeginState?  Container(
           margin: const EdgeInsets.symmetric(vertical: 10),
             child: const CircularProgressIndicator()):
           TextField(
        decoration:const  InputDecoration(
          hintText: "Enter code",
          icon: Icon(Icons.search),
        ),
        maxLength: 30,
        onChanged: (text) {
          postBloc.add(GetSearchPostsData(search: text));
        }
    ),
      const SizedBox(height: 5,),
        Expanded(child:
  ListView.builder(
          itemCount: allposts.length,
            itemBuilder:(context,index){
             return GestureDetector(
               onTap: (){
           if (userData.state !is SuccessSignInState){
                return;
           }
           Navigator.pushReplacementNamed(context,'/oneart',arguments:allposts[index]['id']);
               },
               child:ElemList(data: allposts[index],index: index,type: "all",));
            } ))
      ],),
    ):const Center(child: Text("Подождите..."),);
  }
}


class MyPosts extends StatelessWidget {
  const MyPosts({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = context.watch<UserDataBloc>();
    final postBloc = context.watch<PostsBloc>();
    final draftBloc = context.watch<DraftBloc>();
    final mypostBloc = context.watch<MyPostsBloc>();
    final List<Map<String,dynamic>> draftposts =draftBloc.state is DraftSuccessState ?(draftBloc.state as DraftSuccessState).draft:[];
    final List<Map<String,dynamic>> allposts =mypostBloc.state is MyPostSuccessState ? [...draftposts,...(mypostBloc.state as MyPostSuccessState).posts]:[];
    return postBloc.state is PostSuccessState ?Container(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
      child: Column(children: [
        const SizedBox(height: 5,),
        Expanded(child:ListView.builder(
            itemCount: allposts.length,
            itemBuilder:(context,index){
              return
              ElemList(data: allposts[index],index: index,type:"my");
            } ) )
      ],),
    ):const Center(child: Text("Подождите..."),);
  }
}




class ElemList extends StatelessWidget {
  final Map<String,dynamic> data;
  final int index;
  final String type;
  const ElemList({super.key,required this.data,required this.index,required this.type});

  @override
  Widget build(BuildContext context) {
    final postBloc = context.watch<PostsBloc>();
    return  index==0 && type=="all"? SwipeDetector(
        onSwipeDown: (offset) {
          if(postBloc.state is SwipeBeginState) return;
          postBloc.add(const SwipeData());
          print("down");
        },
        child: Container(child: Column(
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
      /*  Container(
          width:MediaQuery.of(context).size.width*0.7,
          height: MediaQuery.of(context).size.height*0.5,
          margin: const EdgeInsets.symmetric(vertical: 0.5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
          ),
          child: Image.memory(data['image'] as Uint8List,fit: BoxFit.cover),
        ),*/
        const SizedBox(height: 3,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("likes: ${data['likes'].length.toString()}",style: const TextStyle(color: Colors.black54,fontSize: 17),),
            Text("comments: ${data['comments'].length??"0"}",style: const TextStyle(color: Colors.black54,fontSize: 17),),
          ],
        ),
        const SizedBox(height: 10,),
    ],),)): Container(child: Column(
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
            const SizedBox(width: 10,),
           type=="my"? IconButton(onPressed: (){
           //  Navigator.pushNamed(context, '/updates', arguments: {"name":"aaa","text":"ii",'title':'sss'});
             // Navigator.pushNamed(context, '/update',arguments:data);
              Navigator.pushReplacementNamed(context,'/updates',arguments:data);
            }, icon:const Icon(Icons.edit)):const SizedBox()
          ],
        ),
        const SizedBox(height: 7,),
        data.containsKey('type')?const Text("Черновик",style: TextStyle(color: Colors.red),):const SizedBox(),
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
            Text("likes: ${data['likes'].length.toString()}",style: const TextStyle(color: Colors.black54,fontSize: 17),),
            Text("comments: ${data['comments']}",style: const TextStyle(color: Colors.black54,fontSize: 17),),
          ],
        ):const SizedBox(),
        const SizedBox(height: 10,),
      ],),);
  }
}



/*Column(
            children: [
              ElevatedButton(onPressed: (){
                userData.add(const ExitUser());
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
              }, child: const Text("exit")),
              ElevatedButton(onPressed:(){
                 userData.add(const DeleteUserData());
                 Navigator.of(context)
                     .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
              }, child: Text("del")),
            ],
          );*/