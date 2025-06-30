import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import '../utils/app_colors.dart';
import '../utils/app_localizations.dart';
import '../widgets/whatsapp_floating_button.dart';

class AuthScreen extends StatefulWidget {
  final String? username;
  final String? phone;
  
  const AuthScreen({Key? key, this.username, this.phone}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _usernameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _cityController;
  final AuthService _authService = AuthService();
  
  bool _isLoading = false;
  String? _errorMessage;
  bool _hasUsername = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _usernameController = TextEditingController(text: widget.username ?? '');
    _phoneController = TextEditingController(text: widget.phone ?? '');
    _cityController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      if (_cityController.text.trim().isEmpty) {
        setState(() {
          _errorMessage = 'Please enter your city';
        });
        return;
      }

      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        print('📝 Starting registration process...');
        print('📝 Phone number to check: ${_phoneController.text}');
        
        // Check if user already exists with this phone number
        final existingUser = await _authService.getUserByPhone(_phoneController.text);
        
        if (existingUser != null) {
          print('📝 User already exists: ${existingUser.toJson()}');
          // User already exists
          setState(() {
            _errorMessage = 'A user with this phone number already exists. Please try logging in instead.';
          });
          return;
        }

        print('📝 No existing user found, proceeding with registration...');
        print('📝 Registration data:');
        print('   - Name: ${_firstNameController.text} ${_lastNameController.text}');
        print('   - Phone: ${_phoneController.text}');
        print('   - City: ${_cityController.text}');
        print('   - Has username: $_hasUsername');
        if (_hasUsername) {
          print('   - Username: ${_usernameController.text}');
        }

        // Register the new user
        final user = await _authService.registerUserWithCity(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          username: _hasUsername ? _usernameController.text : null,
          phone: _phoneController.text,
          city: _cityController.text.trim(),
        );
        
        print('📝 Registration successful: ${user.toJson()}');
        
        if (!mounted) return;
        
        final localizations = AppLocalizations.of(context);
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations.accountCreated),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
        
        // Navigate to home screen and clear the stack
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      } catch (e) {
        print('❌ Registration failed: $e');
        setState(() {
          _errorMessage = e.toString();
        });
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.createAccount),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      
                      // Title
                      Text(
                        localizations.createYourAccount,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      Text(
                        localizations.fillDetails,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // First Name and Last Name in a row
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _firstNameController,
                              decoration: InputDecoration(
                                labelText: localizations.firstName,
                                hintText: localizations.enterFirstName,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your first name';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _lastNameController,
                              decoration: InputDecoration(
                                labelText: localizations.lastName,
                                hintText: localizations.enterLastName,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your last name';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Phone Number
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: localizations.phoneNumber,
                          hintText: localizations.enterPhoneNumber,
                          prefixIcon: const Icon(Icons.phone),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return localizations.invalidPhone;
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // City Text Field
                      TextFormField(
                        controller: _cityController,
                        decoration: InputDecoration(
                          labelText: localizations.city,
                          hintText: localizations.selectCity,
                          prefixIcon: const Icon(Icons.location_city),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your city';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Username Options
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            localizations.username,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          
                          // Radio buttons for username options
                          Row(
                            children: [
                              Expanded(
                                child: RadioListTile<bool>(
                                  title: Text(localizations.haveUsername),
                                  value: true,
                                  groupValue: _hasUsername,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _hasUsername = value ?? false;
                                    });
                                  },
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<bool>(
                                  title: Text(localizations.noUsername),
                                  value: false,
                                  groupValue: _hasUsername,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _hasUsername = value ?? false;
                                    });
                                  },
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                ),
                              ),
                            ],
                          ),
                          
                          if (_hasUsername) ...[
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                hintText: localizations.enterUsername,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (value) {
                                if (_hasUsername) {
                                  if (value == null || value.isEmpty) {
                                    return localizations.usernameRequired;
                                  }
                                  if (!value.startsWith('H.E')) {
                                    return localizations.usernameFormat;
                                  }
                                }
                                return null;
                              },
                            ),
                          ],
                        ],
                      ),
                      
                      // Error message
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      
                      const SizedBox(height: 32),
                      
                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  localizations.createAccount,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Back to login
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          localizations.alreadyHaveAccount,
                          style: const TextStyle(
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const WhatsAppFloatingButton(heroTag: "auth_help_fab"),
        ],
      ),
    );
  }
} 