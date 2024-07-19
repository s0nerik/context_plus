import 'dart:math';

extension Precision on double {
  double toPrecision(int fractionDigits) {
    final mod = pow(10, fractionDigits);
    return (this * mod).roundToDouble() / mod;
  }
}
