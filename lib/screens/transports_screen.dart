import 'package:flutter/material.dart';
import '../models/transport_model.dart';
import '../services/transport_service.dart';
import '../utils/app_localizations.dart';
import 'transport_detail_screen.dart';
import 'transport_type_screen.dart';

class TransportsScreen extends StatefulWidget {
  const TransportsScreen({Key? key}) : super(key: key);

  @override
  State<TransportsScreen> createState() => _TransportsScreenState();
}

class _TransportsScreenState extends State<TransportsScreen> {
  final TransportService _transportService = TransportService();
  final TextEditingController _searchController = TextEditingController();
  List<TransportModel> _transports = [];
  List<TransportModel> _filteredTransports = [];
  bool _isLoading = true;
  bool _isSearching = false;
  String? _errorMessage;
  TransportModel? _searchResult;

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
      final transports = await _transportService.fetchTransports();
      setState(() {
        _transports = transports;
        _filteredTransports = transports;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _searchTransport(String transportCode) async {
    if (transportCode.isEmpty) {
      setState(() {
        _filteredTransports = _transports;
        _isSearching = false;
        _searchResult = null;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      final transport = await _transportService.getTransportByCode(transportCode);
      setState(() {
        _searchResult = transport;
        // Also navigate to the details screen
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TransportDetailScreen(transport: transport),
            ),
          );
        });
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _searchResult = null;
        _isSearching = false;
        // Show a snackbar with the error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Transport not found: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      });
    }
  }

  void _filterTransports(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredTransports = _transports;
      } else {
        _filteredTransports = _transports.where((transport) {
          return transport.transportCode.toLowerCase().contains(query.toLowerCase()) ||
              transport.statusName.toLowerCase().contains(query.toLowerCase()) ||
              transport.cityName.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  List<TransportModel> _getTransportsByType(String transportType) {
    return _filteredTransports.where((transport) => 
      transport.transportType.toLowerCase() == transportType.toLowerCase()
    ).toList();
  }

  // Get all unique transport types from the data
  Set<String> _getAllTransportTypes() {
    return _filteredTransports.map((transport) => transport.transportType).toSet();
  }

  Widget _buildTableHeader() {
    final localizations = AppLocalizations.of(context);
    
    return Container(
      color: Colors.blue,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'Code',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              localizations.status ?? 'Status',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'No',
              style: const TextStyle(
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
                transport.statusName,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                transport.getItemCount().toString(),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransportTable(List<TransportModel> transports, String title) {
    final localizations = AppLocalizations.of(context);
    
    // Get the last 4 items (or fewer if less available)
    final displayTransports = transports.length > 4 
        ? transports.sublist(transports.length - 4) 
        : transports;
    
    // Extract the transport type from the title (e.g., "AIRPLANE" from "LIST OF SHIPMENTS ARRIVING BY AIRPLANE")
    final String transportType = title.contains("BY") 
        ? title.split("BY").last.trim() 
        : title;
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Column(
            children: [
              _buildTableHeader(),
              ...displayTransports.map((transport) => _buildTableRow(transport)).toList(),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TransportTypeScreen(
                            transportType: transports.first.transportType,
                          ),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      minimumSize: const Size(100, 32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.visibility, color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          localizations.viewDetails,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    final localizations = AppLocalizations.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: _isSearching
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                if (!_isSearching) {
                  _searchTransport(_searchController.text);
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: localizations.enterTruckNumber ?? 'ENTER TRUCK NUMBER...',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                          _filterTransports('');
                        },
                      )
                    : null,
              ),
              onSubmitted: (value) {
                _searchTransport(value);
              },
              onChanged: (value) {
                // Local filtering as user types
                _filterTransports(value);
                
                // Clear the search result if the field is empty
                if (value.isEmpty) {
                  setState(() {
                    _searchResult = null;
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final localizations = AppLocalizations.of(context);
    
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
              localizations.noData,
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
              child: Text(localizations.retry),
            ),
          ],
        ),
      );
    }

    if (_transports.isEmpty) {
      return Center(
        child: Text(
          localizations.noData,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      );
    }

    // Get all transport types and generate tables for each
    final transportTypes = _getAllTransportTypes();
    final tables = <Widget>[];
    
    for (final type in transportTypes) {
      final transports = _getTransportsByType(type);
      if (transports.isNotEmpty) {
        tables.add(
          _buildTransportTable(
            transports,
            '${localizations.transports} ${type.toUpperCase()}',
          ),
        );
      }
    }

    return Column(
      children: [
        _buildSearchBar(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: tables,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.transports),
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
              Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: _buildContent(),
      ),
    );
  }
} 