import 'models/category.dart';
import 'models/user.dart';

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return this.year == other.year &&
        this.month == other.month &&
        this.day == other.day;
  }
}

extension ParseCategoryTypeToString on CategoryType {
  String valueAsString() {
    return this.toString().substring(this.toString().indexOf('.') + 1);
  }
}

extension ParseSettingToString on Setting {
  String valueAsString() {
    return this.toString().substring(this.toString().indexOf('.') + 1);
  }
}
