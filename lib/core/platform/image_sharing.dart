import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart' show consolidateHttpClientResponseBytes;
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart' show GlobalKey;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';

part 'image_sharing.g.dart';

/// Rendering a widget to a PNG and handing it to the user.
///
/// The banner mission produces an image whose whole purpose is to end up on
/// the user's LinkedIn profile. Without this the screen could draw it and
/// then had nowhere to put it, so it told the user to go and download the
/// file from the web instead — the one step of that mission the app could
/// not do was the step the mission is for.
///
/// A seam like `web_auth.dart` and `image_picking.dart`, so a screen can be
/// tested without a platform channel.
sealed class ShareResult {
  const ShareResult();
}

class ShareSucceeded extends ShareResult {
  const ShareSucceeded();
}

/// The user dismissed the sheet. A decision, not an error — callers stay
/// silent, the same rule the image picker follows.
class ShareDismissed extends ShareResult {
  const ShareDismissed();
}

class ShareFailed extends ShareResult {
  const ShareFailed({this.message});
  final String? message;
}

abstract class ImageSharingService {
  /// Downloads a generated image and offers it to the user as a file.
  ///
  /// Sharing the URL instead would hand them a link to a signed storage
  /// object that expires — the thing they want is the picture.
  Future<ShareResult> shareImageUrl({
    required String url,
    required String fileName,
    String? text,
  });

  /// Renders the widget behind [boundaryKey] at [targetWidth] logical pixels
  /// wide and offers it to the user as a PNG.
  Future<ShareResult> shareWidgetPng({
    required GlobalKey boundaryKey,
    required String fileName,
    required double targetWidth,
    String? text,
  });
}

class PlatformImageSharing implements ImageSharingService {
  const PlatformImageSharing();

  @override
  Future<ShareResult> shareImageUrl({
    required String url,
    required String fileName,
    String? text,
  }) async {
    try {
      // dart:io rather than the app's Dio client: this is a plain public
      // fetch of an image the server already handed us, and routing it
      // through the authenticated client would attach a bearer token to a
      // storage host that has no business seeing one.
      final HttpClient client = HttpClient();
      final HttpClientRequest request = await client.getUrl(Uri.parse(url));
      final HttpClientResponse response = await request.close();
      if (response.statusCode != 200) {
        client.close();
        return const ShareFailed();
      }
      final List<int> bytes = await consolidateHttpClientResponseBytes(response);
      client.close();

      final Directory dir = await getTemporaryDirectory();
      final File file = File('${dir.path}/$fileName');
      await file.writeAsBytes(bytes, flush: true);

      return _offer(file, text);
    } on Object {
      return const ShareFailed();
    }
  }

  /// The share sheet, and what its three outcomes mean here.
  Future<ShareResult> _offer(File file, String? text) async {
    final ShareResultStatus status = (await SharePlus.instance.share(
      ShareParams(files: <XFile>[XFile(file.path)], text: text),
    ))
        .status;
    return switch (status) {
      ShareResultStatus.success => const ShareSucceeded(),
      ShareResultStatus.dismissed => const ShareDismissed(),
      ShareResultStatus.unavailable => const ShareFailed(),
    };
  }

  @override
  Future<ShareResult> shareWidgetPng({
    required GlobalKey boundaryKey,
    required String fileName,
    required double targetWidth,
    String? text,
  }) async {
    try {
      final RenderObject? object =
          boundaryKey.currentContext?.findRenderObject();
      if (object is! RenderRepaintBoundary) {
        return const ShareFailed(message: 'Nothing to save yet.');
      }

      // Render at the TARGET width rather than the on-screen one. The preview
      // is a thumbnail a few hundred points wide; a LinkedIn banner is 1584
      // across, and exporting what is on screen would hand the user a blurry
      // image that looks fine in the app and wrong on their profile.
      final double ratio = targetWidth / object.size.width;
      final ui.Image image = await object.toImage(pixelRatio: ratio);
      final ByteData? bytes =
          await image.toByteData(format: ui.ImageByteFormat.png);
      image.dispose();
      if (bytes == null) return const ShareFailed();

      // Temp, not documents: this is a handoff, not a library. The OS clears
      // it, and a copy the user chose to keep lives wherever they saved it.
      final Directory dir = await getTemporaryDirectory();
      final File file = File('${dir.path}/$fileName');
      await file.writeAsBytes(bytes.buffer.asUint8List(), flush: true);

      return _offer(file, text);
    } on Object {
      return const ShareFailed();
    }
  }
}

@Riverpod(keepAlive: true)
ImageSharingService imageSharing(Ref ref) => const PlatformImageSharing();
