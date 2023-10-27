import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import 'components.dart';

String login = 'createAccountDone';
bool isConnect = false;
Future<void> checkInternetConnectivity() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    isConnect = true;
  } else {
    // Wait for a brief moment to allow the package to update its status
    await Future.delayed(const Duration(seconds: 2));
    connectivityResult = await Connectivity().checkConnectivity();
    isConnect =
        connectivityResult == ConnectivityResult.mobile ||
            connectivityResult == ConnectivityResult.wifi;
    toast(
      msg: 'Please check the Internet',
      isError: false,);
  }
}


Future<bool> checkTheCode(String code,String name) async {
  bool isTheCodeAvailable = false;

  // Create a DocumentReference to the document with the name.
  DocumentReference documentReference = FirebaseFirestore.instance.collection('Account creation codes').doc(code);

  // Call the get() method on the DocumentReference to retrieve the document.
  DocumentSnapshot documentSnapshot = await documentReference.get();

  //  Check if the hasData property of the DocumentSnapshot is true.
  if(documentSnapshot.exists){
    await documentSnapshot.reference.get().then((value) {
      if(value.get('Has the code been used')){
        isTheCodeAvailable = false;
      }else{
        try{
          documentSnapshot.reference.update({
            'Has the code been used' : true,
            'Name' : name,
          }
          );
          isTheCodeAvailable = true;
        } catch(error) {
          if (kDebugMode) {
            print(error.toString());
          }
        }
      }
    },
    );

  }
  return isTheCodeAvailable;
}
