import 'package:flutter/material.dart';
import 'package:flutterwave_standard/flutterwave.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(title: 'Flutterwave Standard'),
      title: 'Flutter Standard Demo',
      themeMode: ThemeMode.system,
      darkTheme: ThemeData.dark(useMaterial3: true),
      theme: ThemeData.light(useMaterial3: true),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late GlobalKey<FormState> formKey;

  late TextEditingController amountController;
  late TextEditingController currencyController;
  late TextEditingController narrationController;
  late TextEditingController publicKeyController;
  late TextEditingController encryptionKeyController;
  late TextEditingController emailController;
  late TextEditingController phoneNumberController;

  late bool isTesting;

  @override
  void initState() {
    super.initState();

    formKey = GlobalKey<FormState>();

    amountController = TextEditingController();
    currencyController = TextEditingController();
    narrationController = TextEditingController();
    publicKeyController = TextEditingController();
    encryptionKeyController = TextEditingController();
    emailController = TextEditingController();
    phoneNumberController = TextEditingController();

    isTesting = true;

    emailController.text = "customer@customer.com";
    currencyController.text = "";
    publicKeyController.text = isTesting ? "YOUR_PUBLIC_TEST_KEY" : "YOUR_PUBLIC_LIVE_KEY";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        width: double.infinity,
        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Form(
          key: formKey,
          child: ListView(children: <Widget>[
            // AMOUNT
            Container(
              margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
              child: TextFormField(
                controller: amountController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: "Amount"),
                validator: _validateFieldForRequirement,
              ),
            ),

            // CURRENCY
            Container(
              margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
              child: TextFormField(
                controller: currencyController,
                textInputAction: TextInputAction.next,
                readOnly: true,
                onTap: _showCurrencySelectionBottomSheet,
                decoration: InputDecoration(hintText: "Currency"),
                validator: _validateFieldForRequirement,
              ),
            ),

            // PUBLIC KEY
            Container(
              margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
              child: TextFormField(
                controller: publicKeyController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(hintText: "Public Key"),
                validator: _validateFieldForRequirement,
              ),
            ),

            // ENCRYPTION KEY
            Container(
              margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
              child: TextFormField(
                controller: encryptionKeyController,
                textInputAction: TextInputAction.next,
                obscureText: true,
                decoration: InputDecoration(hintText: "Encryption Key"),
              ),
            ),

            // EMAIL
            Container(
              margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
              child: TextFormField(
                controller: emailController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(hintText: "Email"),
                validator: _validateFieldForRequirement,
              ),
            ),

            // PHONE NUMBER
            Container(
              margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
              child: TextFormField(
                controller: phoneNumberController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(hintText: "Phone Number"),
              ),
            ),

            // IS TESTING
            Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
              child: Row(children: [
                Text("Use Debug"),
                Switch(
                  value: isTesting,
                  onChanged: _updateIsTesting,
                ),
              ]),
            ),

            // MAKE PAYMENT
            Container(
              width: double.infinity,
              height: 50,
              margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
              child: ElevatedButton(
                onPressed: _onMakePaymentTap,
                child: Text("Make Payment"),
              ),
            )
          ]),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  String? _validateFieldForRequirement(value, {String label = "This field"}) {
    if (value == null || value.trim().isEmpty) {
      return "$label is required";
    }

    return null;
  }

  void _updateIsTesting(bool isTesting) {
    setState(() {
      this.isTesting = isTesting;
    });
  }

  void _onMakePaymentTap() async {
    final formState = formKey.currentState;
    if (formState == null) return;
    if (!formState.validate()) return;

    final customer = Customer(
      name: "FLW Developer", // TODO: should be an input
      phoneNumber: phoneNumberController.text,
      email: emailController.text,
    );

    final amount = amountController.text.trim();
    final currency = currencyController.text.trim();
    final publicKey = publicKeyController.text.trim();

    final flutterwave = Flutterwave(
        context: context,
        publicKey: publicKey,
        currency: currency,
        redirectUrl: 'https://facebook.com',
        txRef: Uuid().v1(),
        amount: amount,
        customer: customer,
        paymentOptions: "card, payattitude, barter, bank transfer, ussd",
        customization: Customization(title: "Test Payment"),
        isTestMode: isTesting);

    final response = await flutterwave.charge();
    print("response: $response");
    _showMessageDialog("$response\n\nCheck logs for more details.");
  }

  void _showCurrencySelectionBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return _CurrencySelectionWidget(
            currencies: ["NGN", "RWF", "UGX", "KES", "ZAR", "USD", "GHS", "TZS"],
            onCurrencyTap: _handleCurrencyTap,
          );
        });
  }

  void _handleCurrencyTap(String currency) {
    setState(() {
      currencyController.text = currency;
    });
    Navigator.pop(context);
  }

  void _showMessageDialog(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                child: Text(message),
              ),
            ),
          );
        });
  }
}

class _CurrencySelectionWidget extends StatelessWidget {
  const _CurrencySelectionWidget({
    Key? key,
    required this.currencies,
    required this.onCurrencyTap,
  }) : super(key: key);

  final List<String> currencies;
  final Function(String) onCurrencyTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      margin: EdgeInsets.only(top: 10),
      child: ListView.builder(
          itemCount: currencies.length,
          itemBuilder: (_, index) {
            final currency = currencies[index];
            return ListTile(
              onTap: () => onCurrencyTap(currency),
              title: Text(currency, textAlign: TextAlign.start),
            );
          }),
    );
  }
}
