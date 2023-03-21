import 'package:atom_simulator/Atoms.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'Atom.dart';
import 'AtomListScreen.dart';
import 'AtomPainter.dart';

void main() {
  runApp(const MaterialApp(home: AtomSimulation()));
}

class AtomSimulation extends StatefulWidget {
  const AtomSimulation({Key? key}) : super(key: key);

  @override
  _AtomSimulationState createState() => _AtomSimulationState();
}

class _AtomSimulationState extends State<AtomSimulation> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> animation;
  late final Tween<double> tween;
  Atom selectedAtom = Atoms.atomsList['hydrogen']!;
  List<Atom> atomList = Atoms.atomsList.entries.map((e) => e.value).toList();
  bool showOrbitLines = true;

  Future<void> _selectAtom() async {
    final selectedAtom = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AtomListScreen()),
    );
    if (selectedAtom != null) {
      setState(() {
        this.selectedAtom = selectedAtom;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 600),
      vsync: this,
    );

    tween = Tween<double>(begin: 0, end: 1); // Add this line
    animation = tween.animate(CurvedAnimation(parent: _controller, curve: Curves.linear)); // Modify this line
    _controller.repeat();
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AtomPro'),
        actions: [
          buildViewOrbitalsButton(),
        ],
      ),
      body: SlidingUpPanel(
        panel: _buildAtomInfoPanel(context),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildSelectAtomButtom(),
              buildAtomViewer(),
            ],
          ),
        ),
        minHeight: 80, // Adjust this value to control how much of the card is visible initially
        maxHeight: MediaQuery.of(context).size.height * 0.3, // Adjust this value to control how much the card can expand
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
      ),
    );
  }


  Expanded buildAtomViewer() {
    return Expanded(
            child: InteractiveViewer(
              panEnabled: true,
              scaleEnabled: true,
              maxScale: 10.0, // You can adjust this value to limit the maximum zoom level
              minScale: 0.1, // You can adjust this value to limit the minimum zoom level
              child: Center(
                  child: CustomPaint(
                painter: AtomPainter(atom: selectedAtom, animation: animation, showOrbitLines: showOrbitLines),
              )),
            ),
          );
  }

  ElevatedButton buildSelectAtomButtom() {
    return ElevatedButton(
            onPressed: _selectAtom,
            child: Text(selectedAtom.name),
          );
  }

  IconButton buildViewOrbitalsButton() {
    return IconButton(
          onPressed: () {
            setState(() {
              showOrbitLines = !showOrbitLines;
            });
          },
          icon: showOrbitLines ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
        );
  }

  Widget _buildAtomInfoPanel(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(child: Text(selectedAtom.symbol)),
              ),
              const SizedBox(width: 16.0), // Add some spacing between the symbol container and the name
              Text(selectedAtom.name, style: Theme.of(context).textTheme.headlineSmall),
            ],
          ),
          const SizedBox(height: 12.0),
          const Text(''),
          Text('Atomic Number: ${selectedAtom.atomicNumber}'),
          Text('Number of Neutrons: ${selectedAtom.numberOfNeutrons}'),
          Text('Mass: ${selectedAtom.mass}'),
          Text('Group: ${selectedAtom.group}'),
          const SizedBox(height: 8.0),
          Text('Electron Configuration:', style: Theme.of(context).textTheme.titleMedium),
          Text(selectedAtom.electronConfiguration.toString()),
          const Text('\n')
        ],
      ),
    );
  }


}