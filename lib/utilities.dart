class Utilities {
  static double constrain(double amt, double min, max) {
    if (amt > max) return max;
    if (amt < min) return min;
    return amt;
  }
}
