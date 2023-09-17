import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'dart:isolate';
import 'package:http/http.dart' as http;


abstract class RemoteConfing{
  Future<int>setUserData(Map<String,dynamic> data);
  Future<Map<String,dynamic>>getUserData(Map<String,dynamic> data);
  Future<void>deleteUserData(Map<String,dynamic> data);
  Future<void>updateUserData(Map<String,dynamic> data);
  Future<Map<String,dynamic>>getUserCookData(Map<String, dynamic> data);
  Future<List<Map<String,dynamic>>>getListData();
  Future<List<Map<String,dynamic>>>getMyListData(Map<String, dynamic> data);
  Future<void>updatePost(Map<String,dynamic> data);
  Future<void>updateComments(Map<String,dynamic> data);
  Future<int>setPostData(Map<String,dynamic> data);
  Future<void>deletePostData(Map<String,dynamic> data);
  Future<Map<String,dynamic>>getOneData(Map<String,dynamic> data);
  Future<void>setLikes(Map<String,dynamic> data);
  Future<void>setViews(Map<String,dynamic> data);
  Future<int> setComment(Map<String, dynamic> data);
  Future<List<Map<String, dynamic>>> getComments(Map<String, dynamic> data);
}


class DataBaseConfig implements RemoteConfing {

  final http.Client client = http.Client();

  static Future<void> someFunction(Map<String,dynamic> arg)async {
    print('isolateee');
    late SendPort port;
    final receivePort = ReceivePort();
    if (arg['port'] is SendPort) {
      port = arg['port'];
      print("rrrr${arg['result']}");
      print("rrrr${arg['dataUrl']}");
      print("rrrr${arg['fun']}");
      try{
        final data = await arg['fun'](arg['result'],arg['dataUrl']);
        print("isoooo${data}");
        port.send(data);
      }catch(e){
        print('eeeeee${e}');
        port.send(Exception());
      }
      /* var uri = Uri.http('192.168.0.111:3500', 'addata');
      final response = await http.Client()
          .post(uri, headers: {"Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': }, body: parameters);
      // client.close();
      if (response.statusCode == 200) {
        final int insertId = json.decode(response.body) as int;
        print("${insertId}");
        port.send(insertId);
      } else {
        print('Errrorrr');
        port.send(Exception());
      }*/
    }
  }


  Future<int> sendDataForIsolate(Map<String,dynamic> parameters,String dataUrl)async{
    parameters['likes'] = jsonEncode(parameters['likes']);
    final String parameterss = jsonEncode(parameters);
    var uri = Uri.http('192.168.0.113:3500', dataUrl);
    final response = await client
        .post(uri, headers: {"Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': '*/*'}, body: parameterss);
    // client.close();
    if (response.statusCode == 200) {
      final int insertId = json.decode(response.body) as int;
      print("${insertId}");
      return insertId;
    } else {
      print('Errrorrr');
      throw Exception();
    }
  }


  @override
  Future<void> sendData(Map<String, dynamic> data) async{
    final receivePort = ReceivePort();
    final isolate = await Isolate
        .spawn(someFunction, {"port":receivePort.sendPort,'result':data,'fun':sendDataForIsolate,'dataUrl':'addata'});
    receivePort.listen((message) async{
      print(message);
      if(message is Map<String,dynamic>){
        print("${message}id int");
      }else{
        print("Erorrrr");
      }
      // изолят больше не нужен - завершаем его
      receivePort.close();
      isolate.kill();
    });
    throw UnimplementedError();
  }
  ///////



  final controllerOneArt =  StreamController<Map<String,dynamic>>();



  @override
  Stream<Map<String,dynamic>> returnOneData(){
    return controllerOneArt.stream;
  }

  /*@override
  Future<Map<String,dynamic>> getOneData(int id)async{
    Map<String,dynamic> data = await compute(getOneDataForIsolate,{'id':id});
    return data;
    // final receivePort = ReceivePort();
    /*final isolate = await Isolate
        .spawn(someFunction, {"port":receivePort.sendPort,"result":{'id':id},'fun':getOneDataForIsolate,'dataUrl':'oneart'});
    receivePort.listen((message){
      print("oneneee${message}");
      if(message is Map<String,dynamic>){
        controllerOneArt.add(message);
        receivePort.close();
        print("List${message}List");
        isolate.kill();
      }
      else{
        isolate.kill();
        receivePort.close();
        //throw Exception();
      }
    });*/

  }*/

////////////



  /*final controller =  StreamController<List<Map<String,dynamic>>>();

@override
StreamController <List<Map<String,dynamic>>> returnData(){
  print("take data");
    return controller;
  }*/





  @override
  Future<void> getLike(List<String> likes,int id)async{
    List<Map<String,dynamic>> data;
    final receivePort = ReceivePort();
    final isolate = await Isolate
        .spawn(someFunction, {"port":receivePort.sendPort,'result':{'likes':likes,'id':id},'fun':getLikeForIsolate,'dataUrl':'updatelike'});
    receivePort.listen((message){
      print("mesmes${message}");
      if(message=='1'){
        receivePort.close();
        //controller.add(message);
        print("Like${message}Like");
        isolate.kill();
      }else{
        isolate.kill();
        receivePort.close();
        throw Exception();
      }
    });
  }


  @override
  Future<void> getView(int view,int id)async{
    final receivePort = ReceivePort();
    final isolate = await Isolate
        .spawn(someFunction, {"port":receivePort.sendPort,'result':{'views':view,'id':id},'fun':getViewsForIsolate,'dataUrl':'updateview'});
    receivePort.listen((message){
      print("mesmes${message}");
      if(message=='1'){
        receivePort.close();
        //controller.add(message);
        print("views${message}views");
        isolate.kill();
      }else{
        isolate.kill();
        receivePort.close();
        throw Exception();
      }
    });
  }

 /* @override
  Future<List<Map<String,dynamic>>> getPostComment(int idpost)async{
    List<Map<String,dynamic>>data = await compute(getCommentForIsolate,{'idpost':idpost});
    return data;
  }*/


  Future<int> sendCommentForIsolate(Map<String,dynamic> parameters,String dataUrl)async{
    final String parameterss = jsonEncode(parameters);
    var uri = Uri.http('192.168.0.113:3500', dataUrl);
    final response = await client
        .post(uri, headers: {"Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': '*/*'}, body: parameterss);
    // client.close();
    if (response.statusCode == 200) {
      final int insertId = json.decode(response.body) as int;
      print("${insertId}");
      return insertId;
    } else {
      print('Errrorrr');
      throw Exception();
    }
  }


  @override
  Future<void> sendComment(Map<String, dynamic> data) async{
    final receivePort = ReceivePort();
    final isolate = await Isolate
        .spawn(someFunction, {"port":receivePort.sendPort,'result':data,'fun':sendCommentForIsolate,'dataUrl':'addcomment'});
    receivePort.listen((message) async{
      print(message);
      if(message is int){
        print("${message}idcom int");
      }else{
        print("Erorrrr");
      }
      // изолят больше не нужен - завершаем его
      receivePort.close();
      isolate.kill();
    });
  }








 /* @override
  Future<List<Map<String,dynamic>>> getTagData(String cat,int off)async{
    return compute(getTagDataForIsolate,{'cat':cat,'off':off});
    /* final receivePort = ReceivePort();
    final isolate = await Isolate
        .spawn(someFunction, {"port":receivePort.sendPort,'result':'{}','fun':getDataForIsolate,'dataUrl':'selectdata'});
 receivePort.listen((message){
      print("mesmes${message}");
      if(message is List<Map<String,dynamic>>){
        controller.add(message);
        receivePort.close();
        print("List${message}List");
        isolate.kill();
      }else{
        isolate.kill();
        receivePort.close();
        throw Exception();
      }
    });*/
  }*/
///list app
  Future<Map<String,dynamic>>getUserDataForIsolate(Map<String,dynamic> parameters)async{
    try {
      final String parameterss = jsonEncode(parameters);
      var uri = Uri.http('192.168.0.131:3500', 'getuser');
      final response = await client
          .post(uri, headers: {"Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': '*/*'}, body: parameterss);
      // client.close();
      print(response.statusCode);
      final List list = json.decode(response.body) as List;
      Map<String,dynamic> e = list[0] as Map<String,dynamic>;
      print("user${e}");
      return {"name":e["name"] as String,"surname":e["surname"] as String,"email":e["email"] as String,"password":e["password"] as String};
    }catch(e){
      print("error setuser ${e}");
      throw(Exception(e));
    }
  }

  Future<Map<String,dynamic>>getUserCookDataForIsolate(Map<String,dynamic> parameters)async{
    try {
      final String parameterss = jsonEncode(parameters);
      var uri = Uri.http('192.168.0.131:3500', 'getusercook');
      final response = await client
          .post(uri, headers: {"Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': '*/*'}, body: parameterss);
      // client.close();
      print(response.statusCode);
      final List list = json.decode(response.body) as List;
      Map<String,dynamic> e = list[0] as Map<String,dynamic>;
      print("user${e}");
      return {"name":e["name"] as String,"surname":e["surname"] as String,"email":e["email"] as String,"password":e["password"] as String};
    }catch(e){
      print("error setuser ${e}");
      throw(Exception(e));
    }
  }

  Future<int>setUserDataForIsolate(Map<String,dynamic> parameters)async{
    try {
      final String parameterss = jsonEncode(parameters);
      var uri = Uri.http('192.168.0.131:3500', 'setuser');
      final response = await client
          .post(uri, headers: {"Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': '*/*'}, body: parameterss);
      // client.close();
      print(response.statusCode);
      final int insertId = json.decode(response.body) as int;
      print("userID${insertId}");

      return insertId;
    }catch(e){
      print("error setuser ${e}");
      throw(Exception(e));
    }
  }

  Future<void>deleteUserDataForIsolate(Map<String,dynamic> parameters)async{
    try {
      final String parameterss = jsonEncode(parameters);
      var uri = Uri.http('192.168.0.131:3500', 'deluser');
      final response = await client
          .post(uri, headers: {"Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': '*/*'}, body: parameterss);
      // client.close();
      print(response.statusCode);
      print(response.body.runtimeType);
    }catch(e){
      print("error setuser ${e}");
      throw(Exception(e));
    }
  }

  Future<void>updateUserDataForIsolate(Map<String,dynamic> parameters)async{
    try {
      final String parameterss = jsonEncode(parameters);
      var uri = Uri.http('192.168.0.131:3500', 'updateuser');
      final response = await client
          .post(uri, headers: {"Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': '*/*'}, body: parameterss);
      // client.close();
      print(response.statusCode);
      print(response.body.runtimeType);
    }catch(e){
      print("error setuser ${e}");
      throw(Exception(e));
    }
  }

 @override
  Future<List<Map<String,dynamic>>> getListDataIsolate(String param)async{
    try {
      var uri = Uri.http('192.168.0.131:3500', 'selectdata');
      final response = await client
          .post(uri, headers: {"Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': '*/*'},body: "[]");
      // client.close();
      print(response.statusCode);
      // print(response.body);
      //if (response.statusCode == 200) {
      List list = json.decode(response.body) as List;
  //    print("listttttststst${list}");
      List<Map<String, dynamic>> res = list.map((e) {
        e as Map<String,dynamic>;
        Uint8List? image;
        if(e['image'] as String!="null"){
          final String sub = e['image'].substring(1, e['image'].length - 1);
          List<String> data = e['image'].split(",");
          List<int> pars = data.map((e) => int.parse(e)).toList();
          image = Uint8List.fromList(pars);
        }

        final List<String> likes = (json.decode(e['likes']) as List).map((
            l) => l as String).toList();
        Map<String, dynamic> fin = {
          'id': e['id'] as int,
          'title': e['title'] as String,
          'name': e['name'] as String,
          'time': e['time'] as String,
          'views': e['views'] as int,
          'likes': likes,
          'image': image
        };
     //   print("fin finnnn${fin}");
        return fin;
      }
      ).toList();
     // print("resresressss${res}");
      return res;
    }catch(e){
      print("ererererere${e}");
      throw(Exception(e));
    }
  }


  Future<List<Map<String,dynamic>>> getMyDataForIsolate(Map<String,dynamic> parameters)async{
    try {
      final String parameterss = jsonEncode(parameters);
      var uri = Uri.http('192.168.0.131:3500', 'selectmy');
      final response = await client
          .post(uri, headers: {"Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': '*/*'},body: parameterss);
      // client.close();
      print(response.statusCode);
      // print(response.body);
      //if (response.statusCode == 200) {
      List list = json.decode(response.body) as List;
     // print("listttttststst${list}");
      List<Map<String, dynamic>> res = list.map((e) {
        print(e['image']);
        e as Map<String,dynamic>;
    //  final String sub = e['image'].substring(1, e['image'].length - 1);
        Uint8List? image;
        if(e['image'] as String!="null") {
          List<String> data = e['image'].split(",");
          print(data);
          List<int> pars = data.map((e) => int.parse(e)).toList();
          image = Uint8List.fromList(pars);
        }
        final List<String> likes = (json.decode(e['likes']) as List).map((
            l) => l as String).toList();
        Map<String, dynamic> fin = {
          'id': e['id'] as int,
          'comments': e['comments'] as int,
          'title': e['title'] as String,
          'text': e['descr'] as String,
          'name': e['name'] as String,
          'time': e['time'] as String,
          'views': e['views'] as int,
          'likes': likes,
          'image': image
        };
      //  print("fin finnnn${fin}");
        return fin;
      }
      ).toList();
     // print("resresressss${res}");
      return res;
    }catch(e){
      print("ererererere${e}");
      throw(Exception(e));
    }
  }

  Future<void>updateMyPostForIsolate(Map<String,dynamic> parameters)async{
    try {
      final String parameterss = jsonEncode(parameters);
      var uri = Uri.http('192.168.0.131:3500', 'updatepost');
      final response = await client
          .post(uri, headers: {"Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': '*/*'}, body: parameterss);
      // client.close();
      print(response.statusCode);
      print(response.body.runtimeType);
    }catch(e){
      print("error post update ${e}");
      throw(Exception(e));
    }
  }

  Future<int>setPostForIsolate(Map<String,dynamic> parameters)async{
    try {
      parameters['likes'] = jsonEncode(parameters['likes']);
      final String parameterss = jsonEncode(parameters);
      var uri = Uri.http('192.168.0.131:3500', 'addata');
      final response = await client
          .post(uri, headers: {"Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': '*/*'}, body: parameterss);
      // client.close();
      print(response.statusCode);
      final int insertId = json.decode(response.body) as int;
      print("userID${insertId}");

      return insertId;
    }catch(e){
      print("error setuser ${e}");
      throw(Exception(e));
    }
  }
  Future<void>deletePostForIsolate(Map<String,dynamic> parameters)async{
    try {
      final String parameterss = jsonEncode(parameters);
      var uri = Uri.http('192.168.0.131:3500', 'delpost');
      final response = await client
          .post(uri, headers: {"Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': '*/*'}, body: parameterss);
      // client.close();
      print(response.statusCode);
      print(response.body.runtimeType);
    }catch(e){
      print("error setuser ${e}");
      throw(Exception(e));
    }
  }


  Future<Map<String,dynamic>> getOneDataForIsolate(Map<String,dynamic> parameters)async{
    try {
      final String parameterss = jsonEncode(parameters);
      var uri = Uri.http('192.168.0.131:3500', 'oneart');
      final response = await client
          .post(uri, headers: {"Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': '*/*'},body: parameterss);
      // client.close();
      print(response.statusCode);
      // print(response.body);
      List list = json.decode(response.body) as List;
     Map<String,dynamic> e =list[0] as Map<String,dynamic>;
      Uint8List? image;
      if(e['image'] as String!="null") {
        List<String> data = e['image'].split(",");
        print(data);
        List<int> pars = data.map((e) => int.parse(e)).toList();
      image = Uint8List.fromList(pars);
      }
      final List<String> likes = (json.decode(e['likes']) as List).map((
          l) => l as String).toList();
      return {
        'id': e['id'] as int,
        'comments': e['comments'] as int,
        'title': e['title'] as String,
        'text': e['descr'] as String,
        'name': e['name'] as String,
        'time': e['time'] as String,
        'views': e['views'] as int,
        'likes': likes,
        'image': image
      };
    }catch(e){
      print("ererererere${e}");
      throw(Exception(e));
    }
  }

  Future<void>getLikeForIsolate(Map<String,dynamic> parameters)async{
    try {
      parameters['likes'] = jsonEncode(parameters['likes']);
      String resParams =jsonEncode(parameters);
      var uri = Uri.http('192.168.0.131:3500', "/updatelike");
      final response = await client
          .post(uri, headers: {"Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': '*/*'}, body:resParams);
      // client.close();
      print(response.statusCode);
      // print(response.body);
      //if (response.statusCode == 200) {
      String res = json.decode(response.body).toString();
      print(res);
      /*  } else {
        print('Errrorrr');
        // throw Exception();
      }*/
    }catch(e){
      print("ererererere${e}");
      throw(Exception(e));
    }
  }

  Future<void>getViewsForIsolate(Map<String,dynamic> parameters)async{
    try {
      String resParams =jsonEncode(parameters);
      print("paramsss${resParams}");
      var uri = Uri.http('192.168.0.131:3500', "/updateview");
      final response = await client
          .post(uri, headers: {"Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': '*/*'}, body:resParams);
      // client.close();
      print(response.statusCode);
      // print(response.body);
      //if (response.statusCode == 200) {
      String res = json.decode(response.body).toString();
      print(res);
      /*  } else {
        print('Errrorrr');
        // throw Exception();
      }*/
    }catch(e){
      print("ererererere${e}");
      throw(Exception(e));
    }
  }

  Future<int>setCommentForIsolate(Map<String,dynamic> parameters)async{
    try {
      final String parameterss = jsonEncode(parameters);
      var uri = Uri.http('192.168.0.131:3500', 'addcomment');
      final response = await client
          .post(uri, headers: {"Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': '*/*'}, body: parameterss);
      // client.close();
      print(response.statusCode);
      final int insertId = json.decode(response.body) as int;
      print("commentID${insertId}");

      return insertId;
    }catch(e){
      print("error setuser ${e}");
      throw(Exception(e));
    }
  }

  Future<List<Map<String,dynamic>>> getCommentForIsolate(Map<String,dynamic> parameters)async{
    try {
      final String parameterss = jsonEncode(parameters);
      var uri = Uri.http('192.168.0.113:3500', 'loadcomments');
      final response = await client
          .post(uri, headers: {"Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': '*/*'}, body: parameterss);
      // client.close();
      print(response.statusCode);
      // print(response.body);
      //if (response.statusCode == 200) {
      List list = json.decode(response.body) as List;
      print("comment${list}");
      List<Map<String, dynamic>> res = list.map((e) {
        //print("ee${e}");

        Map<String, dynamic> fin = {
          'id': e['id'] as int,
          'idpost': e['idpost'] as int,
          'name': e['name'] as String,
          'surname': e['surname'] as String,
          'comment': e['comment'] as String,
          'time': e['time'] as String,
        };
        // print("fin${fin}");
        print("comments${fin}");
        return fin;
      }
      ).toList();
      return res;
      /*  } else {
        print('Errrorrr');
        // throw Exception();
      }*/
    }catch(e){
      print("er${e}");
      throw(Exception(e));
    }
  }

  Future<void>changeCommentsForIsolate(Map<String,dynamic> parameters)async{
    try {
      String resParams =jsonEncode(parameters);
      print("paramsss${resParams}");
      var uri = Uri.http('192.168.0.131:3500', "/updatecomment");
      final response = await client
          .post(uri, headers: {"Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': '*/*'}, body:resParams);
      // client.close();
      print(response.statusCode);
      // print(response.body);
      //if (response.statusCode == 200) {
      String res = json.decode(response.body).toString();
      print(res);
      /*  } else {
        print('Errrorrr');
        // throw Exception();
      }*/
    }catch(e){
      print("ererererere${e}");
      throw(Exception(e));
    }
  }



  @override
  Future<int> setComment(Map<String, dynamic> data) {
    return compute(setCommentForIsolate,data);
    throw UnimplementedError();
  }

  @override
  Future<List<Map<String, dynamic>>> getComments(Map<String, dynamic> data) {
    return compute(getCommentForIsolate,data);
  }

  @override
  Future<int> setUserData(Map<String, dynamic> data) {
  return compute(setUserDataForIsolate,data);
    throw UnimplementedError();
  }

  @override
  Future<Map<String,dynamic>>getUserData(Map<String, dynamic> data) {
    return compute(getUserDataForIsolate,data);
  }
  @override
  Future<Map<String,dynamic>>getUserCookData(Map<String, dynamic> data) {
    return compute(getUserCookDataForIsolate,data);
  }
  @override
  Future<void> deleteUserData(Map<String, dynamic> data) {
    return compute(deleteUserDataForIsolate,data);
  }

  @override
  Future<void> updateUserData(Map<String, dynamic> data) {
    return compute(updateUserDataForIsolate,data);
  }

  @override
  Future<List<Map<String,dynamic>>> getListData() {
    return compute(getListDataIsolate ,"null");
  }

  @override
  Future<List<Map<String, dynamic>>> getMyListData(Map<String, dynamic> data) {
    return compute(getMyDataForIsolate,data);
  }

  @override
  Future<void> updatePost(Map<String, dynamic> data) {
  return compute(updateMyPostForIsolate,data);
  }

  @override
  Future<int> setPostData(Map<String, dynamic> data) {
    return compute(setPostForIsolate,data);
  }

  @override
  Future<void> deletePostData(Map<String, dynamic> data) {
    return compute(deletePostForIsolate,data);
  }

  @override
  Future<Map<String,dynamic>> getOneData(Map<String,dynamic> data) {
    return compute(getOneDataForIsolate,data);
  }

  @override
  Future<void>setLikes(Map<String, dynamic> data) {
    return compute(getLikeForIsolate,data);
  }

  @override
  Future<void>setViews(Map<String, dynamic> data) {
    return compute(getViewsForIsolate,data);
  }

  @override
  Future<void> updateComments(Map<String, dynamic> data) {
    return compute(changeCommentsForIsolate,data);
  }

}