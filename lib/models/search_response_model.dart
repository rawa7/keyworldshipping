import 'transport_model.dart';
import 'item_model.dart';

class SearchResponseModel {
  final int searchStatus;
  final TransportModel? transport;
  final ItemModel? item;
  final String? message;

  SearchResponseModel({
    required this.searchStatus,
    this.transport,
    this.item,
    this.message,
  });

  factory SearchResponseModel.fromJson(Map<String, dynamic> json) {
    return SearchResponseModel(
      searchStatus: json['search_status'] is int ? json['search_status'] : int.parse(json['search_status'].toString()),
      transport: json['transport'] != null 
          ? TransportModel.fromJson(json['transport'] as Map<String, dynamic>)
          : null,
      item: json['item'] != null 
          ? ItemModel.fromJson(json['item'] as Map<String, dynamic>)
          : null,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'search_status': searchStatus,
      'transport': transport?.toJson(),
      'item': item?.toJson(),
      'message': message,
    };
  }

  bool get isTransportOnly => searchStatus == 1;
  bool get isTransportWithItem => searchStatus == 2;
  bool get isNotFound => searchStatus == 0;
} 