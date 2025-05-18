class TutorialModel {
  final String id;
  final String title;
  final String videoUrl;
  final String note;
  final String coverimg;
  final String image;

  TutorialModel({
    required this.id,
    required this.title,
    required this.videoUrl,
    required this.note,
    required this.coverimg,
    required this.image,
  });

  factory TutorialModel.fromJson(Map<String, dynamic> json) {
    return TutorialModel(
      id: json['id'] as String,
      title: json['title'] as String,
      videoUrl: json['video_url'] as String,
      note: json['note'] as String,
      coverimg: json['coverimg'] as String,
      image: json['image'] as String,
    );
  }

  String getYoutubeVideoId() {
    // Extract YouTube video ID from URL
    RegExp regExp = RegExp(
      r'.*(?:youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=)([^#\&\?]*).*',
      caseSensitive: false,
      multiLine: false,
    );
    if (videoUrl.isNotEmpty) {
      final match = regExp.firstMatch(videoUrl);
      if (match != null && match.groupCount >= 1) {
        return match.group(1)!;
      }
    }
    return '';
  }

  String getCoverImageUrl() {
    if (image.isNotEmpty && image != 'https://keyworldcargo.com/') {
      // Fix double slashes in URL
      String cleanUrl = image.replaceAll(r'\\', '');
      cleanUrl = cleanUrl.replaceAll('//', '/');
      if (cleanUrl.startsWith('https:/')) {
        cleanUrl = 'https://' + cleanUrl.substring(7);
      }
      return cleanUrl;
    }
    return '';
  }
} 