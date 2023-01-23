abstract class TransactionCallback {
  onTransactionSuccess(String id, String txRef);
  onTransactionError();
  onCancelled();
}