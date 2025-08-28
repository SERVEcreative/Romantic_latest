import '../../../shared/models/user_profile.dart';

class Call {
  final String id;
  final UserProfile caller;
  final UserProfile recipient;
  final DateTime timestamp;
  final CallType type;
  final CallStatus status;
  final Duration? duration;
  final bool isIncoming;

  Call({
    required this.id,
    required this.caller,
    required this.recipient,
    required this.timestamp,
    required this.type,
    required this.status,
    this.duration,
    required this.isIncoming,
  });
}

enum CallType {
  audio,
  video,
}

enum CallStatus {
  incoming,
  outgoing,
  connected,
  ended,
  missed,
  rejected,
}

class CallHistory {
  final List<Call> calls;
  final int totalCalls;
  final int missedCalls;

  CallHistory({
    required this.calls,
    required this.totalCalls,
    required this.missedCalls,
  });
}
