import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UsernameGenerationService {
  final String baseUrl = 'https://keyworldcargo.com/api';
  
  // Generate the next available username in the format H.E.S:CW550/name, H.E.S:CW551/name, etc.
  Future<String> generateNextUsername(String personName) async {
    try {
      // Get the last used username number from local storage
      final prefs = await SharedPreferences.getInstance();
      int lastNumber = prefs.getInt('last_username_number') ?? 549; // Start from 549 so next is 550
      
      // Find the next available username
      String nextUsername;
      bool isAvailable = false;
      int attempts = 0;
      const maxAttempts = 100; // Prevent infinite loop
      
      do {
        lastNumber++;
        nextUsername = 'H.E.S:CW$lastNumber/$personName';
        isAvailable = await _isUsernameAvailable(nextUsername);
        attempts++;
        
        if (attempts >= maxAttempts) {
          throw Exception('Unable to find available username after $maxAttempts attempts');
        }
      } while (!isAvailable);
      
      // Save the last used number
      await prefs.setInt('last_username_number', lastNumber);
      
      print('🎯 Generated username: $nextUsername');
      return nextUsername;
    } catch (e) {
      print('❌ Error generating username: $e');
      // Fallback: generate based on timestamp
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fallbackUsername = 'H.E.S:CW${timestamp.toString().substring(8)}/$personName'; // Use last 6 digits
      print('🎯 Using fallback username: $fallbackUsername');
      return fallbackUsername;
    }
  }
  
  // Check if a username is available by searching for it
  Future<bool> _isUsernameAvailable(String username) async {
    try {
      final url = '$baseUrl/get_users.php?data=$username';
      print('🔍 Checking username availability: $username');
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);
        
        // If response is empty array or null, username is available
        if (responseData is List) {
          return responseData.isEmpty;
        } else if (responseData is Map<String, dynamic>) {
          // If it's a direct response, check if it indicates no user found
          return responseData.isEmpty || responseData['error'] != null;
        }
        
        return true; // Assume available if we can't parse the response
      } else {
        // If API call fails, assume username is available
        print('⚠️ API call failed for username check, assuming available');
        return true;
      }
    } catch (e) {
      print('❌ Error checking username availability: $e');
      // If there's an error, assume username is available
      return true;
    }
  }
  
  // Reset the username counter (useful for testing or manual reset)
  Future<void> resetUsernameCounter() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('last_username_number');
      print('🔄 Username counter reset');
    } catch (e) {
      print('❌ Error resetting username counter: $e');
    }
  }
  
  // Get the current last username number (for debugging)
  Future<int> getLastUsernameNumber() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt('last_username_number') ?? 549;
    } catch (e) {
      print('❌ Error getting last username number: $e');
      return 549;
    }
  }
}
