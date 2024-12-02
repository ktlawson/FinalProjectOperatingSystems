import 'dart:math';
import 'process.dart';

class Scheduler {
  final List<Process> processes;
  final String strategy;

  Scheduler(this.processes, {this.strategy = 'Round Robin'});

  void simulate(int timeSlice) {
    if (strategy == 'Round Robin') {
      roundRobin(timeSlice);
    } else if (strategy == 'Priority') {
      priorityScheduling(timeSlice);
    } else if (strategy == 'SJF') {
      shortestJobFirst(timeSlice);
    }
  }

  void roundRobin(int timeSlice) {
    bool allCompleted;
    do {
      allCompleted = true;
      for (var process in processes) {
        if (!process.isCompleted()) {
          allCompleted = false;
          process.allocateTimeSlice(min(timeSlice, process.timeRequired - process.timeAllocated));
        }
      }
    } while (!allCompleted);
  }

  void priorityScheduling(int timeSlice) {
    processes.sort((a, b) => a.priority.compareTo(b.priority));
    for (var process in processes) {
      while (!process.isCompleted()) {
        process.allocateTimeSlice(min(timeSlice, process.timeRequired - process.timeAllocated));
      }
    }
  }

  void shortestJobFirst(int timeSlice) {
    processes.sort((a, b) => a.timeRequired.compareTo(b.timeRequired));
    for (var process in processes) {
      while (!process.isCompleted()) {
        process.allocateTimeSlice(min(timeSlice, process.timeRequired - process.timeAllocated));
      }
    }
  }

  List<List<String>> getSimulationResults() {
    return processes.map((p) => [p.id.toString(), p.timeRequired.toString(), p.timeAllocated.toString(), p.priority.toString()]).toList();;
  }
}
