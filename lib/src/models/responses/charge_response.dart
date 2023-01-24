class ChargeResponse {
  String status;
  String? transactionId;
  String txRef;

  ChargeResponse({
    required this.status,
    this.transactionId,
    required this.txRef,
  });

  ChargeResponse.cancelled({
    required String txRef,
  }) : this(status: "cancelled", txRef: txRef);

  ChargeResponse.error({
    required String txRef,
  }) : this(status: "error", txRef: txRef);

  bool get success => status.contains("success") == true;

  @override
  String toString() {
    return "ChargeResponse["
        "status:$status, "
        "transactionId:$transactionId, "
        "transactionRef:$txRef, "
        "]";
  }
}
