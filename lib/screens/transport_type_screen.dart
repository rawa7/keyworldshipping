import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../models/transport_model.dart';
import '../services/transport_service.dart';
import 'transport_detail_screen.dart';

class TransportTypeScreen extends StatefulWidget {
  final String transportType;
  
  const TransportTypeScreen({Key? key, required this.transportType}) : super(key: key);

  @override
  State<TransportTypeScreen> createState() => _TransportTypeScreenState();
}

class _TransportTypeScreenState extends State<TransportTypeScreen> {
  final TransportService _transportService = TransportService();
  final TextEditingController _searchController = TextEditingController();
  List<TransportModel> _transports = [];
  List<TransportModel> _filteredTransports = [];
  bool _isLoading = true;
  bool _isSearching = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchTransports();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchTransports() async {
    try {
      final allTransports = await _transportService.fetchTransports();
      final typeTransports = allTransports.where((transport) => 
        transport.transportType.toLowerCase() == widget.transportType.toLowerCase()
      ).toList();
      
      setState(() {
        _transports = typeTransports;
        _filteredTransports = typeTransports;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _searchTransport(String code) async {
    if (code.isEmpty) {
      setState(() {
        _filteredTransports = _transports;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      // Filter locally first
      final results = _transports.where((transport) => 
        transport.transportCode.toLowerCase().contains(code.toLowerCase())
      ).toList();

      setState(() {
        _filteredTransports = results;
        _isSearching = false;
      });

      // If no results found locally, try API search
      if (results.isEmpty) {
        try {
          final transport = await _transportService.getTransportByCode(code);
          // Only include if it matches the current transport type
          if (transport.transportType.toLowerCase() == widget.transportType.toLowerCase()) {
            setState(() {
              _filteredTransports = [transport];
            });
          }
        } catch (e) {
          // Just keep empty results
        }
      }
    } catch (e) {
      setState(() {
        _isSearching = false;
      });
    }
  }

  Widget _buildTableHeader() {
    return Container(
      color: Colors.blue,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: const Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'Truck Code',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'From',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Status',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(TransportModel transport) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransportDetailScreen(transport: transport),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                transport.transportCode,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                transport.cityName,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                transport.statusName,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransportTable() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'SHIPMENT DETAILS',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          _buildTableHeader(),
          ..._filteredTransports.map((transport) => _buildTableRow(transport)).toList(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'ENTER YOUR TRUCK CODE HERE...',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              onChanged: (value) {
                setState(() {
                  // Update suggestions as user types
                  if (value.isEmpty) {
                    _filteredTransports = _transports;
                  }
                });
              },
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextButton(
              onPressed: () {
                _searchTransport(_searchController.text);
              },
              child: const Text(
                'SEARCH',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Get Lottie animation based on transport type
  Widget _buildHeaderAnimation() {
    String lottieAsset;
    String title = 'LIST OF SHIPMENTS ARRIVING BY ${widget.transportType.toUpperCase()}';
    
    switch (widget.transportType.toLowerCase()) {
      case 'airplane':
        lottieAsset = 'assets/airplane.json';
        break;
      case 'ship':
      case 'shipment':
        lottieAsset = 'assets/shipment.json';
        break;
      case 'train':
        lottieAsset = 'assets/landtransport.json';
        break;
      case 'truck':
      case 'land transport':
      default:
        lottieAsset = 'assets/landtransport.json';
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      width: double.infinity,
      color: Colors.blue,
      child: Column(
        children: [
          SizedBox(
            height: 120,
            child: Lottie.asset(
              lottieAsset,
              animate: true,
              repeat: true,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                // Fallback to icon if Lottie file not found
                return Icon(
                  _getIconForTransportType(),
                  size: 80,
                  color: Colors.white,
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  IconData _getIconForTransportType() {
    switch (widget.transportType.toLowerCase()) {
      case 'airplane':
        return Icons.airplanemode_active;
      case 'ship':
      case 'shipment':
        return Icons.directions_boat;
      case 'train':
        return Icons.train;
      case 'truck':
      case 'land transport':
      default:
        return Icons.local_shipping;
    }
  }

  Widget _buildContent() {
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
              'Failed to load transports',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 14,
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
                _fetchTransports();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_transports.isEmpty) {
      return Column(
        children: [
          _buildHeaderAnimation(),
          const Expanded(
            child: Center(
              child: Text(
                'No shipments found for this transport type',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        _buildHeaderAnimation(),
        _buildSearchBar(),
        Expanded(
          child: _filteredTransports.isEmpty
              ? Center(
                  child: Text(
                    'No shipments found for "${_searchController.text}"',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: _buildTransportTable(),
                ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: _buildContent(),
    );
  }
} 