import 'Atom.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class AtomPainter extends CustomPainter {
  final Atom atom;
  final double baseSpeedFactor = -200.0;
  final Animation<double> animation;
  static const double electronRadius = 2.0;
  static const double protonRadius = 3.0;
  static const double neutronRadius = 3.0;
  final bool showOrbitLines;

  AtomPainter({required this.atom, required this.animation, required this.showOrbitLines}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final Paint protonPaint = Paint()..color = Colors.red;
    final Paint neutronPaint = Paint()..color = Colors.grey;
    List<Color> electronColors = [Colors.blue, Colors.green, Colors.orange, Colors.purple];

    // Convert atom position from 3D to 2D (ignoring the z-axis)
    Offset atomPosition2D = Offset(centerX + atom.position.x, centerY + atom.position.y);

    // Calculate nucleus radius based on atomic mass
    double nucleusRadius = math.sqrt(atom.mass);
    drawProtonsAndNeutrons(neutronPaint, protonPaint, atomPosition2D, nucleusRadius, canvas);
    drawElectrons(nucleusRadius, electronColors, canvas, atomPosition2D);
  }

  void drawProtonsAndNeutrons(Paint neutronPaint, Paint protonPaint, Offset atomPosition2D, double nucleusRadius, Canvas canvas) {
    int numberOfNucleons = atom.atomicNumber + atom.numberOfNeutrons;
    bool startWithNeutrons = atom.atomicNumber < atom.numberOfNeutrons;
    for (int i = 0; i < numberOfNucleons; i++) {
      double angle = i * 2 * math.pi / numberOfNucleons;
      double nucleonRadius = (i < atom.atomicNumber ? protonRadius : neutronRadius);


      Paint nucleonPaint;
      if (startWithNeutrons) {
        nucleonPaint = i < atom.atomicNumber ? neutronPaint : protonPaint;
      } else {
        nucleonPaint = i < atom.atomicNumber ? protonPaint : neutronPaint;
      }

      Offset nucleonPosition = Offset(
        atomPosition2D.dx + nucleusRadius * math.cos(angle),
        atomPosition2D.dy + nucleusRadius * math.sin(angle),
      );
      canvas.drawCircle(nucleonPosition, nucleonRadius, nucleonPaint);
    }
  }

  void drawElectrons(double nucleusRadius, List<Color> electronColors, Canvas canvas, Offset atomPosition2D) {
    int electronIndex = 0;
    for (var orbital in atom.electronConfiguration.orbitals) {
      double orbitalRadius = (electronIndex + 1) * 15.0 + nucleusRadius;
      Paint electronPaint = Paint()..color = electronColors[electronIndex % electronColors.length];
      drawOrbitLine(canvas, atomPosition2D, orbitalRadius, orbital, electronIndex, electronPaint);
      electronIndex++;
    }
  }

  void drawOrbitLine(Canvas canvas, Offset atomPosition2D, double orbitalRadius, Orbital orbital, int electronIndex, Paint electronPaint) {
    if (showOrbitLines) {
      Paint orbitPaint = Paint()
        ..color = Colors.grey.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;
      canvas.drawCircle(atomPosition2D, orbitalRadius, orbitPaint);
    }

    for (int i = 0; i < orbital.occupancy; i++) {
      double phaseOffset = (2 * math.pi * i) / orbital.occupancy;

      double speedFactor = baseSpeedFactor / math.pow(electronIndex + 1, 1.2); // Modify speed factor based on orbital index
      double angle = phaseOffset +
          (((electronIndex % 2 == 0) ? 1 : -1) * animation.value * speedFactor * 2 * math.pi);

      Offset electronPosition = Offset(
        atomPosition2D.dx + orbitalRadius * math.cos(angle),
        atomPosition2D.dy + orbitalRadius * math.sin(angle),
      );
      canvas.drawCircle(electronPosition, electronRadius, electronPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
