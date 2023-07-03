import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';



import '../list_page/list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Razorpay? _razorpay;

  @override
  void initState() {
    super.initState();
    initializeFirebase();
  }

  void initializeFirebase() async {
    // Initialize Firebase
    await Firebase.initializeApp();
  }

  @override
  void dispose() {
    _razorpay?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Pay with Razorpay',
            ),
            ElevatedButton(
              onPressed: () {
                Razorpay razorpay = Razorpay();
                var options = {
                  'key': 'rzp_test_Ez2Pl9eWoFBCyN',
                  'amount': 100,
                  'name': 'Acme Corp.',
                  'description': 'Fine T-Shirt',
                  'retry': {'enabled': true, 'max_count': 1},
                  'send_sms_hash': true,
                  'prefill': {
                    'contact': '8888888888',
                    'email': 'test@razorpay.com'
                  },
                  'external': {
                    'wallets': ['paytm']
                  }
                };
                razorpay.on(
                    Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
                razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
                    handlePaymentSuccessResponse);
                razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
                    handleExternalWalletSelected);
                razorpay.open(options);
              },
              child: const Text("Pay with Razorpay"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaymentsPage()),
                );
              },
              child: const Text("View Payments"),
            ),
          ],
        ),
      ),
    );
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    showAlertDialog(context, "Payment Failed",
        "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
    savePaymentData(false, null);
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    showAlertDialog(
        context, "Payment Successful", "Payment ID: ${response.paymentId}");
    savePaymentData(true, response.paymentId);
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    showAlertDialog(
        context, "External Wallet Selected", "${response.walletName}");
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void savePaymentData(bool success, String? paymentId) {
    DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
    DatabaseReference paymentRef = databaseReference.child('payments').push();

    paymentRef.set({
      'success': success,
      'paymentId': paymentId ?? '',
    }).then((_) {
      print('Payment data saved successfully');
    }).catchError((error) {
      print('Failed to save payment data: $error');
    });
  }
}
