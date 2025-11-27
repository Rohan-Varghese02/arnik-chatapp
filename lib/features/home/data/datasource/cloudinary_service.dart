import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

class CloudinaryService {
  static const String cloudinaryApiKey = '983528927447469';
  static const String cloudinaryApiSecret = 'lHeJAJqfNMSEjZrp7eHU1hSyu9I';
  static const String cloudinaryCloudName = 'dvmrt0wfv';

  static Future<String> uploadImage(String imagePath) async {
    try {
      final imageFile = File(imagePath);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final publicId = 'chat_app/$timestamp';

      final uri = Uri.parse(
        'https://api.cloudinary.com/v1_1/$cloudinaryCloudName/image/upload',
      );

      final request = http.MultipartRequest('POST', uri)
        ..fields['api_key'] = cloudinaryApiKey
        ..fields['timestamp'] = timestamp.toString()
        ..fields['public_id'] = publicId
        ..files.add(
          await http.MultipartFile.fromPath('file', imageFile.path),
        );

      final signature = _generateSignature(
        timestamp.toString(),
        publicId,
      );
      request.fields['signature'] = signature;

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse['secure_url'] as String;
      } else {
        throw ServerException('Failed to upload image: ${response.body}');
      }
    } catch (e) {
      throw ServerException('Error uploading image: $e');
    }
  }

  static String _generateSignature(String timestamp, String publicId) {
    final String signString = 'public_id=$publicId&timestamp=$timestamp$cloudinaryApiSecret';
    final bytes = utf8.encode(signString);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }
}

class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

