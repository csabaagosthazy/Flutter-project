import 'package:flutter/cupertino.dart';

import 'activity_data.dart';

class MyNotifier extends ValueNotifier<List<ActivityData>>
{
  MyNotifier(List<ActivityData> value) : super(value);

  void changeData(list){
    value = list;
    notifyListeners();
  }


}