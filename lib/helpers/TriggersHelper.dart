import 'package:flutter/material.dart';

const String TRIGGER_GROUPS_UPDATED            = "GroupsUpdated";

class Msg {
  int value;
  var data;
  Msg([this.value, this.data]);
}

typedef _TriggerMsgCallback = void Function(Msg);

class TriggersHelper {
  Map<String, ValueNotifier> _triggers = new Map<String, ValueNotifier>();
  Map<String, _TriggerMsgCallback> _triggersWMsg = new Map<String, _TriggerMsgCallback>();

  static final TriggersHelper _instance = new TriggersHelper._internal();

  factory TriggersHelper() {
    return _instance;
  }

  TriggersHelper._internal();

  addListener(String name, {VoidCallback callback, _TriggerMsgCallback callbackWMsg}){
    if(callback != null) {
      if (!_triggers.containsKey(name)){
        _triggers[name] = new ValueNotifier(0);
      }
      _triggers[name].addListener(callback);
    } else if (callbackWMsg != null){
      _assureTrigger(name);
      _triggersWMsg[name] = callbackWMsg;
    } else {
      throw Exception("addListener must be called with either VoidCallback or TriggerMsgCallback");
    }
  }

  removeListener(String name, VoidCallback callback){
    if((callback == null) || !_triggers.containsKey(name)){
      throw Exception(
          "removeListener must be called with callback for existing trigger");
    }

    _triggers[name].removeListener(callback);
  }

  trigger(String name){
    if (_triggers.containsKey(name)){
      _triggers[name].value++;
    } else {
      print("Attempt to fire non-existing trigger $name asked to fire");
    }
  }

  triggerMsg(String name, {int value, var data}){
    if (_triggersWMsg.containsKey(name)){
      _triggersWMsg[name](Msg(value, data));
    }
    else {
      print("Attempt to fire non-existing triggerWithData $name");
    }
  }

  _assureTrigger(String name){
    if (!_triggers.containsKey(name)){
      _triggers[name] = new ValueNotifier(0);
    }
  }

}