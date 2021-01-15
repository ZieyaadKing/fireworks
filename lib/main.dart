import 'dart:async';
import 'dart:math';

import 'package:fireworks/models/firework.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'models/dvector.dart';
import 'models/particle.dart';

final DVector gravity = new DVector(0, 9.8);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Fireworks",
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Particle particle;
  List<Firework> particles = [];
  List<String> chars = List.generate(10, (index) => index.toString()).toList();
  Rect _screen = Rect.zero;
  Timer timer = Timer(Duration.zero, () {});
  Timer fireTimer = Timer(Duration.zero, () {});
  double fps = 1 / 30;
  bool pause = false;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Size size = MediaQuery.of(context).size;
      _screen = Rect.fromLTRB(0, 0, size.width, size.height);

      // Adding partiles
      setState(() {});
    });
    super.initState();

    timer = Timer.periodic(
        Duration(milliseconds: (fps * 1000).floor()), frameBuilder);
    fireTimer = Timer.periodic(Duration(seconds: 3), createParticles);
  }

  frameBuilder(dynamic timer) {
    if (pause) return;
    List<Firework> finishedFireworks = [];
    particles.forEach((element) {
      element.update();
      element.constrain(_screen, new DVector(element.mass, element.mass));
      if (element.done()) finishedFireworks.add(element);
    });
    particles.removeWhere((firework) => finishedFireworks.contains(firework));

    List<Particle> deadSparks = [];
    sparks.forEach((spark) {
      DVector off = new DVector(spark.mass, spark.mass);
      spark.bounce(_screen, .55, off);
      spark.constrain(_screen, off);
      spark.depleteLife();
      if (spark.dead()) deadSparks.add(spark);
    });
    sparks.removeWhere((spark) => deadSparks.contains(spark));
    setState(() {});
  }

  createParticles(timer) {
    if (pause) return;
    for (int i = 0; i < 1; i++) {
      Random random = new Random();
      Firework firework = new Firework();
      firework.position =
          new DVector(random.nextDouble() * _screen.right, _screen.bottom);
      firework.mass = random.nextDouble() * 20.0 + 10.0;
      firework.velocity = new DVector(0, -20);
      firework.numParticles = random.nextInt(10) + 5;
      firework.text = chars[random.nextInt(chars.length)];
      particles.add(firework);
    }
    setState(() {});
  }

  @override
  void dispose() {
    timer.cancel();
    fireTimer.cancel();
    super.dispose();
  }

  List<Particle> sparks = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[800],
      body: Stack(children: [
        Stack(
            children: particles.map((pt) {
          if (pt.exploded) {
            // List<Particle> temp = [];
            pt.particles.forEach((element) => sparks.add(element));
          } else {
            return ParticleLook(pt: pt);
          }
          return Container();
        }).toList()),
        Stack(
            children: sparks.map((pt) {
          return ParticleLook(pt: pt);
        }).toList()),
      ]),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton(
          mini: true,
          backgroundColor: Colors.white,
          elevation: 10,
          onPressed: () => setState(() => pause = !pause),
          child: Icon(pause ? Icons.play_arrow_outlined : Icons.pause_outlined,
              color: Colors.blue),
        ),
      ),
    );
  }
}

class ParticleLook extends StatelessWidget {
  final Particle pt;
  const ParticleLook({Key key, this.pt}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: pt.position.x,
        top: pt.position.y,
        child: Container(
          // color: Colors.white,
          width: pt.mass,
          height: pt.mass,
          decoration: BoxDecoration(
              color: pt.color.withAlpha(pt.lifespan), shape: BoxShape.circle),
          child: Center(
            child: Text(
              pt.text,
              style: TextStyle(fontSize: pt.mass / 2),
            ),
          ),
        ));
  }
}
