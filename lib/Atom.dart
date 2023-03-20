import 'package:vector_math/vector_math_64.dart';

class Atom {
  final int id;
  final String name;
  final String group;
  final String symbol;
  final int atomicNumber;
  final int numberOfNeutrons;
  final double mass;
  final ElectronConfiguration electronConfiguration;
  Vector3 position;
  Vector3 velocity;

  Atom({
    required this.id,
    required this.name,
    required this.group,
    required this.symbol,
    required this.atomicNumber,
    required this.numberOfNeutrons,
    required this.mass,
    required this.electronConfiguration,
    required this.position,
    required this.velocity,
  });
}

class ElectronConfiguration {
  final List<Orbital> orbitals;

  ElectronConfiguration({required this.orbitals});

  @override
  String toString() {
    return orbitals.map((orbital) => '${orbital.type}${orbital.occupancy}').join(' ');
  }
}

class Orbital {
  final String type;
  final int occupancy;

  Orbital({required this.type, required this.occupancy});
}