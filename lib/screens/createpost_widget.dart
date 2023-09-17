import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/bloc/background_bloc.dart';
import 'package:untitled1/bloc/draft_bloc.dart';
import 'package:untitled1/bloc/saveUser_bloc.dart';
import 'package:untitled1/bloc/update_bloc.dart';

class CreateWidget extends StatefulWidget {

  const CreateWidget({super.key});

  @override
  State<CreateWidget> createState() => _CreateWidgetState();
}

class _CreateWidgetState extends State<CreateWidget> {
  String title = '';
  String texts = '';
  Uint8List? photo;

  Future<void> getLostData() async {
    final ImagePicker picker = ImagePicker();
    final XFile? result = await picker.pickImage(source: ImageSource.gallery);
    final bytes = await result?.readAsBytes().then((value) => photo = value);
    setState(() {
    });
    print("${bytes!.length}length");
  }

  @override
  Widget build(BuildContext context) {
    final draftBloc = context.watch<DraftBloc>();
    final updateBloc = context.watch<UpdateBloc>();
    final userData = context.watch<UserDataBloc>();
    final BackgroundBloc back = context.watch<BackgroundBloc>();
    return BlocListener<BackgroundBloc, StatusState>(
        listener: (context, state) {
          if (state is OnlineStatusState || state is BeginStatusState) {
            if (userData.state is SuccessSignInState){
              back.add(const MiddleStatusEvent());
              Navigator.pushNamed(context, '/code');
            }
          }
        },
        child:Scaffold(
          appBar: AppBar(
            title: const Text("Create post"),
          ),
          body:Container(
              padding: const EdgeInsets.all(10),
              child: ListView(
                children: [
                  TextFormField(
                      decoration:const  InputDecoration(
                        labelText: "Enter title",
                        hintText: "Enter title",
                        icon: Icon(Icons.title),
                      ),
                      maxLength: 30,
                      onChanged: (text) {
                        title = text;
                        setState(() {

                        });
                      }
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                      decoration:const  InputDecoration(
                        labelText: "Enter text",
                        hintText: "Enter text",
                        icon: Icon(Icons.text_snippet_outlined),
                      ),
                      maxLength: 30,
                      onChanged: (text) {
                        texts = text;
                        setState(() {

                        });
                      }
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      const Text("Change picture +",style: TextStyle(fontSize: 17),),
                      const SizedBox(width: 10,),
                      IconButton(onPressed: (){
                        getLostData();
                      }, icon: const Icon(Icons.add_photo_alternate_outlined))
                    ],
                  ),
                  const SizedBox(height: 10,),
                photo!=null? Container(
                    width:MediaQuery.of(context).size.width*0.5,
                    height: MediaQuery.of(context).size.height*0.3,
                    margin: const EdgeInsets.symmetric(vertical: 0.5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Image.memory(photo as Uint8List,fit: BoxFit.cover),
                  ):const SizedBox(),
                  const SizedBox(height: 10,),
                  ElevatedButton(onPressed:()async{
                   await sendData(updateBloc);
                  Navigator.pushReplacementNamed(context,'/list',);
                  }, child: const Text("Save all")),
                  const SizedBox(height: 5,),
                  ElevatedButton(onPressed: ()async{
                   await sendDraftData(draftBloc);
                    Navigator.pushReplacementNamed(context,'/list',);
                   /* Navigator.of(context)
                    .pushNamedAndRemoveUntil('/list', (Route<dynamic> route) => false);*/
                  }, child:const Text("Сохр. черновик и выйти")),
                  updateBloc.state is SaveSuccessState? const Text("Данные успешно отправлены!"):const SizedBox()
                ],
              )),
        )
    );
  }
Future<void>sendData(UpdateBloc updateBloc)async{
  String datat = DateTime.now().toString();
  datat = datat.substring(0,10);
  String timeNow = datat.split("-").reversed.toList().join('-');
  updateBloc.add(SavePostEvent(data: {'title':title,'text':texts,
    'image':photo,'time':timeNow}));
}
Future<void>sendDraftData(DraftBloc draftBloc)async {
 await Future.delayed(const Duration(milliseconds: 100), () {
    draftBloc.add(SetDraft(draft: {"type":"draft","title":title,"text":texts,"id":DateTime.now().toString(),"image":photo??''},type: "no"));
  });

}

}
