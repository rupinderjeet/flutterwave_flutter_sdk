abstract class TransactionCallback {
  void onTransactionSuccess(String id, String txRef);
  void onTransactionError();
  void onCancelled();
}