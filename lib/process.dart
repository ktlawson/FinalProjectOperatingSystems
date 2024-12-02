class Process {
  final String id;
  final int timeRequired; // Total time needed
  int timeAllocated = 0;  // Time allocated so far
  final int priority;     // Priority (for priority scheduling)

  // New fields for tracking additional metrics
  int arrivalTime = 0; // Default to 0 (can be set for dynamic scenarios)
  int completionTime = 0; // When the process finishes execution
  int turnaroundTime = 0; // Total time from arrival to completion
  int waitingTime = 0;    // Time spent waiting in the queue

  Process({required this.id, required this.timeRequired, required this.priority, this.arrivalTime = 0});

  // Simulate time allocation and check if the process is completed
  bool allocateTimeSlice(int timeSlice) {
    timeAllocated += timeSlice;
    return isCompleted();
  }

  // Check if the process has completed execution
  bool isCompleted() => timeAllocated >= timeRequired;

  // Calculate derived metrics once the process is completed
  void calculateMetrics(int currentTime) {
    completionTime = currentTime; // Current simulated time
    turnaroundTime = completionTime - arrivalTime;
    waitingTime = turnaroundTime - timeRequired;
  }

  @override
  String toString() {
    return 'Process $id: Time Required: $timeRequired, Time Allocated: $timeAllocated, Completion Time: $completionTime, Turnaround Time: $turnaroundTime, Waiting Time: $waitingTime';
  }
}
