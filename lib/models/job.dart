//model for jobs (scheduled working shifts at a customer)
import 'dart:ui';
import 'package:meta/meta.dart';

class Job {
  Job({@required this.id, @required this.name, @required this.jobDuration});
  final String id;
  final String name;
  final int jobDuration;

  factory Job.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    if (name == null) {
      return null;
    }
    final int jobDuration = data['jobDuration'];
    return Job(id: documentId, name: name, jobDuration: jobDuration);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'jobDuration': jobDuration,
    };
  }

  @override
  int get hashCode => hashValues(id, name, jobDuration);

  @override
  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final Job otherJob = other;
    return id == otherJob.id &&
        name == otherJob.name &&
        jobDuration == otherJob.jobDuration;
  }

  @override
  String toString() => 'id: $id, name: $name, jobDuration: $jobDuration';
}
