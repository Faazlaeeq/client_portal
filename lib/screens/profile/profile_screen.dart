import 'package:client_portal/Database/firebase_service.dart';
import 'package:client_portal/models/user_model.dart';
import 'package:client_portal/screens/dashboard/components/header.dart';
import 'package:client_portal/widgets/mysnackbar.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final firestore = FireStoreService("users");
  final auth = FirebaseAuthService();
  var dataExits = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    firestore
        .retriveDataWhereMap("uid", auth.auth.currentUser!.uid.toString())
        .then((value) {
      debugPrint("Value: $value");
      setState(() {
        if (value != null) {
          dataExits = true;
          _nameController.text = value?.docs[0].data()['name'];
          _emailController.text = value?.docs[0].data()['email'];
          _phoneController.text = value?.docs[0].data()['phone'];
        } else {
          dataExits = false;
          _nameController.text = "Enter you name to Update";
          _phoneController.text = "Enter you phone to Update";
          _emailController.text = auth.auth.currentUser!.email.toString();
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Header("Profile"),
              SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                readOnly: true,
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  enabled: false,
                  labelStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              OutlinedButton(
                  onPressed: () async {
                    User user = User(
                        uid: auth.auth.currentUser!.uid,
                        email: _emailController.text,
                        name: _nameController.text,
                        phone: _phoneController.text);

                    try {
                      if (!dataExits) {
                        await firestore.insertData(user.toJson());
                      } else {
                        await firestore.updateData(user.uid, user.toJson());
                      }
                      MySnackbar.showSucessSnackbar(context, "Profile Updated");
                    } catch (e) {
                      debugPrint(e.toString());
                      MySnackbar.showErrorSnackbar(context, e.toString());
                    }
                  },
                  child: Text('Save')),
            ],
          ),
        ),
      ),
    );
  }
}
