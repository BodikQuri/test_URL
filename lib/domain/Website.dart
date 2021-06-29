import 'dart:core';

import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';




class Website {
  String url;
  String httpStatus;
  DateTime lastUpdate = DateTime.now();
  Widget icon;
  bool isAvailable = false;
  bool isSync = true;
  Map<String, String> headers = {};
  Website({
    @required url,
    @required isAvailable,
    @required httpStatus,
    icon,
    isSync: false,
  })  : lastUpdate = DateTime.now(),
        url = url,
        isAvailable = isAvailable,
        httpStatus = httpStatus,
        isSync = isSync,
        icon = icon;

  

  String get urlString => url;

  Widget get favicon => (isSync == false ? icon : CircularProgressIndicator());

  Widget get realIcon => icon;

  String get status => httpStatus != null ? httpStatus : 'XXX';

  String get updatedAt =>
      formatDate(lastUpdate, [yy, '-', M, '-', d, '|', HH, ':', nn, ':', ss]);

  bool get available => isAvailable;
  bool get inProgress => isSync;

  set inProgress(bool f) => isSync = f;
  set headersMap(Map<String, String> h) => headers = h;

  
}
