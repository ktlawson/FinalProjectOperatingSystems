import 'package:flutter/material.dart';
import 'process.dart';
import 'scheduler.dart';
import 'csv_helper.dart';

void main() {
  runApp(const ProcessSchedulerApp());
}

class ProcessSchedulerApp extends StatelessWidget {
  const ProcessSchedulerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SchedulerScreen(),
    );
  }
}

class SchedulerScreen extends StatefulWidget {
  @override
  _SchedulerScreenState createState() => _SchedulerScreenState();
}

class _SchedulerScreenState extends State<SchedulerScreen> {
  List<Process> processes = [];
  String selectedStrategy = 'Round Robin';
  final strategies = ['Round Robin', 'Priority', 'SJF'];
  List<List<String>> results = [];

  void generateProcesses(int count) {
    processes = List.generate(
      count,
      (index) => Process(
        id: 'P${index + 1}',
        timeRequired: (index + 1) * 2,
        priority: index % 3,
      ),
    );
  }

  void runSimulation() {
    final scheduler = Scheduler(processes, strategy: selectedStrategy);
    scheduler.simulate(2); // Assume time slice of 2 units
    setState(() {
      results = scheduler.getSimulationResults();
    });

    exportToCsv(
      [['ID', 'Time Required', 'Time Allocated', 'Priority']] + results,
      'simulation_results',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Process Scheduler Simulator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                generateProcesses(5); // Generate 5 processes
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