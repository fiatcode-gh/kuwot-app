import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:kuwot/core/error/exception.dart';

/// Network interface
abstract class Network {
  /// Get data from uri
  Future<String> get(Uri uri, {Map<String, String>? headers});

  /// Post data to uri
  Future<String> post(Uri uri, {Map<String, String>? headers, Object? body});
}

/// Network implementation
class NetworkImpl implements Network {
  final _client = http.Client();

  @override
  Future<String> get(Uri uri, {Map<String, String>? headers}) async {
    if (kDebugMode) {
      print('GET: $uri, headers: $headers');
    }
    final response = await _client.get(uri, headers: headers);
    final stringResponse = utf8.decode(response.bodyBytes);

    if (response.statusCode == HttpStatus.unauthorized) {
      throw UnauthorizedException(stringResponse);
    }

    if (response.statusCode != HttpStatus.ok) {
      throw ServerException(stringResponse);
    }

    return stringResponse;
  }

  @override
  Future<String> post(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    if (kDebugMode) {
      print('POST: $uri, headers: $headers, body: $body');
    }
    final response = await _client.post(uri, headers: headers, body: body);
    return utf8.decode(response.bodyBytes);
  }
}
