import 'package:flutter/material.dart';

import '../utilities.dart';
import 'dvector.dart';

class Particle {
  DVector position = DVector.zero;
  DVector velocity = DVector.zero;
  DVector acceleration = DVector.zero;

  // Optional parameters
  String text = "";
  Color color = Colors.white;
  double mass = 1.0;
  int lifespan = 255;

  Particle();

  void addForce(DVector f) {
    DVector force = f.copy();
    force.div(mass);
    acceleration.add(force);
  }

  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    acceleration.mul(0.0);
  }

  void bounce(Rect boundary, double dampening, DVector off) {
    if (position.x < boundary.left || position.x > boundary.right - off.x)
      velocity.x *= -dampening;
    if (position.y < boundary.top || position.y > boundary.bottom - off.y)
      velocity.y *= -dampening;
  }

  void constrain(Rect boundary, DVector off) {
    position.x =
        Utilities.constrain(position.x, boundary.left, boundary.right - off.x);
    position.y =
        Utilities.constrain(position.y, boundary.top, boundary.bottom - off.y);
  }

  void depleteLife() {
    lifespan = (lifespan - (mass / 5)).floor();
  }

  bool dead() {
    return lifespan <= 0;
  }
}
