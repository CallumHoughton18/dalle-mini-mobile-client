import 'package:dalle_mobile_client/services/interfaces/share_service.dart';
import 'package:share_plus/share_plus.dart';

class SharePlusShareService implements ShareService {
  @override
  Future<void> shareFile(String filePath,
      {String? subject, String? text}) async {
    await Share.shareFiles(<String>[filePath], subject: subject, text: text);
  }
}
