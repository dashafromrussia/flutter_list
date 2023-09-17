import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/bloc/background_bloc.dart';
import 'package:untitled1/bloc/draft_bloc.dart';
import 'package:untitled1/bloc/saveUser_bloc.dart';
import 'package:untitled1/bloc/update_bloc.dart';

class UpdateWidget extends StatefulWidget {
  final Map<String,dynamic> data;
  const UpdateWidget({super.key,required this.data});

  @override
  State<UpdateWidget> createState() => _UpdateWidgetState();
}

class _UpdateWidgetState extends State<UpdateWidget> {
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
    final updateBloc = context.watch<UpdateBloc>();
    final draftBloc = context.watch<DraftBloc>();
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
          body:Container(
              padding: const EdgeInsets.all(10),
              child: ListView(
                children: [
                  TextFormField(
                      initialValue: widget.data['title'],
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
                      initialValue: widget.data['text'],
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
                 /* widget.data['image']!=""? Container(
                    width:MediaQuery.of(context).size.width*0.5,
                    height: MediaQuery.of(context).size.height*0.3,
                    margin: const EdgeInsets.symmetric(vertical: 0.5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Image.memory(photo??widget.data['image'] as Uint8List,fit: BoxFit.cover),
                  ):const SizedBox(),*/
                  const SizedBox(height: 10,),
                  ElevatedButton(onPressed:(){
                    print(title);
                    updateBloc.add(UpdatePostEvent(data: {'title':title.isEmpty?widget.data['title']:title,'text':texts.isEmpty?widget.data['text']:texts,
                      'image':photo/*??widget.data['image']*/,'id':widget.data['id']}));
                    Navigator.pushReplacementNamed(context,'/list',);
                  }, child: const Text("Update")),
                  const SizedBox(height: 5,),
                  ElevatedButton(onPressed: (){
                    if(widget.data.containsKey('type')){
                      draftBloc.add(SetDraft(draft: {"type":"draft","title":title,"text":texts,
                        "image":photo/*??widget.data['image']??''*/,"id":widget.data['id']},type:"yes"));
                    }
                    draftBloc.add(SetDraft(draft: {"type":"draft", "image":photo??widget.data['image']??'',"title":title,"text":texts,"id":DateTime.now().toString()},type: "no"));
                    Navigator.pushReplacementNamed(context,'/list',);
                  }, child:const Text("Сохр. черновик и выйти")),
                  const SizedBox(height: 5,),
                  ElevatedButton(onPressed:()=>
                     showDialog<void>(
                    context: context,
                    barrierDismissible: false, // user must tap button!
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Вы действительно хотите удалить пост?'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('нет'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('да'),
                            onPressed: (){
                              try{
                                if(widget.data.containsKey('type')){
                                  draftBloc.add(DeleteDraft(id: widget.data['id']));
                                }else{
                                  updateBloc.add(DeletePostEvent(data: {'id':widget.data['id']}));
                                }
                                Navigator.pushReplacementNamed(context,'/list',);
                              }catch(e){
                              }
                            },
                          ),
                        ],
                      );
                    },
                  ),
                  child: const Text("Delete")),
                  const SizedBox(height: 5,),
                  updateBloc.state is UpdateSuccessState? const Text("Данные успешно отправлены!"):const SizedBox()
                ],
              )),
        )
        );
  }
}
