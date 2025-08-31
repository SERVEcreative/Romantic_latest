import '../utils/logger.dart';
import 'api_service.dart';

class PricingService {
  static const String _setPricingEndpoint = '/pricing/set-pricing';
  static const String _updatePricingEndpoint = '/pricing/update-pricing';

  /// Set complete pricing for a host
  static Future<PricingResponse> setPricing({
    required double smsCost,
    required double audioCallCost,
    required double videoCallCost,
  }) async {
    try {
      Logger.info('🔄 Setting pricing: SMS=$smsCost, Audio=$audioCallCost, Video=$videoCallCost');
      
      final response = await ApiService.post(
        _setPricingEndpoint,
        body: {
          'sms_cost': smsCost,
          'audio_call_cost': audioCallCost,
          'video_call_cost': videoCallCost,
        },
      );
      
      if (response['success'] == true) {
        Logger.success('✅ Pricing set successfully');
        return PricingResponse(
          success: true,
          message: response['message'] ?? 'Pricing updated successfully',
          pricing: PricingData.fromMap(response['data'] ?? {}),
        );
      } else {
        Logger.warning('⚠️ Failed to set pricing: ${response['message']}');
        return PricingResponse(
          success: false,
          message: response['message'] ?? 'Failed to set pricing',
        );
      }
    } catch (e) {
      Logger.error('❌ Failed to set pricing', e);
      return PricingResponse(
        success: false,
        message: 'Failed to set pricing: ${e.toString()}',
      );
    }
  }

  /// Update specific pricing fields
  static Future<PricingResponse> updatePricing({
    double? smsCost,
    double? audioCallCost,
    double? videoCallCost,
  }) async {
    try {
      Logger.info('🔄 Updating pricing...');
      
      final updateData = <String, dynamic>{};
      if (smsCost != null) updateData['sms_cost'] = smsCost;
      if (audioCallCost != null) updateData['audio_call_cost'] = audioCallCost;
      if (videoCallCost != null) updateData['video_call_cost'] = videoCallCost;
      
      final response = await ApiService.put(
        _updatePricingEndpoint,
        body: updateData,
      );
      
      if (response['success'] == true) {
        Logger.success('✅ Pricing updated successfully');
        return PricingResponse(
          success: true,
          message: response['message'] ?? 'Pricing updated successfully',
          pricing: PricingData.fromMap(response['data'] ?? {}),
        );
      } else {
        Logger.warning('⚠️ Failed to update pricing: ${response['message']}');
        return PricingResponse(
          success: false,
          message: response['message'] ?? 'Failed to update pricing',
        );
      }
    } catch (e) {
      Logger.error('❌ Failed to update pricing', e);
      return PricingResponse(
        success: false,
        message: 'Failed to update pricing: ${e.toString()}',
      );
    }
  }

  /// Get current pricing (if you have a GET endpoint)
  static Future<PricingResponse> getCurrentPricing() async {
    try {
      Logger.info('🔄 Fetching current pricing...');
      
      final response = await ApiService.get('/pricing/current');
      
      if (response['success'] == true) {
        Logger.success('✅ Current pricing fetched successfully');
        return PricingResponse(
          success: true,
          message: 'Pricing fetched successfully',
          pricing: PricingData.fromMap(response['data'] ?? {}),
        );
      } else {
        Logger.warning('⚠️ Failed to fetch pricing: ${response['message']}');
        return PricingResponse(
          success: false,
          message: response['message'] ?? 'Failed to fetch pricing',
        );
      }
    } catch (e) {
      Logger.error('❌ Failed to fetch pricing', e);
      return PricingResponse(
        success: false,
        message: 'Failed to fetch pricing: ${e.toString()}',
      );
    }
  }
}

/// Pricing data model
class PricingData {
  final double smsCost;
  final double audioCallCost;
  final double videoCallCost;
  final DateTime? updatedAt;

  const PricingData({
    required this.smsCost,
    required this.audioCallCost,
    required this.videoCallCost,
    this.updatedAt,
  });

  factory PricingData.fromMap(Map<String, dynamic> map) {
    return PricingData(
      smsCost: (map['sms_cost'] ?? 15.0).toDouble(),
      audioCallCost: (map['audio_call_cost'] ?? 30.0).toDouble(),
      videoCallCost: (map['video_call_cost'] ?? 60.0).toDouble(),
      updatedAt: map['updated_at'] != null 
          ? DateTime.tryParse(map['updated_at']) 
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sms_cost': smsCost,
      'audio_call_cost': audioCallCost,
      'video_call_cost': videoCallCost,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  PricingData copyWith({
    double? smsCost,
    double? audioCallCost,
    double? videoCallCost,
    DateTime? updatedAt,
  }) {
    return PricingData(
      smsCost: smsCost ?? this.smsCost,
      audioCallCost: audioCallCost ?? this.audioCallCost,
      videoCallCost: videoCallCost ?? this.videoCallCost,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Pricing response model
class PricingResponse {
  final bool success;
  final String message;
  final PricingData? pricing;

  const PricingResponse({
    required this.success,
    required this.message,
    this.pricing,
  });
}
