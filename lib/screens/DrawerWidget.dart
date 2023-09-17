import 'package:flutter/material.dart';
import 'package:untitled1/bloc/drawer_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled1/bloc/saveUser_bloc.dart';




class DrawerWidget extends StatelessWidget  /*State<DrawerWidget>*/ {
  @override
  Widget build(BuildContext context) {

    print('drawer');
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            decoration: const BoxDecoration(color: Colors.blue),height: 200,
            child:IconButton(onPressed:(){
            print('list');
          },
              icon: const Icon(Icons.list_alt,color: Colors.white70, size: 100,)),
          ),
          const SizedBox(height: 20,),
          const DataWidget( select: 'Main', navigate: '/list', name:'Главная',icon:Icons.emoji_emotions_outlined,),
          const DataWidget( select: 'About', navigate: '/aboutme', name:'Настройки',icon:Icons.emoji_emotions_outlined,),
          const DataWidget( select: 'Exit', navigate: '/login', name:'Выход',icon:Icons.exit_to_app),
        ],
      ),
    );
  }
}

class DataWidget extends StatelessWidget {
  final IconData icon;
  final String select;
  final String navigate;
  final String name;
  const DataWidget({Key? key, required this.select,required this.icon,
    required this.name, required this.navigate}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<DrawerBloc>();
    final userData = context.watch<UserDataBloc>();
    return StreamBuilder<DrawerState>(
      initialData:bloc.state,
      stream: bloc.stream,
      builder: (context, snapshot) {
        return
          ListTile(
            leading:Icon(icon,color:(snapshot.requireData as ToggleState).selects[select]),
            title:
            Text(name,style: TextStyle(color:(snapshot.requireData as ToggleState).selects[select])),
            onTap: (){
              Navigator.pop(context);
              if(select=='Exit'){
                userData.add(const ExitUser());
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
              }
                Navigator.pushReplacementNamed(context, navigate);


            },

          );
      },
    )
    ;
  }


}
