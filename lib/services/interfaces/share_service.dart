import 'dart:ui';

abstract class ShareService {
  Future<void> shareFile(String filePath, {String? subject, String? text});
}
