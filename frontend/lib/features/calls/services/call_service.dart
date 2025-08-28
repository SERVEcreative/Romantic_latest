import '../../../shared/models/user_profile.dart';
import '../models/call_models.dart';
import '../../../core/utils/logger.dart';

class CallService {
  static final List<Call> _callHistory = [];
  
  // Mock data for demonstration
  static List<Call> getMockCallHistory() {
    final names = ['Sarah Johnson', 'Emma Wilson', 'Olivia Davis', 'Sophia Brown', 'Isabella Miller'];
    final times = [
      DateTime.now().subtract(const Duration(minutes: 2)),
      DateTime.now().subtract(const Duration(minutes: 5)),
      DateTime.now().subtract(const Duration(hours: 1)),
      DateTime.now().subtract(const Duration(hours: 2)),
      DateTime.now().subtract(const Duration(days: 1)),
    ];
    final isIncoming = [true, false, true, false, true];
    final statuses = [
      CallStatus.ended,
      CallStatus.ended,
      CallStatus.missed,
      CallStatus.ended,
      CallStatus.ended,
    ];
    final durations = [
      const Duration(minutes: 5),
      const Duration(minutes: 12),
      null,
      const Duration(minutes: 8),
      const Duration(minutes: 15),
    ];

    return List.generate(5, (index) {
      final user = UserProfile(
        id: 'user_$index',
        name: names[index],
        fullName: names[index],
        age: 25 + index,
        gender: 'female',
        bio: 'Love traveling and coffee ☕',
        location: 'New York',
        image: '',
        photoUrl: null,
        email: '${names[index].toLowerCase().replaceAll(' ', '')}@example.com',
        phoneNumber: '+1234567${index.toString().padLeft(3, '0')}',
        online: true,
        lastSeen: '2 min ago',
        isVerified: true,
        createdAt: DateTime.now().subtract(Duration(days: 30 - index)),
        updatedAt: DateTime.now(),
        isSuperLover: index % 2 == 0,
      );

      return Call(
        id: 'call_$index',
        caller: isIncoming[index] ? user : UserProfile.getCurrentUser(),
        recipient: isIncoming[index] ? UserProfile.getCurrentUser() : user,
        timestamp: times[index],
        type: CallType.audio,
        status: statuses[index],
        duration: durations[index],
        isIncoming: isIncoming[index],
      );
    });
  }

  static Future<List<Call>> getCallHistory() async {
    try {
      // In a real app, this would fetch from API or local database
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
      return getMockCallHistory();
    } catch (e) {
      Logger.error('Failed to fetch call history', e);
      return [];
    }
  }

  static Future<void> makeCall(UserProfile recipient, CallType type) async {
    try {
      Logger.info('Making ${type.name} call to ${recipient.fullName}');
      // In a real app, this would initiate the actual call
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      Logger.error('Failed to make call', e);
      rethrow;
    }
  }

  static Future<void> acceptCall(String callId) async {
    try {
      Logger.info('Accepting call: $callId');
      // In a real app, this would accept the incoming call
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      Logger.error('Failed to accept call', e);
      rethrow;
    }
  }

  static Future<void> rejectCall(String callId) async {
    try {
      Logger.info('Rejecting call: $callId');
      // In a real app, this would reject the incoming call
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      Logger.error('Failed to reject call', e);
      rethrow;
    }
  }

  static Future<void> endCall(String callId) async {
    try {
      Logger.info('Ending call: $callId');
      // In a real app, this would end the active call
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      Logger.error('Failed to end call', e);
      rethrow;
    }
  }

  static void addCallToHistory(Call call) {
    _callHistory.insert(0, call);
    Logger.info('Added call to history: ${call.id}');
  }

  static CallHistory getCallStatistics() {
    final totalCalls = _callHistory.length;
    final missedCalls = _callHistory.where((call) => call.status == CallStatus.missed).length;
    
    return CallHistory(
      calls: _callHistory,
      totalCalls: totalCalls,
      missedCalls: missedCalls,
    );
  }
}
