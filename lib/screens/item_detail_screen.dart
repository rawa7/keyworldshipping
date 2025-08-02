import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';
import '../models/transport_model.dart';
import '../models/item_model.dart';
import '../utils/app_localizations.dart';
import '../utils/app_colors.dart';

class ItemDetailScreen extends StatefulWidget {
  final TransportModel transport;
  final ItemModel item;

  const ItemDetailScreen({
    Key? key,
    required this.transport,
    required this.item,
  }) : super(key: key);

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  Timer? _timer;
  Duration? _remainingTime;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _calculateRemainingTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _calculateRemainingTime();
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _calculateRemainingTime() {
    try {
      final arrivalDate = DateTime.parse(widget.transport.arrivalDate);
      final now = DateTime.now();
      
      if (arrivalDate.isAfter(now)) {
        _remainingTime = arrivalDate.difference(now);
      } else {
        _remainingTime = Duration.zero;
        _timer?.cancel();
      }
    } catch (e) {
      _remainingTime = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('${localizations.itemDetails ?? "Item Details"} - ${widget.item.code}'),
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Item Image
              _buildItemImage(localizations),
              const SizedBox(height: 16),
              
              // Transport Animation (show animation based on transport type)
              _buildTransportAnimation(),
              const SizedBox(height: 16),
              
              // Countdown Timer
              _buildCountdownTimer(),
              const SizedBox(height: 16),
              
              // Item Information Card
              _buildItemInformationCard(localizations),
              const SizedBox(height: 16),
              
              // Transport Information Card
              _buildTransportInformationCard(localizations),
              const SizedBox(height: 16),
              
              // Transport Status Card
              _buildTransportStatusCard(localizations),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemImage(AppLocalizations localizations) {
    // Check if image is already a full URL or just a filename
    String imageUrl;
    if (widget.item.image.startsWith('http://') || widget.item.image.startsWith('https://')) {
      // Image field contains full URL
      imageUrl = widget.item.image;
    } else {
      // Image field contains just filename, construct full URL
      imageUrl = 'https://keyworldcargo.com/api/item_images/${widget.item.image}';
    }
    
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: widget.item.image.isNotEmpty
            ? GestureDetector(
                onTap: () => _showFullScreenImage(context, imageUrl),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[200],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inventory,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              localizations.itemImage,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              localizations.failedToLoad,
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Overlay icon to indicate image is tappable
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.fullscreen,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Container(
                color: Colors.grey[200],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inventory,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      localizations.noImageAvailable,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Stack(
            children: [
              // Full screen image with zoom and pan
              InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Center(
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: double.infinity,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                    errorWidget: (context, url, error) => const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.white,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Failed to load image',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Close button
              Positioned(
                top: MediaQuery.of(context).padding.top + 10,
                right: 20,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
              // Item code label
              Positioned(
                top: MediaQuery.of(context).padding.top + 10,
                left: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    widget.item.code,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTransportAnimation() {
    String animationAsset;
    String animationDescription;
    String animationSubtitle;
    IconData fallbackIcon;

    final transportType = widget.transport.transportType.toLowerCase().trim();
    
    // Check for air transport variations
    if (transportType.contains('air') || 
        transportType.contains('plane') || 
        transportType.contains('airplane') ||
        transportType.contains('flight')) {
      animationAsset = 'assets/airplane.json';
      animationDescription = 'Air Transport';
      animationSubtitle = 'Fast & Secure Delivery';
      fallbackIcon = Icons.airplanemode_active;
    }
    // Check for sea/ship transport variations
    else if (transportType.contains('ship') || 
             transportType.contains('sea') || 
             transportType.contains('ocean') ||
             transportType.contains('marine') ||
             transportType.contains('cargo')) {
      animationAsset = 'assets/shipment.json';
      animationDescription = 'Ship Transport';
      animationSubtitle = 'Ocean Freight Service';
      fallbackIcon = Icons.directions_boat;
    }
    // Check for train transport variations
    else if (transportType.contains('train') || 
             transportType.contains('rail') ||
             transportType.contains('railway')) {
      animationAsset = 'assets/landtransport.json';
      animationDescription = 'Train Transport';
      animationSubtitle = 'Rail Freight Service';
      fallbackIcon = Icons.train;
    }
    // Default to land transport (truck, land, etc.)
    else {
      animationAsset = 'assets/landtransport.json';
      animationDescription = 'Land Transport';
      animationSubtitle = 'Ground Freight Service';
      fallbackIcon = Icons.local_shipping;
    }

    return Container(
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF4A90E2), // Beautiful bright blue
            const Color(0xFF357ABD), // Deeper blue
            const Color(0xFF2E5A87), // Even deeper blue for depth
          ],
          stops: const [0.0, 0.6, 1.0],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF357ABD),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A90E2).withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 80,
              width: 80,
              child: Lottie.asset(
                animationAsset,
                animate: true,
                repeat: true,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback to appropriate icon if Lottie file not found
                  return Icon(
                    fallbackIcon,
                    size: 60,
                    color: Colors.white,
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  animationDescription,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  animationSubtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountdownTimer() {
    if (_remainingTime == null) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.grey.withOpacity(0.1),
              Colors.grey.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
        ),
        child: const Center(
          child: Text(
            'Invalid delivery date',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    if (_remainingTime == Duration.zero) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.green.withOpacity(0.15),
              Colors.green.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.green.withOpacity(0.3)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 24),
            SizedBox(width: 8),
            Text(
              'Delivered!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      );
    }

    final days = _remainingTime!.inDays;
    final hours = _remainingTime!.inHours % 24;
    final minutes = _remainingTime!.inMinutes % 60;
    final seconds = _remainingTime!.inSeconds % 60;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.orange.withOpacity(0.15),
            Colors.orange.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.timer, color: Colors.orange[700], size: 24),
              const SizedBox(width: 8),
              Text(
                'Estimated Delivery',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTimeUnit(days.toString().padLeft(2, '0'), 'DAYS'),
              _buildTimeSeparator(),
              _buildTimeUnit(hours.toString().padLeft(2, '0'), 'HOURS'),
              _buildTimeSeparator(),
              _buildTimeUnit(minutes.toString().padLeft(2, '0'), 'MIN'),
              _buildTimeSeparator(),
              _buildTimeUnit(seconds.toString().padLeft(2, '0'), 'SEC'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeUnit(String value, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSeparator() {
    return Text(
      ':',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.orange[700],
      ),
    );
  }

  Widget _buildItemInformationCard(AppLocalizations localizations) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.inventory_2,
                color: AppColors.primaryBlue,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                localizations.itemInformation ?? 'Item Information',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow('${localizations.itemCode}:', widget.item.code, Icons.qr_code),
          _buildInfoRow('${localizations.quantity}:', '${widget.item.quantity}', Icons.format_list_numbered),
          _buildInfoRow('${localizations.weight}:', '${widget.item.weight} ${localizations.kg}', Icons.scale),
          _buildInfoRow('${localizations.volume}:', '${widget.item.volume} m³', Icons.straighten),
        ],
      ),
    );
  }

  Widget _buildTransportInformationCard(AppLocalizations localizations) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getTransportIcon(),
                color: Colors.orange,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                localizations.transportInformation ?? 'Transport Information',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow('${localizations.transportCode}:', widget.transport.transportCode, Icons.local_shipping),
          _buildInfoRow('${localizations.transportType}:', widget.transport.transportType, Icons.category),
          _buildInfoRow('${localizations.destination}:', widget.transport.cityName, Icons.location_on),
          _buildInfoRow('${localizations.startDate}:', _formatDate(widget.transport.startDate), Icons.flight_takeoff),
          _buildInfoRow('${localizations.arrivalDate}:', _formatDate(widget.transport.arrivalDate), Icons.flight_land),
        ],
      ),
    );
  }

  Widget _buildTransportStatusCard(AppLocalizations localizations) {
    Color statusColor = _getStatusColor();
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: statusColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                localizations.status ?? 'Status',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: statusColor.withOpacity(0.3)),
            ),
            child: Text(
              widget.transport.statusName,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getTransportIcon() {
    final transportType = widget.transport.transportType.toLowerCase().trim();
    
    // Check for air transport variations
    if (transportType.contains('air') || 
        transportType.contains('plane') || 
        transportType.contains('airplane') ||
        transportType.contains('flight')) {
      return Icons.airplanemode_active;
    }
    // Check for sea/ship transport variations
    else if (transportType.contains('ship') || 
             transportType.contains('sea') || 
             transportType.contains('ocean') ||
             transportType.contains('marine') ||
             transportType.contains('cargo')) {
      return Icons.directions_boat;
    }
    // Check for train transport variations
    else if (transportType.contains('train') || 
             transportType.contains('rail') ||
             transportType.contains('railway')) {
      return Icons.train;
    }
    // Default to land transport (truck, land, etc.)
    else {
      return Icons.local_shipping;
    }
  }

  Color _getStatusColor() {
    switch (widget.transport.statusName.toLowerCase()) {
      case 'delivered':
      case 'completed':
        return Colors.green;
      case 'in transit':
      case 'shipping':
        return AppColors.primaryBlue;
      case 'pending':
      case 'waiting':
        return Colors.orange;
      case 'cancelled':
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
} 