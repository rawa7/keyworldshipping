import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/app_model.dart';

class AppGridWidget extends StatelessWidget {
  final List<AppModel> apps;
  final Function(AppModel) onAppTap;

  const AppGridWidget({
    Key? key,
    required this.apps,
    required this.onAppTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: apps.map((app) => _buildAppItem(app)).toList(),
    );
  }

  Widget _buildAppItem(AppModel app) {
    return InkWell(
      onTap: () => onAppTap(app),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CachedNetworkImage(
              imageUrl: app.getIconUrl(),
              width: 36,
              height: 36,
              fit: BoxFit.contain,
              placeholder: (context, url) => const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
              errorWidget: (context, url, error) => const Icon(
                Icons.error,
                size: 24,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              app.name,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
} 