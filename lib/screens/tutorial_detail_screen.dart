import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/tutorial_model.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../utils/url_launcher_helper.dart';
import '../utils/app_colors.dart';
import '../utils/app_localizations.dart';

class TutorialDetailScreen extends StatefulWidget {
  final TutorialModel tutorial;

  const TutorialDetailScreen({Key? key, required this.tutorial}) : super(key: key);

  @override
  State<TutorialDetailScreen> createState() => _TutorialDetailScreenState();
}

class _TutorialDetailScreenState extends State<TutorialDetailScreen> {
  late YoutubePlayerController _controller;
  bool _isInitialized = false;
  bool _isPlayerReady = false;
  final AuthService _authService = AuthService();
  UserModel? _currentUser;

  @override
  void initState() {
    super.initState();
    // Allow all orientations for YouTube's native fullscreen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _initializePlayer();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = await _authService.getLocalUser();
      if (mounted) {
        setState(() {
          _currentUser = user;
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  String _processLongAddress(String longAddress) {
    if (_currentUser != null && _currentUser!.username.isNotEmpty) {
      return longAddress.replaceAll('*c*', _currentUser!.username);
    }
    return longAddress.replaceAll('*c*', 'account');
  }

  String _processTextField(String text) {
    if (_currentUser != null && _currentUser!.username.isNotEmpty) {
      return text.replaceAll('*c*', _currentUser!.username);
    }
    return text.replaceAll('*c*', 'account');
  }

  void _copyToClipboard(String text, String fieldName) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$fieldName copied to clipboard'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _initializePlayer() {
    final videoId = widget.tutorial.getYoutubeVideoId();
    if (videoId.isNotEmpty) {
      _controller = YoutubePlayerController.fromVideoId(
        videoId: videoId,
        autoPlay: false,
        params: const YoutubePlayerParams(
          showControls: true,
          showFullscreenButton: true, // Let YouTube handle fullscreen
          enableCaption: true,
          captionLanguage: 'en',
          showVideoAnnotations: false,
          enableJavaScript: true,
          strictRelatedVideos: true,
        ),
      );
      
      // Listen to player state changes
      _controller.listen((event) {
        if (mounted) {
          setState(() {
            _isPlayerReady = event.playerState == PlayerState.playing || 
                           event.playerState == PlayerState.paused ||
                           event.playerState == PlayerState.ended;
          });
        }
      });
      
      setState(() {
        _isInitialized = true;
      });
    }
  }





  @override
  void dispose() {
    // Reset orientation and UI settings
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    
    // Close the player controller properly
    if (_isInitialized) {
      _controller.close();
    }
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.tutorial.title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Enhanced Video player section
              _buildVideoPlayerSection(),
              
              const SizedBox(height: 16),
              
              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  widget.tutorial.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Address information (if available)
              if (widget.tutorial.hasAddressInfo) ..._buildAddressSection(),
              
              const SizedBox(height: 32),
              
              // Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 64),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Back to Tutorials'),
                ),
              ),
              
              const SizedBox(height: 120), // Space for bottom navigation
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoPlayerSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Video player
          _buildVideoPlayer(),
          

        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    if (!_isInitialized) {
      return Container(
        height: 220,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline, 
                color: Colors.white, 
                size: 48,
              ),
              SizedBox(height: 8),
              Text(
                'Video Not Available',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: YoutubePlayer(
        controller: _controller,
        aspectRatio: 16 / 9,
      ),
    );
  }

  

  List<Widget> _buildAddressSection() {
    return [
      // Address title
      if (widget.tutorial.addressTitle?.isNotEmpty == true)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            widget.tutorial.addressTitle!.toUpperCase(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlueShade(700),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      
      // Address note section in big box
      if (widget.tutorial.addressNote != null && widget.tutorial.addressNote!.isNotEmpty && widget.tutorial.addressNote != '0')
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.orange.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.note, color: Colors.orange.shade700, size: 24),
                  const SizedBox(width: 12),
                  Text(
                    'NOTE',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                _processTextField(widget.tutorial.addressNote!),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.orange.shade800,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),

      if (widget.tutorial.place?.isNotEmpty == true)
        _buildDetailField(
          label: 'Location',
          value: _processTextField(widget.tutorial.place!),
          icon: Icons.location_on,
        ),
      // Address detail fields
      if (widget.tutorial.firstName?.isNotEmpty == true )
        _buildDetailField(
          label: 'FIRST NAME',
          value: _processTextField(widget.tutorial.firstName!),
          icon: Icons.person,
        ),
      if (widget.tutorial.familyName?.isNotEmpty == true )
        _buildDetailField(    
          label: 'FAMILY NAME',
          value: _processTextField(widget.tutorial.familyName!),
          icon: Icons.family_restroom,
        ),
      if (widget.tutorial.primaryPhone.isNotEmpty)
        _buildDetailField(
          label: 'PRIMARY PHONE',
          value: _processTextField(widget.tutorial.primaryPhone),
          icon: Icons.phone,
        ),
      if (widget.tutorial.phone2?.isNotEmpty == true)
        _buildDetailField(
          label: 'SECONDARY PHONE',
          value: _processTextField(widget.tutorial.phone2!),
          icon: Icons.phone_android,
        ),
      if (widget.tutorial.state?.isNotEmpty == true)
        _buildDetailField(
          label: 'STATE',
          value: _processTextField(widget.tutorial.state!),
          icon: Icons.map,
        ),
       if (widget.tutorial.city?.isNotEmpty == true)
        _buildDetailField(
          label: 'CITY',
          value: _processTextField(widget.tutorial.city!),
          icon: Icons.location_city,
        ),
      if (widget.tutorial.district?.isNotEmpty == true)
        _buildDetailField(
          label: 'DISTRICT',
          value: _processTextField(widget.tutorial.district!),
          icon: Icons.location_on,
        ),
      if (widget.tutorial.street?.isNotEmpty == true)
        _buildDetailField(
          label: 'STREET',
          value: _processTextField(widget.tutorial.street!),
          icon: Icons.add_road,
        ),
      if (widget.tutorial.addressLine1?.isNotEmpty == true)
        _buildDetailField(
          label: 'ADDRESS LINE 1',
          value: _processTextField(widget.tutorial.addressLine1!),
          icon: Icons.location_on,
        ),
      if (widget.tutorial.addressLine2?.isNotEmpty == true)
        _buildDetailField(
          label: 'ADDRESS LINE 2',
          value: _processTextField(widget.tutorial.addressLine2!),
          icon: Icons.location_on_outlined,
        ),
    
      if (widget.tutorial.zipCode?.isNotEmpty == true)
        _buildDetailField(
          label: 'ZIP CODE',
          value: _processTextField(widget.tutorial.zipCode!),
          icon: Icons.local_post_office,
        ),
      
      const SizedBox(height: 24),
    ];
  }

  Widget _buildDetailField({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryBlueShade(50),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppColors.primaryBlueShade(700),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          // Label and Value
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.isNotEmpty ? value : 'Not provided',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: value.isNotEmpty ? Colors.grey.shade800 : Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),
          // Copy button
          if (value.isNotEmpty)
            IconButton(
              onPressed: () => _copyToClipboard(value, label),
              icon: Icon(
                Icons.copy,
                color: AppColors.primaryBlueShade(700),
                size: 20,
              ),
              tooltip: 'Copy $label',
            ),
        ],
      ),
    );
  }
} 