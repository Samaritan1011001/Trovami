import 'dart:collection';

import 'dart:ui';

import 'package:flutter/material.dart';

const String COLOR_PRIMARY        = "ColorPrimary";
const String COLOR_SECONDARY      = "ColorSecondary";
const String COLOR_CANVAS         = "ColorCanvas";
const String COLOR_TEXT           = "ColorText";

const String STYLE_NORMAL         = "StyleNormal";
const String STYLE_NORMAL_BOLD    = "StyleNormalBold";
const String STYLE_TITLE          = "StyleTitle";

class ThemeManager {
  //<editor-fold desc="Singleton Setup">
  static final ThemeManager _instance = new ThemeManager._internal();
  factory ThemeManager() {
    return _instance;
  }
  ThemeManager._internal(){
    _initialize();
  }
  //</editor-fold>

  Map _colors = LinkedHashMap<String, Object>();
  Map _styles = LinkedHashMap<String, TextStyle>();

  getColor(String name) {
    return _colors[name];
  }

  getStyle(String name) {
    return _styles[name];
  }

  _initialize(){
    _colors.putIfAbsent(COLOR_PRIMARY,      () => Colors.lightBlue);
    _colors.putIfAbsent(COLOR_SECONDARY,    () => Colors.purple[50]);
    _colors.putIfAbsent(COLOR_CANVAS,       () => Colors.purple[50]);
    _colors.putIfAbsent(COLOR_TEXT,         () => Colors.white);

    _styles.putIfAbsent(STYLE_NORMAL,       () => TextStyle(fontSize: 22.0, color: Colors.black));
    _styles.putIfAbsent(STYLE_NORMAL_BOLD,  () => TextStyle(fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.bold));
    _styles.putIfAbsent(STYLE_TITLE,        () => TextStyle(fontSize: 30.0, color: Colors.black, fontWeight: FontWeight.bold));
  }
}