import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

abstract class DraftData{
  Future<List<Map<String,dynamic>>> getData(String key);
  Future<void> setData({required List<Map<String,dynamic>>value,required String key});
  Future<void> deleteData(String key);

}

class SecureDraftProvider implements DraftData {
  static const _secureStorage = FlutterSecureStorage();

  @override
  Future<List<Map<String,dynamic>>> getData(String key)async{
    String? data = await _secureStorage.read(key: key);
    if(data!=null){
      Uint8List? image;
      List list = json.decode(data) as List;
      List<Map<String, dynamic>> res = list.map((e) {
        e as Map<String,dynamic>;
        if(e['image'].length!=0){
          final String sub = e['image'].substring(1, e['image'].length - 1);
          List<String> data = sub.split(",");
          List<int> pars = data.map((e) => int.parse(e)).toList();
           image = Uint8List.fromList(pars);
        }
        Map<String, dynamic> fin = {
          'text':e['text'] as String,
          'title': e['title'] as String,
          'name': e['name'] as String,
          'image': image??''
        };
        //  print("fin finnnn${fin}");
        return fin;
      }).toList();
      return res;
    }
    return [];
  }

  @override
  Future<void> setData({required List<Map<String,dynamic>> value, required String key}) {
    /*final body = value.map((el){
      return jsonEncode(el);
    }).toList();*/
    final String parameters = jsonEncode(value);
    return _secureStorage.write(key: key, value: parameters);
  }

  @override
  Future<void> deleteData(String key) {
    return _secureStorage.delete(key: key);
  }
}