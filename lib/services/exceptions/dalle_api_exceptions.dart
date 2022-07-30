import 'package:dalle_mobile_client/shared/exceptions/dalle_app_exception.dart';

class DalleApiException extends DalleAppException {
  DalleApiException({required cause, required friendlyMessage, innerException})
      : super(
            cause: cause,
            friendlyMessage: friendlyMessage,
            innerException: innerException);
}
