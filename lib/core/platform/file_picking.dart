import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'file_picking.g.dart';

/// Picking a DOCUMENT — a PDF or a spreadsheet.
///
/// Separate from `image_picking.dart` because the platform APIs are
/// different, not because the shapes are: `image_picker` opens the photo
/// library and cannot see a `.pdf` or a `.xlsx` at all. That is the whole
/// reason the CV step, the company-document step and the LinkedIn analytics
/// import stayed web-only after the image picker landed.
sealed class FilePickResult {
  const FilePickResult();
}

class PickedFile extends FilePickResult {
  const PickedFile({required this.bytes, required this.name});

  final Uint8List bytes;
  final String name;

  String get extension {
    final int dot = name.lastIndexOf('.');
    return dot == -1 ? '' : name.substring(dot + 1).toLowerCase();
  }
}

/// The user dismissed the picker. A decision, not an error — callers stay
/// silent, the same rule the image picker follows.
class FilePickCancelled extends FilePickResult {
  const FilePickCancelled();
}

class FilePickFailure extends FilePickResult {
  const FilePickFailure({this.message});
  final String? message;
}

abstract class FilePickingService {
  /// Opens the document picker, limited to [extensions] (without dots).
  Future<FilePickResult> pick({required List<String> extensions});
}

class PlatformFilePicking implements FilePickingService {
  const PlatformFilePicking();

  @override
  Future<FilePickResult> pick({required List<String> extensions}) async {
    try {
      final List<PlatformFile> files = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: extensions,
      );
      // An empty list is how this API reports a dismissed picker.
      if (files.isEmpty) return const FilePickCancelled();

      // Read the BYTES rather than keeping the path. On iOS the picker hands
      // back a security-scoped URL into a provider that may not be readable
      // later, and an iCloud document may have no local file at all until it
      // is materialised — `readAsBytes` does that materialising.
      final PlatformFile file = files.first;
      final Uint8List bytes = await file.readAsBytes();
      return PickedFile(bytes: bytes, name: file.name);
    } on Object {
      return const FilePickFailure();
    }
  }
}

@Riverpod(keepAlive: true)
FilePickingService filePicking(Ref ref) => const PlatformFilePicking();
