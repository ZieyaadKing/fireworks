import 'dart:math';

import 'package:fireworks/main.dart';

import 'particle.dart';
import 'dvector.dart';

class Firework extends Particle {
  List<Particle> particles = [];
  int numParticles = 0;
  bool exploded = false;

  bool hasExploded() {
    return velocity.y >= 0;
  }

  void update() {
    if (!exploded) {
      addForce(gravity);
      super.update();
      exploded = hasExploded();
      if (exploded) explode();
    } else {
      List<Particle> deceased = [];

      particles.forEach((pt) {
        // DVector off = new DVector(pt.mass, pt.mass);
        pt.addForce(new DVector(0, 4.8));
        pt.update();
        pt.depleteLife();
        // pt.bounce(_screen, .55, off);
        // pt.constrain(_screen, off);

        if (pt.dead()) {
          deceased.add(pt);
        }
      });
      particles.removeWhere((pt) => deceased.contains(pt));
    }
  }

  void explode() {
    double angle = 0.0;
    double step = (2 * pi) / numParticles;

    Random random = Random();
    double strength = random.nextDouble() * 20.0 + 1.0;
    for (int i = 0; i < numParticles; i++) {
      Particle p = new Particle();

      p.position = new DVector(position.x, position.y);
      p.mass = random.nextDouble() * 10.0 + 1.0;
      p.text = text;

      p.velocity = new DVector(sin(angle) * strength, cos(angle) * strength);

      particles.add(p);
      angle += step;
    }
  }

  bool done() {
    return exploded && particles.length == 0;
  }
}
