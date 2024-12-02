class Process {
  final String id;
  final int timeRequired; // Total time needed
  int timeAllocated = 0;  // Time allocated so far
  final int priority; // Priority (for priority scheduling)

  Process({required this.id, required this.timeRequired, required this.priority});

  bool allocateTimeSlice(int timeSlice) {
    timeAllocated += timeSlice;
    return isCompleted();
  }

  bool isCompleted() => timeAllocated >= timeRequired;

  @override
  String toString() {
    return 'Process $id: Time Required: $timeRequired, Time Allocated: $timeAllocated';
  }
}