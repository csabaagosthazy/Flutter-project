import 'package:flutter_group2_tshirt_project/data/tshirt_data.dart';

/// This is a class ActivityData that is use to get back activity data from DB.
class ActivityData {
  final List<TshirtData> listTshirtData;
  final String activityDate;

  ActivityData(this.listTshirtData, this.activityDate);
}
