import 'dart:math';
import 'process.dart';

class Scheduler {
  final List<Process> processes;
  final String strategy;
  List<List<String>> simulationResults = [];

  Scheduler(this.processes, {this.strategy = 'Round Robin'});

  void simulate(int timeSlice) {
    simulationResults.clear(); // Clear previous results
    if (strategy == 'Round Robin') {
      roundRobin(timeSlice);
    } else if (strategy == 'Priority') {
      priorityScheduling();
    } else if (strategy == 'SJF') {
      shortestJobFirst();
    }
  }

  void roundRobin(int timeSlice) {
    List<Process> queue = List.from(processes);
    int currentTime = 0;

    while (queue.isNotEmpty) {
      Process process = queue.removeAt(0);

      int timeAllocated = min(timeSlice, process.timeRequired - process.timeAllocated);
      process.allocateTimeSlice(timeAllocated);
      currentTime += timeAllocated;

      // Record the current state of the process
      simulationResults.add([
        process.id,
        process.timeRequired.toString(),
        timeAllocated.toString(),
        process.priority.toString()
      ]);

      if (!process.isCompleted()) {
        queue.add(process);
      } else {
        process.calculateMetrics(currentTime);
      }
    }
  }

  void priorityScheduling() {
    List<Process> queue = List.from(processes);
    queue.sort((a, b) => a.priority.compareTo(b.priority));
    int currentTime = 0;

    for (var process in queue) {
      int timeAllocated = process.timeRequired - process.timeAllocated;
      process.allocateTimeSlice(timeAllocated);
      currentTime += timeAllocated;

      // Record the current state of the process
      simulationResults.add([
        process.id,
        process.timeRequired.toString(),
        timeAllocated.toString(),
        process.priority.toString()
      ]);

      process.calculateMetrics(currentTime);
    }
  }

  void shortestJobFirst() {
    List<Process> queue = List.from(processes);
    queue.sort((a, b) => a.timeRequired.compareTo(b.timeRequired)); // Sort by shortest time required
    int currentTime = 0;

    for (var process in queue) {
      int timeAllocated = process.timeRequired - process.timeAllocated;
      process.allocateTimeSlice(timeAllocated);
      currentTime += timeAllocated;

      // Record the current state of the process
      simulationResults.add([
        process.id,
        process.timeRequired.toString(),
        timeAllocated.toString(),
        process.priority.toString()
      ]);

      process.calculateMetrics(currentTime);
    }
  }

  List<List<String>> getSimulationResults() {
    return simulationResults;
  }

  double calculateAverageTurnaroundTime() {
    int totalTurnaroundTime = processes.fold(0, (sum, process) => sum + process.turnaroundTime);
    return totalTurnaroundTime / processes.length;
  }

  double calculateAverageWaitingTime() {
    int totalWaitingTime = processes.fold(0, (sum, process) => sum + process.waitingTime);
    return totalWaitingTime / processes.length;
  }
}