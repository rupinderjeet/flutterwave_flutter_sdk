import 'package:flutterwave_standard/src/utils.dart';

class Customer {
  String email;
  String? name;
  String? phoneNumber;

  Customer({
    required this.email,
    this.name,
    this.phoneNumber,
  });

  /// Converts instance of Customer to json
  Map<String, dynamic> toJson() {
    final customer = {
      "email": this.email,
      "phonenumber": this.phoneNumber,
      "name": this.name,
    };
    return Utils.removeKeysWithEmptyValues(customer);
  }
}
