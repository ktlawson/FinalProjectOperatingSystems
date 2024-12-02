import 'package:flutter/material.dart';

import 'csv_helper.dart';
import 'process.dart';
import 'scheduler.dart';

void main() {
  runApp(const ProcessSchedulerApp());
}

class ProcessSchedulerApp extends StatelessWidget {
  const ProcessSchedulerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SchedulerScreen(),
    );
  }
}

class SchedulerScreen extends StatefulWidget {
  const SchedulerScreen({super.key});

  @override
  _SchedulerScreenState createState() => _SchedulerScreenState();
}

class _SchedulerScreenState extends State<SchedulerScreen> {
  List<Process> processes = [];
  String selectedStrategy = 'Round Robin';
  int _processCount = 5;
  int _timeSlice = 2;
  int _timeRequiredMultiplier = 2;
  final strategies = ['Round Robin', 'Priority', 'SJF'];
  List<List<String>> results = [];
  TextEditingController? processCountController;
  TextEditingController? timeSliceController;
  TextEditingController? timeRequiredMultiplierController;

  @override
  void initState() {
    super.initState();
    processCountController = TextEditingController(text: _processCount.toString());
    timeSliceController = TextEditingController(text: _timeSlice.toString());
    timeRequiredMultiplierController = TextEditingController(text: _timeRequiredMultiplier.toString());
  }

  void generateProcesses() {
    processes = List.generate(
      _processCount,
      (index) => Process(
        id: 'P${index + 1}',
        timeRequired: (index + 1) * _timeRequiredMultiplier,
        priority: index % 3,
      ),
    );
  }

  void runSimulation() {
    final scheduler = Scheduler(processes, strategy: selectedStrategy);
    scheduler.simulate(_timeSlice); // Assume time slice of 2 units
    setState(() {
      results = scheduler.getSimulationResults();
    });

    exportToCsv(
      [
            ['ID', 'Time Required', 'Time Allocated', 'Priority']
          ] +
          results,
      'simulation_results',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('Process Scheduler Simulator',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select Strategy',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8), // Spacing between title and TextField
                      DropdownButton<String>(
                        value: selectedStrategy,
                        onChanged: (value) {
                          setState(() {
                            selectedStrategy = value!;
                          });
                        },
                        items: strategies.map((strategy) {
                          return DropdownMenuItem(
                            value: strategy,
                            child: Text(strategy),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 200,
                  child: LabeledTextField(
                    title: 'Process Count',
                    controller: processCountController!,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _processCount = int.tryParse(value) ?? 0;
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: LabeledTextField(
                    title: 'Time Slice',
                    controller: timeSliceController!,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _timeSlice = int.tryParse(value) ?? 2;
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: LabeledTextField(
                    title: 'Time Req. Multiplier',
                    controller: timeRequiredMultiplierController!,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _timeRequiredMultiplier = int.tryParse(value) ?? 0;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                generateProcesses(); // Generate 5 processes
                runSimulation();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Simulation completed.')),
                );
              },
              child: const Text('Run Simulation'),
            ),
            const SizedBox(height: 16),
            if (results.isNotEmpty) Expanded(child: buildResultsTable()),
          ],
        ),
      ),
    );
  }

  Widget buildResultsTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('ID')),
          DataColumn(label: Text('Time Required')),
          DataColumn(label: Text('Time Allocated')),
          DataColumn(label: Text('Priority')),
        ],
        rows: results
            .map(
              (row) => DataRow(
                cells: row.map((cell) => DataCell(Text(cell.toString()))).toList(),
              ),
            )
            .toList(),
      ),
    );
  }
}

class LabeledTextField extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final Function(String)? onChanged;
  final String? hintText;

  const LabeledTextField({
    super.key,
    required this.title,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8), // Spacing between title and TextField
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            border: const OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
