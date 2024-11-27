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
      home: SchedulerScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SchedulerScreen extends StatefulWidget {
  @override
  _SchedulerScreenState createState() => _SchedulerScreenState();
}

class _SchedulerScreenState extends State<SchedulerScreen> {
  List<Process> processes = [];
  List<List<String>> results = []; // Store simulation results
  String selectedStrategy = 'Round Robin';
  final strategies = ['Round Robin', 'Priority', 'SJF'];
  final TextEditingController _controller = TextEditingController();

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

    // Store results in the state
    setState(() {
      results = scheduler.getSimulationResults();
    });

    // Export the results to CSV
    exportToCsv(
      [['ID', 'Time Required', 'Time Allocated', 'Priority']] + results,
      'simulation_results',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Process Scheduler Simulator'),
                    backgroundColor: Colors.blueAccent,),
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
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter number of processes',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                int count = int.tryParse(_controller.text) ?? 0;
                generateProcesses(count); // Generate 5 processes
                runSimulation();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Simulation completed!')),
                );
              },
              child: const Text('Run Simulation'),
            ),
            const SizedBox(height: 20),
            // Display Results in DataTable
            Expanded(
              child: results.isNotEmpty
                  ? DataTable(
                      columns: const [
                        DataColumn(label: Text('ID')),
                        DataColumn(label: Text('Time Required')),
                        DataColumn(label: Text('Time Allocated')),
                        DataColumn(label: Text('Priority')),
                      ],
                      rows: results.map((result) {
                        return DataRow(
                          cells: result.map((cell) {
                            return DataCell(Text(cell.toString()));
                          }).toList(),
                        );
                      }).toList(),
                    )
                  : const Text('No results to display. Run a simulation!'),
            ),
          ],
        ),
      ),
    );
  }
}
