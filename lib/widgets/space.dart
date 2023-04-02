import 'package:flutter/material.dart';

extension SpaceFromIntExtension on int {
  Widget get horizontalSpace => SizedBox(width: toDouble());
  Widget get verticalSpace => SizedBox(height: toDouble());

  EdgeInsetsGeometry get horizontalInsets =>
      EdgeInsets.symmetric(horizontal: toDouble());
  EdgeInsetsGeometry get verticalInsets =>
      EdgeInsets.symmetric(vertical: toDouble());
}

extension SpaceFromDoubleExtension on double {
  Widget get horizontalSpace => SizedBox(width: this);
  Widget get verticalSpace => SizedBox(height: this);
}
