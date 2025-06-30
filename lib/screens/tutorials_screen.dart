import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/app_model.dart';
import '../models/tutorial_model.dart';
import '../services/tutorial_service.dart';
import '../utils/app_localizations.dart';
import '../utils/app_colors.dart';
import '../utils/language_provider.dart';
import 'tutorial_detail_screen.dart';

class TutorialsScreen extends StatefulWidget {
  final AppModel app;

  const TutorialsScreen({Key? key, required this.app}) : super(key: key);

  @override
  State<TutorialsScreen> createState() => _TutorialsScreenState();
}

class _TutorialsScreenState extends State<TutorialsScreen> {
  final TutorialService _tutorialService = TutorialService();
  List<TutorialModel> _tutorials = [];
  bool _isLoading = true;
  String? _errorMessage;
  String? _currentLanguageCode;

  @override
  void initState() {
    super.initState();
    _fetchTutorials();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Check if language has changed
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final newLanguageCode = languageProvider.currentLanguage.code;
    
    if (_currentLanguageCode != null && _currentLanguageCode != newLanguageCode) {
      print('🌐 Language changed from $_currentLanguageCode to $newLanguageCode, refetching tutorials');
      _fetchTutorials();
    }
    
    _currentLanguageCode = newLanguageCode;
  }

  Future<void> _fetchTutorials() async {
    try {
      print('🚀 Fetching tutorials for app: ${widget.app.id} (${widget.app.name})');
      
      // Get current language from provider
      final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
      final currentLanguageCode = languageProvider.currentLanguage.code;
      
      print('🌐 Current language: $currentLanguageCode');
      
      final tutorials = await _tutorialService.fetchTutorials(
        widget.app.id, 
        languageCode: currentLanguageCode
      );
      print('✅ Successfully fetched ${tutorials.length} tutorials for language: $currentLanguageCode');
      
      setState(() {
        _tutorials = tutorials;
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Error fetching tutorials: $e');
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('${widget.app.name} ${localizations.tutorials}'),
            backgroundColor: AppColors.primaryBlue,
            foregroundColor: Colors.white,
          ),
          body: _buildBody(),
        );
      },
    );
  }

  Widget _buildBody() {
    final localizations = AppLocalizations.of(context);
    
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
                'Error Loading Tutorials',
              style: TextStyle(
                color: Colors.grey[700],
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'App: ${widget.app.name} (ID: ${widget.app.id})',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
              ),
                textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
              Text(
                _errorMessage!,
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
                          ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _errorMessage = null;
                  });
                  _fetchTutorials();
                },
                child: Text(localizations.retry),
              ),
          ],
          ),
        ),
      );
    }

    if (_tutorials.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.video_library_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No Tutorials Available',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'No tutorials found for ${widget.app.name}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'App ID: ${widget.app.id}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                  });
                  _fetchTutorials();
                },
                child: Text(localizations.retry),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _tutorials.length,
      itemBuilder: (context, index) {
        final tutorial = _tutorials[index];
        return _buildTutorialCard(tutorial);
      },
    );
  }

  Widget _buildTutorialCard(TutorialModel tutorial) {
    final localizations = AppLocalizations.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TutorialDetailScreen(tutorial: tutorial),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              child: SizedBox(
                height: 150,
                width: double.infinity,
                child: _buildCoverImage(tutorial),
              ),
            ),
            
            // Title and description
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tutorial.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (tutorial.note.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      tutorial.note,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.play_circle_outline,
                        color: AppColors.primaryBlueShade(700),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        localizations.watchVideo,
                        style: TextStyle(
                          color: AppColors.primaryBlueShade(700),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoverImage(TutorialModel tutorial) {
    final coverUrl = tutorial.getCoverImageUrl();
    return coverUrl.isNotEmpty
        ? CachedNetworkImage(
            imageUrl: coverUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Colors.grey[300],
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey[300],
              child: const Center(
                child: Icon(Icons.error),
              ),
            ),
          )
        : Container(
            color: Colors.grey[300],
            child: const Center(
              child: Icon(
                Icons.play_circle_filled,
                size: 48,
                color: Colors.grey,
              ),
            ),
          );
  }

} 