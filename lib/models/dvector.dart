class DVector {
  double x = 0.0;
  double y = 0.0;

  static final zero = new DVector(0.0, 0.0);
  static final up = new DVector(0.0, -1.0);
  static final right = new DVector(1.0, 0.0);

  DVector(double _x, double _y) {
    x = _x;
    y = _y;
  }

  void add(DVector v2) {
    x += v2.x;
    y += v2.y;
  }

  void mul(double amt) {
    x *= amt;
    y *= amt;
  }

  void div(double amt) {
    if (amt == 0) throw new Exception("Cannot divide by 0");
    mul(1 / amt);
  }

  DVector copy() {
    return new DVector(x, y);
  }

  double dot(DVector vector) {
    return x * vector.x + y * vector.y;
  }

  String toString() {
    return "($x,$y)";
  }
}
