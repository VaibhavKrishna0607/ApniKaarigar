import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  final Uuid _uuid = const Uuid();

  // Pick image from gallery
  Future<XFile?> pickImageFromGallery() async {
    return _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1080,
      maxHeight: 1080,
      imageQuality: 85,
    );
  }

  // Pick image from camera
  Future<XFile?> pickImageFromCamera() async {
    return _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1080,
      maxHeight: 1080,
      imageQuality: 85,
    );
  }

  // Pick multiple images
  Future<List<XFile>> pickMultipleImages() async {
    return _picker.pickMultiImage(
      maxWidth: 1080,
      maxHeight: 1080,
      imageQuality: 85,
    );
  }

  // Upload product image (web-compatible via bytes)
  Future<String> uploadProductImage({
    required XFile imageFile,
    required String artisanId,
    required String productId,
  }) async {
    final String fileName = '${_uuid.v4()}.jpg';
    final Reference ref = _storage
        .ref()
        .child('artisans')
        .child(artisanId)
        .child('products')
        .child(productId)
        .child(fileName);

    final bytes = await imageFile.readAsBytes();
    try {
      final UploadTask uploadTask = ref.putData(
        bytes,
        SettableMetadata(contentType: 'image/jpeg'),
      );
      final TaskSnapshot snapshot = await uploadTask;
      return snapshot.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      if (kIsWeb && (e.code == 'unknown' || e.code == 'network-request-failed')) {
        throw Exception(
          'Image upload blocked by CORS policy.\n\n'
          'To fix: run  firebase deploy --only hosting  then test on the live URL.\n'
          'Or configure Storage CORS via Google Cloud Console (see README).'
        );
      }
      rethrow;
    }
  }

  // Upload multiple product images
  Future<List<String>> uploadProductImages({
    required List<XFile> imageFiles,
    required String artisanId,
    required String productId,
  }) async {
    final List<String> urls = [];
    for (final file in imageFiles) {
      final url = await uploadProductImage(
        imageFile: file,
        artisanId: artisanId,
        productId: productId,
      );
      urls.add(url);
    }
    return urls;
  }

  // Upload profile image
  Future<String> uploadProfileImage({
    required XFile imageFile,
    required String artisanId,
  }) async {
    final Reference ref = _storage
        .ref()
        .child('artisans')
        .child(artisanId)
        .child('profile.jpg');

    final bytes = await imageFile.readAsBytes();
    try {
      final UploadTask uploadTask = ref.putData(
        bytes,
        SettableMetadata(contentType: 'image/jpeg'),
      );
      final TaskSnapshot snapshot = await uploadTask;
      return snapshot.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      if (kIsWeb && (e.code == 'unknown' || e.code == 'network-request-failed')) {
        throw Exception(
          'Image upload blocked by CORS policy. Deploy to Firebase Hosting to enable uploads.'
        );
      }
      rethrow;
    }
  }

  // Delete image
  Future<void> deleteImage(String imageUrl) async {
    try {
      final Reference ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      // Image might already be deleted
    }
  }

  // Delete all product images
  Future<void> deleteProductImages({
    required String artisanId,
    required String productId,
  }) async {
    try {
      final Reference ref = _storage
          .ref()
          .child('artisans')
          .child(artisanId)
          .child('products')
          .child(productId);

      final ListResult result = await ref.listAll();
      for (final item in result.items) {
        await item.delete();
      }
    } catch (e) {
      // ignore
    }
  }
}
