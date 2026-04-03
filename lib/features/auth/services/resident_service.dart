//dependencies
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive/hive.dart';

import 'package:agap/core/services/supabase_service.dart';
import 'package:agap/features/auth/models/resident_data.dart';

//handle resident db operations
class ResidentService {
  final SupabaseClient client = SupabaseService.client;
  final Box cache = Hive.box("app_cache");

  //get resident profile info with cache
  Future<ResidentData?> getResidentData(String userId) async {
    try {
      final data = await client.from('resident').select()
          .eq('id', userId).maybeSingle();

        if (data != null) {
          cache.put('profile_$userId', data);

          return ResidentData.fromJson(data);
        }

        return null;
    } catch (e) {
      debugPrint("Error fetching resident data: $e");
      
      //cache fallback
      final cachedData = cache.get('profile_$userId');
      if (cachedData is Map) {
        debugPrint("Using cached resident data for user $userId");
      
        return ResidentData.fromJson(
          Map<String, dynamic>.from(cachedData)
        );
      }
      return null;
    }
  }


  //update resident profile
  Future<void> updateResidentData({
    required String userId, required ResidentData data}) async {
      try {
        await client.from('resident').update(data.toJson()).eq('id', userId);

        cache.put('profile_$userId', data.toJson());
      } catch (e) {
        debugPrint("Error updating resident data: $e");
        throw Exception("Failed to update resident data");
      }
    }

    //create responder profile 
    Future<void> createResponderProfile({
      required String userId,
      required String responderType,
    }) async {
      try {
        await client.from('responder').insert({
          'id': userId,
          'responder_type': responderType
        });
      } catch (e) {
        debugPrint("Error creating responder profile: $e");
        throw Exception("Failed to create responder profile");
      }
    }

    //check if responder profile exists
    Future<bool> isResponder(String userId) async {
      try {
        final data = await client.from('responder')
              .select().eq('id', userId)
              .eq('verification_status', 'approved').maybeSingle();
        
        return data != null;
      } catch (e) {
        debugPrint("Error checking responder profile: $e");
        return false;
      }
    }

    //clear cached profile data
    void clearCachedProfile(String userId) {
      cache.delete("profile_$userId");
    }
}