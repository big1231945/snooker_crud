import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../ServerConfig.dart';

class AddDialog extends StatefulWidget {

  final String token;
  final Function(bool reload)? getReload;
  final Function(bool reload)? getDialog;

  const AddDialog({
    super.key,
    this.getReload,
    this.getDialog,
    required this.token,
  });

  @override
  State<AddDialog> createState() => _AddDialogState();
}

class _AddDialogState extends State<AddDialog> {
  TextEditingController productPriceController = TextEditingController();
  TextEditingController productNameController = TextEditingController();
  TextEditingController productDetailsController = TextEditingController();
  TextEditingController productTypeController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        ElevatedButton(
          child: const Text('บันทึก'),
          onPressed: () async {
            String authorization = widget.token;
            Map<String, String> headersToken = {
              "Content-Type": "application/json",
              "Authorization": "Bearer $authorization"
            };
            String body = jsonEncode(<String, String>{
              "product_price": productPriceController.text,
              "product_name": productNameController.text,
              "product_details": productDetailsController.text,
              "product_type": productTypeController.text,
              
            });
            final updatedata = await http.post(
                Uri.parse(
                    '${ServerConfig.url}/api/crud/add'),
                headers: headersToken,
                body: body);

            if (updatedata.statusCode == 200) {
              bool reload = true;
              Navigator.of(context).pop();
              setState(() {
                widget.getReload!(reload);
                widget.getDialog!(reload);
              });
            } else {
              bool reload = false;
              Navigator.of(context).pop();
              setState(() {
                widget.getDialog!(reload);
              });
            }
          },
        ),
        ElevatedButton(
          style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.red)),
          child: const Text('ยกเลิก'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
      content: SingleChildScrollView(
          child: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: productTypeController,
              decoration: const InputDecoration(
                labelText: "ประเภท",
              ),
            ),
            TextFormField(
              controller: productNameController,
              decoration: const InputDecoration(
                labelText: "ชื่อสินค้า",
              ),
            ),
            TextFormField(
              controller: productPriceController,
              decoration: const InputDecoration(
                labelText: "ราคาสินค้า",
              ),
            ),
            TextFormField(
              controller: productDetailsController,
              decoration: const InputDecoration(
                labelText: "รายละเอียดเพิ่มเติม",
              ),
            ),
           
          ],
        ),
      )),
    );
  }
}
