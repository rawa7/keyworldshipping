import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/tutorial_model.dart';
import '../utils/url_launcher_helper.dart';

class TutorialDetailScreen extends StatefulWidget {
  final TutorialModel tutorial;

  const TutorialDetailScreen({Key? key, required this.tutorial}) : super(key: key);

  @override
  State<TutorialDetailScreen> createState() => _TutorialDetailScreenState();
}

class _TutorialDetailScreenState extends State<TutorialDetailScreen> {
  late YoutubePlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Set preferred orientations to portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _initializePlayer();
  }

  void _initializePlayer() {
    final videoId = widget.tutorial.getYoutubeVideoId();
    if (videoId.isNotEmpty) {
      _controller = YoutubePlayerController.fromVideoId(
        videoId: videoId,
        autoPlay: false,
        params: const YoutubePlayerParams(),
      );
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    // Reset orientation settings
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    
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
        title: Text(widget.tutorial.title),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Cover image
              _buildCoverImage(),
              
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
              
              const SizedBox(height: 16),
              
              // Video player
              _buildVideoPlayer(),
              
              const SizedBox(height: 24),
              
              // Description
              if (widget.tutorial.note.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.tutorial.note,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              
              const SizedBox(height: 32),
              
              // Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 64),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Back to Tutorials'),
                ),
              ),
              
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoverImage() {
    final coverUrl = widget.tutorial.getCoverImageUrl();
    return Container(
      height: 200,
      color: Colors.grey[300],
      child: coverUrl.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: coverUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => const Center(
                child: Text('Cover Image'),
              ),
            )
          : const Center(
              child: Text(
                'Cover Image',
                style: TextStyle(color: Colors.black54, fontSize: 18),
              ),
            ),
    );
  }

  Widget _buildVideoPlayer() {
    if (!_isInitialized) {
      return Container(
        height: 200,
        color: Colors.black,
        child: const Center(
          child: Text(
            'Video Not Available',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return Column(
      children: [
        YoutubePlayer(
          controller: _controller,
          aspectRatio: 16 / 9,
        ),
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: () {
            UrlLauncherHelper.launchYoutubeVideo(widget.tutorial.videoUrl, context);
          },
          icon: const Icon(Icons.open_in_browser, color: Colors.red),
          label: const Text('Open in YouTube app', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
} 