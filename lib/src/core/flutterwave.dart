import 'package:flutter/material.dart';
import 'package:flutterwave_standard/src/models/requests/customer.dart';
import 'package:flutterwave_standard/src/models/requests/customizations.dart';
import 'package:flutterwave_standard/src/models/requests/standard_request.dart';
import 'package:flutterwave_standard/src/models/responses/charge_response.dart';
import 'package:flutterwave_standard/src/models/responses/standard_response.dart';
import 'package:flutterwave_standard/src/models/subaccount.dart';
import 'package:flutterwave_standard/src/view/standard_webview.dart';
import 'package:http/http.dart' as http;

class Flutterwave {
  BuildContext context;
  String txRef;
  String amount;
  Customization customization;
  Customer customer;
  bool isTestMode;
  String publicKey;
  String paymentOptions;
  String redirectUrl;
  String? currency;
  String? paymentPlanId;
  List<SubAccount>? subAccounts;
  Map<dynamic, dynamic>? meta;

  Flutterwave({
    required this.context,
    required this.publicKey,
    required this.txRef,
    required this.amount,
    required this.customer,
    required this.paymentOptions,
    required this.customization,
    required this.redirectUrl,
    required this.isTestMode,
    this.currency,
    this.paymentPlanId,
    this.subAccounts,
    this.meta,
  });

  /// Starts Standard Transaction
  Future<ChargeResponse> charge() async {
    final request = StandardRequest(
      txRef: txRef,
      amount: amount,
      customer: customer,
      paymentOptions: paymentOptions,
      customization: customization,
      isTestMode: isTestMode,
      redirectUrl: redirectUrl,
      publicKey: publicKey,
      currency: currency,
      paymentPlanId: paymentPlanId,
      subAccounts: subAccounts,
      meta: meta,
    );

    final StandardResponse? standardResponse;

    try {
      standardResponse = await request.execute(http.Client());
    } catch (error) {
      if (isTestMode) {
        print('flw:charge_failed: $error');
      }

      return ChargeResponse.error(txRef: request.txRef);
    }

    // Check response status for errors
    // TODO: this case is handled by try-catch, so might be redundant.
    if (standardResponse.status == "error") {
      if (isTestMode) {
        print('flw:charge_failed: Status Error. '
            'message: ${standardResponse.message}');
      }

      return ChargeResponse.error(txRef: request.txRef);
    }

    // Validate payment-url from response
    final paymentUrl = standardResponse.data?.link;
    if (paymentUrl == null || paymentUrl.isEmpty) {
      if (isTestMode) {
        print('flw:charge_failed: Invalid Payment URL. '
            'Unable to process this transaction. '
            'Please check that you generated a new tx_ref.');
      }

      return ChargeResponse.error(txRef: request.txRef);
    }

    // Open Payment URL in a WebView and wait for result
    final chargeResponse = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => StandardWebView(url: paymentUrl)),
    );

    // Validate response
    if (chargeResponse == null) {
      if (isTestMode) {
        print('flw:charge_failed: Charge Response is null. '
            'This might be user-initiated cancellation.');
      }

      return ChargeResponse.cancelled(txRef: request.txRef);
    }

    // https://stackoverflow.com/questions/73907763
    // if (chargeResponse.runtimeType != ChargeResponse().runtimeType) {
    if (chargeResponse is ChargeResponse) {
      if (isTestMode) {
        print('flw:charge_failed: Invalid Transaction Result.');
      }

      return ChargeResponse.cancelled(txRef: request.txRef);
    }

    return chargeResponse;
  }
}
