import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
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
  final AuthService _authService = AuthService();
  UserModel? _currentUser;
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _isVideoInitialized = false;
  bool _isLoading = false;
  String? _videoError;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _initializeVideoPlayer();
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

  bool _isValidVideoUrl(String url) {
    // Check if the URL is actually pointing to a video file
    final videoExtensions = ['.mp4', '.mov', '.avi', '.mkv', '.webm', '.m4v', '.3gp'];
    final lowerUrl = url.toLowerCase();
    
    // Check for common image extensions that should not be treated as videos
    final imageExtensions = ['.png', '.jpg', '.jpeg', '.gif', '.webp', '.bmp'];
    for (final ext in imageExtensions) {
      if (lowerUrl.endsWith(ext)) {
        return false;
      }
    }
    
    // Check for video extensions or YouTube/streaming URLs
    return videoExtensions.any((ext) => lowerUrl.contains(ext)) || 
           lowerUrl.contains('youtube') || 
           lowerUrl.contains('youtu.be') || 
           lowerUrl.contains('vimeo') ||
           (!imageExtensions.any((ext) => lowerUrl.contains(ext)));
  }

  Future<void> _initializeVideoPlayer() async {
    try {
      final videoUrl = widget.tutorial.videoUrl;
      if (videoUrl.isEmpty) {
        setState(() {
          _videoError = 'Video URL not available';
        });
        return;
      }

      // Validate if URL is actually a video
      if (!_isValidVideoUrl(videoUrl)) {
        setState(() {
          _videoError = 'URL points to an image file, not a video. Please contact support to fix this tutorial.';
        });
        return;
      }

      print('🎥 Initializing Chewie Player for URL: $videoUrl');
      
      setState(() {
        _isLoading = true;
      });
      
      // Create video player controller
      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(videoUrl),
        httpHeaders: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        },
      );
      
      // Initialize video player
      await _videoController!.initialize();
      
      // Create Chewie controller with custom configuration
      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: false,
        looping: false,
        aspectRatio: _videoController!.value.aspectRatio,
        allowFullScreen: true,
        allowMuting: true,
        allowPlaybackSpeedChanging: false,
        showControls: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.red,
          handleColor: Colors.red,
          backgroundColor: Colors.white24,
          bufferedColor: Colors.white60,
        ),
        placeholder: Container(
          color: Colors.black,
          child: const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
        autoInitialize: true,
      );
      
      if (mounted) {
        setState(() {
          _isVideoInitialized = true;
          _videoError = null;
          _isLoading = false;
        });
      }
      
    } catch (e) {
      print('❌ Error initializing Chewie Player: $e');
      if (mounted) {
        setState(() {
          _videoError = 'Failed to load video: ${e.toString()}';
          _isVideoInitialized = false;
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Video Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }





  @override
  void dispose() {
    _chewieController?.dispose();
    _videoController?.dispose();
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
    if (_videoError != null) {
      return _buildErrorState();
    }
    
    if (_chewieController == null || !_isVideoInitialized) {
      return _buildLoadingState();
    }

    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Chewie(
          controller: _chewieController!,
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            SizedBox(height: 16),
            Text(
              'Loading video...',
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


  Widget _buildErrorState() {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 48,
            ),
            const SizedBox(height: 8),
            const Text(
              'Video Not Available',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (_videoError != null) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  _videoError!,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _videoError = null;
                  _isVideoInitialized = false;
                });
                _initializeVideoPlayer();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
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