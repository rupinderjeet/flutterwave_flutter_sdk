import 'package:flutterwave_standard/src/utils.dart';

class Customization {
  String? title;
  String? description;
  String? logo;

  Customization({
    this.title,
    this.description,
    this.logo,
  });

  /// Converts instance of Customization to json
  Map<String, dynamic> toJson() {
    final customization = {
      "title": this.title,
      "description": this.description,
      "logo": this.logo,
    };
    return Utils.removeKeysWithEmptyValues(customization);
  }
}
