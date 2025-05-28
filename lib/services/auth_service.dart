import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  final String baseUrl = 'https://keyworldcargo.com/api';
  
  // Check if a user exists by username or phone
  Future<UserModel?> searchUser(String data) async {
    try {
      final url = '$baseUrl/get_users.php?data=$data';
      print('🔍 Searching user with URL: $url');
      
      final response = await http.get(
        Uri.parse(url),
      );
      
      print('🔍 Search user response status: ${response.statusCode}');
      print('🔍 Search user response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);
        
        // Handle response that could be either a List or Map
        if (responseData is List && responseData.isNotEmpty) {
          return UserModel.fromJson(responseData[0]);
        } else if (responseData is Map<String, dynamic>) {
          // If it's a direct user object
          return UserModel.fromJson(responseData);
        }
        return null;
      } else {
        throw Exception('Failed to search for user: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error searching user: $e');
      throw Exception('Failed to search for user: $e');
    }
  }
  
  // Check if a user exists by phone number
  Future<UserModel?> getUserByPhone(String phone) async {
    try {
      final url = '$baseUrl/get_users.php?data=$phone';
      print('📱 Checking user by phone with URL: $url');
      
      final response = await http.get(
        Uri.parse(url),
      );
      
      print('📱 Get user by phone response status: ${response.statusCode}');
      print('📱 Get user by phone response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);
        
        // Handle response that could be either a List or Map
        if (responseData is List && responseData.isNotEmpty) {
          print('📱 Found user in list format');
          return UserModel.fromJson(responseData[0]);
        } else if (responseData is Map<String, dynamic>) {
          print('📱 Found user in map format');
          // If it's a direct user object
          return UserModel.fromJson(responseData);
        }
        print('📱 No user found');
        return null;
      } else {
        throw Exception('Failed to check user: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error getting user by phone: $e');
      throw Exception('Failed to check user: $e');
    }
  }
  
  // Get user by ID
  Future<UserModel?> getUserById(int id) async {
    try {
      final url = '$baseUrl/get_users.php?id=$id';
      print('🆔 Getting user by ID with URL: $url');
      
      final response = await http.get(
        Uri.parse(url),
      );
      
      print('🆔 Get user by ID response status: ${response.statusCode}');
      print('🆔 Get user by ID response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);
        
        // Handle response that could be either a List or Map
        if (responseData is List && responseData.isNotEmpty) {
          return UserModel.fromJson(responseData[0]);
        } else if (responseData is Map<String, dynamic>) {
          // If it's a direct user object
          return UserModel.fromJson(responseData);
        }
        return null;
      } else {
        throw Exception('Failed to get user: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error getting user by ID: $e');
      throw Exception('Failed to get user: $e');
    }
  }
  
  // Register a new user with city and optional username
  Future<UserModel> registerUserWithCity({
    required String firstName,
    required String lastName,
    String? username,
    required String phone,
    required String city,
  }) async {
    try {
      final name = '$firstName $lastName';
      
      // Prepare request body
      Map<String, String> requestBody = {
        'name': name,
        'phone': phone,
        'city': city,
      };
      
      // Add username only if provided
      if (username != null && username.isNotEmpty) {
        requestBody['username'] = username;
      }
      
      final url = '$baseUrl/create_user.php';
      print('🚀 Registration request URL: $url');
      print('🚀 Registration request body: $requestBody');
      
      // Make API call to register user
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: requestBody,
      );
      
      print('🚀 Registration response status: ${response.statusCode}');
      print('🚀 Registration response body: ${response.body}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        print('🚀 Parsed registration response: $data');
        
        if (data['success'] == true && data['user_id'] != null) {
          // Get user details with the returned ID
          final int userId = int.parse(data['user_id'].toString());
          print('🚀 Created user with ID: $userId');
          
          final user = await getUserById(userId);
          
          if (user != null) {
            // Save user to local storage
            await saveUserLocally(user);
            return user;
          } else {
            throw Exception('User created but details could not be retrieved');
          }
        } else {
          throw Exception('Registration failed: ${data['message'] ?? 'Unknown error'}');
        }
      } else {
        throw Exception('Registration failed: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Registration error: $e');
      throw Exception('Registration failed: $e');
    }
  }
  
  // Register a new user
  Future<UserModel> registerUser({
    required String firstName,
    required String lastName,
    required String username,
    required String phone,
  }) async {
    try {
      final name = '$firstName $lastName';
      
      // Make API call to register user
      final response = await http.post(
        Uri.parse('$baseUrl/create_user.php'),
        body: {
          'name': name,
          'username': username,
          'phone': phone,
          'role': 'customer',
          'is_active': '1',
        },
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['user_id'] != null) {
          // Get user details with the returned ID
          final int userId = int.parse(data['user_id'].toString());
          final user = await getUserById(userId);
          
          if (user != null) {
            // Save user to local storage
            await saveUserLocally(user);
            return user;
          } else {
            throw Exception('User created but details could not be retrieved');
          }
        } else {
          throw Exception('Registration failed: ${data['message']}');
        }
      } else {
        throw Exception('Registration failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }
  
  // Continue as guest
  Future<void> continueAsGuest() async {
    try {
      // Create a guest user model
      final guestUser = UserModel(
        id: 0,
        name: 'Guest User',
        email: '',
        role: 'guest',
        isActive: 1,
        createdAt: DateTime.now().toString(),
        updatedAt: DateTime.now().toString(),
        username: 'guest_${DateTime.now().millisecondsSinceEpoch}',
        phone: '',
        city: '',
      );
      
      // Save guest user to local storage
      await saveUserLocally(guestUser);
    } catch (e) {
      throw Exception('Failed to continue as guest: $e');
    }
  }
  
  // Check if user is guest
  bool isGuestUser(UserModel? user) {
    return user?.id == 0 && user?.role == 'guest';
  }
  
  // Save user to local storage
  Future<void> saveUserLocally(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', json.encode(user.toJson()));
      await prefs.setBool('isLoggedIn', true);
    } catch (e) {
      throw Exception('Failed to save user locally: $e');
    }
  }
  
  // Get locally stored user
  Future<UserModel?> getLocalUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userString = prefs.getString('user');
      
      if (userString != null) {
        return UserModel.fromJson(json.decode(userString));
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  
  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool('isLoggedIn') ?? false;
    } catch (e) {
      return false;
    }
  }
  
  // Log out
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user');
      await prefs.setBool('isLoggedIn', false);
    } catch (e) {
      throw Exception('Failed to logout: $e');
    }
  }
} 