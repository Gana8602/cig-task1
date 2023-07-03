
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class PaymentsPage extends StatefulWidget {
  @override
  _PaymentsPageState createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  List<Map<dynamic, dynamic>> payments = [];

  @override
  void initState() {
    super.initState();
    fetchPayments();
  }

  void fetchPayments() {
    DatabaseReference databaseReference =
    FirebaseDatabase.instance.reference().child('payments');
    databaseReference.once().then((DatabaseEvent event) {
      List<Map<dynamic, dynamic>> paymentList = [];
      Map<dynamic, dynamic>? values =
      (event.snapshot.value as Map<dynamic, dynamic>?);

      if (values != null) {
        values.forEach((key, value) {
          paymentList.add(value);
        });
      }
      setState(() {
        payments = paymentList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payments'),
      ),
      body: ListView.builder(
        itemCount: payments.length,
        itemBuilder: (BuildContext context, int index)  {
          bool isPaid = payments[index]['success'];
          Color statusColor = isPaid ? Colors.green : Colors.red;

          return ListTile(
            title: Text('Payment ID: ${payments[index]['paymentId']}'),
            subtitle: Text('Status: ${isPaid ? 'Paid' : 'Pending'}'),
            tileColor: statusColor,
          );
        },
      ),
    );
  }
}
