import 'package:flutter/material.dart';

import 'Atom.dart';
import 'Atoms.dart';

class AtomListScreen extends StatefulWidget {
  const AtomListScreen({Key? key}) : super(key: key);

  @override
  _AtomListScreenState createState() => _AtomListScreenState();
}

class _AtomListScreenState extends State<AtomListScreen> {
  Atom? selectedAtom;
  List<Atom> atomList = Atoms.atomsList.entries.map((e) => e.value).toList();
  String? selectedGroup;

  // Get unique groups from the atom list
  List<String> get uniqueGroups {
    return atomList
        .map((atom) => atom.group)
        .toSet()
        .toList()
      ..sort();
  }

  @override
  Widget build(BuildContext context) {
    // Filter atoms based on the selected group
    List<Atom> filteredAtomList = selectedGroup != null
        ? atomList.where((atom) => atom.group == selectedGroup).toList()
        : atomList;

    return Scaffold(
        appBar: AppBar(title: const Text('Select Atom')),
    body: Column(
    children: [
    // Add a dropdown to filter atoms by their group
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: DropdownButton<String>(
        hint: const Text('Filter by group'),
        value: selectedGroup,
        onChanged: (String? newValue) {
          setState(() {
            selectedGroup = newValue;
          });
        },
        items: ['All', ...uniqueGroups].map<DropdownMenuItem<String>>((String group) {
          return DropdownMenuItem<String>(
            value: group == 'All' ? null : group,
            child: Text(group),
          );
        }).toList(),
      ),
    ),
      Expanded(
        child: ListView.builder(
          itemCount: filteredAtomList.length,
          itemBuilder: (BuildContext context, int index) {
            Atom atom = filteredAtomList[index];
            return ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(child: Text(atom.symbol)),
              ),
              title: Text(atom.name),
              onTap: () {
                Navigator.pop(context, atom);
              },
            );
          },
        ),
      ),
    ],
    ),
    );
  }
}


