import 'dart:convert';



import 'package:flutter/services.dart';

import 'main.dart';

var _httpClient = createHttpClient();
const _jsonCodec=const JsonCodec(reviver: _reviver);
const _jsonCodec2=const JsonCodec(reviver: _reviver2);


_reviver( key, value) {
  if(key!=null&& value is Map && key.contains('-')){
    return new UserData.fromJson(value);
  }
  return value;
}

_reviver2(key,value) {
  if(key!=null&& value is Map){
    return new groupDetails.fromJson(value);
  } else
    return value;
}

getUsers()async {
  var response=await _httpClient.get('https://fir-trovami.firebaseio.com/users.json');
  Map usrmap=_jsonCodec.decode(response.body);
  return usrmap;
}


getGroups()async{
  var url="https://fir-trovami.firebaseio.com/groups.json";
  var response=await _httpClient.get(url);
  return _jsonCodec2.decode(response.body);
}
