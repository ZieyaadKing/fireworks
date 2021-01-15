import 'package:fireworks/models/particle.dart';
import 'package:flutter/material.dart';

class RenderParticle extends StatefulWidget {
  final Particle particle = new Particle();

  RenderParticle({@required particle});

  @override
  _RenderParticleState createState() => _RenderParticleState();
}

class _RenderParticleState extends State<RenderParticle> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.particle.mass,
        height: widget.particle.mass,
        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle));
  }
}
