import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../ServerConfig.dart';

class UpdateDialog extends StatefulWidget {
  final Function(bool reload)? getReload;
  final Function(bool reload)? getDialog;
  final int id;
  final double productPrice;
  final String productName;
  final String imgUrl;
  final String productDetails;
  final String productType;
  final String token;

  const UpdateDialog({
    super.key,
    this.getReload,
    this.getDialog,
    required this.id,
    required this.productPrice,
    required this.productName,
    required this.productDetails,
    required this.productType,
    required this.token,
    required this.imgUrl,
  });

  @override
  State<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  TextEditingController idController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();
  TextEditingController productNameController = TextEditingController();
  TextEditingController productDetailsController = TextEditingController();
  TextEditingController productTypeController = TextEditingController();
  TextEditingController imgUrlController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    idController.text = widget.id.toString();
    productPriceController.text = widget.productPrice.toString();
    productNameController.text = widget.productName;
    productDetailsController.text = widget.productDetails;
    productTypeController.text = widget.productType;
    imgUrlController.text = widget.imgUrl;
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
              "id": idController.text,
              "product_price": productPriceController.text,
              "product_name": productNameController.text,
              "product_details": productDetailsController.text,
              "product_type": productTypeController.text,
              "img_url": imgUrlController.text
            });
            
            try {
              final updatedata = await http.put(
                Uri.parse('${ServerConfig.url}/api/crud/update/${widget.id}'),
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
                widget.getDialog!(reload);
              }
            } catch (e) {
              bool reload = false;
              Navigator.of(context).pop();
              widget.getDialog!(reload);
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
      title: Text(
        "แก้ไขข้อมูล ${widget.productName}",
        style: const TextStyle(
          color: Colors.black,
          fontFamily: 'Kanit',
        ),
      ),
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
              controller: imgUrlController,
              decoration: const InputDecoration(
                labelText: "รูป",
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
