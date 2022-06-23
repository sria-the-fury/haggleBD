import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:haggle/firebase/UserManagement.dart';

class UpdateAddressAndPhoneModal extends StatefulWidget {
  final String userAddress;
  final String userCellNumber;
  const UpdateAddressAndPhoneModal({Key? key, required this.userAddress, required this.userCellNumber}) : super(key: key);

  @override
  _UpdateAddressAndPhoneModalState createState() =>
      _UpdateAddressAndPhoneModalState();
}

class _UpdateAddressAndPhoneModalState
    extends State<UpdateAddressAndPhoneModal> {
  User? user = FirebaseAuth.instance.currentUser;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String cellNumber = '';
  String address = '';

  @override
  void initState() {

      setState(() {
        cellNumber = widget.userCellNumber == '' ? cellNumber : widget.userCellNumber;
        address = widget.userAddress == '' ? cellNumber : widget.userAddress;
      });
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    setState(() {
      cellNumber = '';
      address = '';
    });
    super.dispose();
  }

  disableUpdate () {
    return cellNumber.length < 11 || address.length < 10;
  }
  disableSubmitIfSame () {
    return widget.userCellNumber == cellNumber && widget.userAddress == address;
  }



  var raisedButtonStyle = ElevatedButton.styleFrom(
    onPrimary: Colors.blue[500],
    primary: Colors.blue[500],
    maximumSize: const Size(88, 36),
    padding: const EdgeInsets.symmetric(horizontal: 5),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(50)),
    ),
  );


  @override
  Widget build(BuildContext context) {

    return Container(
      height: 250,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        color: Colors.white,
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(
                  Icons.remove_circle,
                  color: Colors.blue[500],
                  size: 30,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      maxLength: 11,
                      initialValue: widget.userCellNumber == '' ? '' : widget.userCellNumber,
                      onChanged: (text) {
                        setState(() {
                          cellNumber = text;
                        });
                      },
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: widget.userCellNumber == '' ? '01701234123' : widget.userCellNumber,
                        labelText: 'Cell Number',
                        errorText:
                            cellNumber.length < 11
                                ? 'Number Must be 11 Digit.'
                                : null,
                        prefixIcon: const Icon(Icons.call),
                      ),
                    ),
                    const SizedBox(
                      height: 2.0,
                    ),
                    TextFormField(
                      autofocus: true,
                      maxLength: 35,
                      initialValue: widget.userAddress == '' ? '' : widget.userAddress,
                      keyboardType: TextInputType.text,
                      onChanged: (text) {
                        setState(() {
                          address = text;
                        });
                      },
                      decoration:  InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: widget.userAddress == '' ? 'Mirpur, Dhaka' : widget.userAddress,
                        labelText: 'Address',
                        errorText:
                        address.length < 10
                            ? 'Address should not be small or empty'
                            : null,
                        prefixIcon: const Icon(Icons.person_pin_circle),
                      ),
                    ),
                    const SizedBox(
                      height: 2.0,
                    ),
                    ElevatedButton(
                      style: raisedButtonStyle,
                      onPressed: disableUpdate() || disableSubmitIfSame() ? null : () {
                       UserManagement().updateUserAddressAndCellNumber(user?.uid, address, cellNumber);
                       Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.cloud_upload,
                        color: disableUpdate() ? Colors.grey : Colors.white,
                        size: 20.0,
                      ),
                    )
                  ],
                )),
          ]),
    );
  }
}
