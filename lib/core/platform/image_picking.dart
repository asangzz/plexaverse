
import 'dart:convert' show base64Encode;
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'image_picking.g.dart';

/// Outcome of asking the user for a photo, mapped off `image_picker` so
/// feature code never imports the plugin or its `PlatformException`s directly
/// — the same seam the LinkedIn OAuth hand-off uses (`core/platform/web_auth`).
///
/// Three shapes, because the caller has to tell them apart:
///   - [PickedImage] — bytes plus a filename, ready to POST to /upload/image.
///   - [ImagePickCancelled] — the user backed out. NOT an error, and it must
///     never raise a banner; a dismissed picker is a decision, not a failure.
///   - [ImagePickFailure] — denied permission, or no picker at all.
sealed class ImagePickResult {
  const ImagePickResult();
}

class PickedImage extends ImagePickResult {
  const PickedImage({required this.bytes, required this.name});

  final Uint8List bytes;

  /// The original filename, used for the upload's content type.
  final String name;

  /// The `data:<mime>;base64,…` form every upload path in the app wants.
  ///
  /// On the seam rather than in each caller: two screens need it, and a
  /// second copy of the extension-to-mime table is a second place for a
  /// `.webp` to arrive labelled `image/jpeg`.
  String get dataUri => 'data:$mimeType;base64,${base64Encode(bytes)}';

  String get mimeType {
    final String n = name.toLowerCase();
    if (n.endsWith('.png')) return 'image/png';
    if (n.endsWith('.webp')) return 'image/webp';
    if (n.endsWith('.gif')) return 'image/gif';
    return 'image/jpeg';
  }
}

class ImagePickCancelled extends ImagePickResult {
  const ImagePickCancelled();
}

class ImagePickFailure extends ImagePickResult {
  const ImagePickFailure({this.message});

  final String? message;
}

/// Where the photo comes from.
enum ImageSourceKind { gallery, camera }

/// The seam. Injected so a screen can be tested without a platform channel.
abstract class ImagePickingService {
  Future<ImagePickResult> pick(ImageSourceKind source);
}

/// `image_picker`-backed implementation.
///
/// Images are downscaled before they leave the device. A modern phone camera
/// produces 4000px JPEGs of several megabytes, and every one of them would be
/// uploaded over a mobile connection and then stored — when the largest thing
/// the product renders them at is a LinkedIn post image. 2048px on the long
/// edge at quality 85 is well above anything the UI shows.
class PluginImagePickingService implements ImagePickingService {
  const PluginImagePickingService();

  static const double _maxEdge = 2048;
  static const int _quality = 85;

  @override
  Future<ImagePickResult> pick(ImageSourceKind source) async {
    try {
      final XFile? file = await ImagePicker().pickImage(
        source: source == ImageSourceKind.camera
            ? ImageSource.camera
            : ImageSource.gallery,
        maxWidth: _maxEdge,
        maxHeight: _maxEdge,
        imageQuality: _quality,
      );
      if (file == null) return const ImagePickCancelled();
      return PickedImage(bytes: await file.readAsBytes(), name: file.name);
    } on PlatformException catch (e) {
      return ImagePickFailure(message: e.message);
    } on Object {
      return const ImagePickFailure();
    }
  }
}

@Riverpod(keepAlive: true)
ImagePickingService imagePicking(Ref ref) => const PluginImagePickingService();
