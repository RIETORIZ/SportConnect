// lib/services/user_service.dart

import 'api_service.dart';
import '../models/team.dart';
import '../models/user.dart';

class UserService {
  // Get the current user's profile
  static Future<Map<String, dynamic>> getUserProfile() async {
    return await ApiService.getUserProfile();
  }

  // Update the current user's profile
  static Future<Map<String, dynamic>> updateUserProfile(
      Map<String, dynamic> profileData) async {
    return await ApiService.updateUserProfile(profileData);
  }

  // Get user's team members
  static Future<List<dynamic>> getTeamMembers(int teamId) async {
    try {
      final team = await ApiService.getTeamDetails(teamId);
      return team.playerIds;
    } catch (e) {
      print('Get team members error: $e');
      throw Exception('Failed to get team members: $e');
    }
  }

  // Get user's family members (for Player role)
  static Future<List<dynamic>> getFamilyMembers() async {
    try {
      final response = await ApiService.getUserProfile();
      return response['family_members'] ?? [];
    } catch (e) {
      print('Get family members error: $e');
      throw Exception('Failed to get family members: $e');
    }
  }

  // Add a family member (for Player role)
  static Future<Map<String, dynamic>> addFamilyMember(int userId) async {
    try {
      final response = await ApiService.updateUserProfile({
        'add_family_member': userId,
      });
      return response;
    } catch (e) {
      print('Add family member error: $e');
      throw Exception('Failed to add family member: $e');
    }
  }

  // Remove a family member (for Player role)
  static Future<Map<String, dynamic>> removeFamilyMember(int userId) async {
    try {
      final response = await ApiService.updateUserProfile({
        'remove_family_member': userId,
      });
      return response;
    } catch (e) {
      print('Remove family member error: $e');
      throw Exception('Failed to remove family member: $e');
    }
  }
}
