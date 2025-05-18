import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/app_model.dart';
import '../models/tutorial_model.dart';
import '../services/tutorial_service.dart';
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

  @override
  void initState() {
    super.initState();
    _fetchTutorials();
  }

  Future<void> _fetchTutorials() async {
    try {
      final tutorials = await _tutorialService.fetchTutorials(widget.app.id);
      setState(() {
        _tutorials = tutorials;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.app.name} Tutorials'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              'Failed to load tutorials',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _errorMessage = null;
                });
                _fetchTutorials();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_tutorials.isEmpty) {
      return Center(
        child: Text(
          'No tutorials available for ${widget.app.name}',
          style: const TextStyle(fontSize: 16),
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
                        color: Colors.red[700],
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Watch Tutorial',
                        style: TextStyle(
                          color: Colors.blue[700],
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