class DalleAppException implements Exception {
  Exception? innerException;
  String friendlyMessage;
  String cause;
  DalleAppException(
      {required this.cause,
      required this.friendlyMessage,
      this.innerException});
}
