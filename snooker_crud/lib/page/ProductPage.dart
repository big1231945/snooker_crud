import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:snooker_crud/AddDialog.dart';
import 'package:snooker_crud/Json.dart';
import 'package:snooker_crud/UpdateDialog.dart';

import '../DataSource.dart';
import '../ServerConfig.dart';

class ProductPage extends StatefulWidget {
  final String token;

  const ProductPage({super.key, required this.token});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  ScrollController tableController = ScrollController();
  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  TextEditingController sertext = TextEditingController();

  Product? productData;
  bool loading = true;
  List<ProductElement> datalist = [];

  Future<void> productGetData() async {
    String authorization = widget.token;
    Map<String, String> headersToken = {
      "Authorization": "Bearer $authorization"
    };
    setState(() {
      loading = true;
    });
    try {
      final dashboard = await http.post(
          Uri.parse('${ServerConfig.url}/api/crud/product'),
          headers: headersToken);
      if (dashboard.statusCode == 200) {
        setState(() {
          String data = utf8.decode(dashboard.bodyBytes);
          productData = productFromJson(data);
          loading = false;
        });
      } else {
        setState(() {
          loading = true;
        });
      }
    } catch (e) {}
  }

  addOk() {
    AwesomeDialog(
            context: context,
            animType: AnimType.scale,
            dialogType: DialogType.success,
            title: 'เพิ่มข้อมูลสำเร็จ',
            btnOkOnPress: () {},
            width: 500)
        .show();
  }

  addErorr() {
    AwesomeDialog(
            context: context,
            animType: AnimType.scale,
            dialogType: DialogType.error,
            title: 'เพิ่มข้อมูลไม่สำเร็จ',
            btnOkOnPress: () {},
            width: 500)
        .show();
  }

  updateOk() {
    AwesomeDialog(
            context: context,
            animType: AnimType.scale,
            dialogType: DialogType.success,
            title: 'แก้ไขสำเร็จ',
            btnOkOnPress: () {},
            width: 500)
        .show();
  }

  updateErorr() {
    AwesomeDialog(
            context: context,
            animType: AnimType.scale,
            dialogType: DialogType.error,
            title: 'แก้ไขไม่สำเร็จ',
            btnOkOnPress: () {},
            width: 500)
        .show();
  }

  deleteOk() {
    AwesomeDialog(
            context: context,
            animType: AnimType.scale,
            dialogType: DialogType.success,
            title: 'ลบข้อมูลสำเร็จ',
            btnOkOnPress: () {},
            width: 500)
        .show();
  }

  deleteErorr() {
    AwesomeDialog(
            context: context,
            animType: AnimType.scale,
            dialogType: DialogType.error,
            title: 'ลบข้อมูลไม่สำเร็จ',
            btnOkOnPress: () {},
            width: 500)
        .show();
  }

  void deleteData(int index, int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: [
            ElevatedButton(
              child: const Text('ยืนยัน'),
              onPressed: () async {
                String authorization = widget.token;
                Map<String, String> headersToken = {
                  "Content-Type": "application/json",
                  "Authorization": "Bearer $authorization"
                };

                try {
                  final updatedata = await http.delete(
                      Uri.parse('${ServerConfig.url}/api/crud/delete/$id'),
                      headers: headersToken);

                  if (updatedata.statusCode == 200) {
                    productGetData();
                    Navigator.of(context).pop();
                    deleteOk();
                  } else {
                    Navigator.of(context).pop();
                    deleteErorr();
                  }
                } catch (e) {
                  Navigator.of(context).pop();
                  deleteErorr();
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
          title: const Text(
            "ลบข้อมูล",
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Kanit',
            ),
          ),
        );
      },
    );
  }

  Widget tableData() {
    return PaginatedDataTable(
      arrowHeadColor: Colors.blue,
      controller: tableController,
      showFirstLastButtons: true,
      rowsPerPage: _rowsPerPage,
      dataRowMinHeight: 30,
      dataRowMaxHeight: 200, 
      columnSpacing: 20, 
      availableRowsPerPage: const <int>[5, 10, 15, 20, 50, 100, 150],
      onPageChanged: (value) => productData!.product.length / _rowsPerPage,
      onRowsPerPageChanged: (value) {
        setState(() {
          _rowsPerPage = value!;
        });
      },
      source: DataSource(
        getData: productData!.product,
        updateData: ({
          required int id,
          required double product_price,
          required String product_name,
          required String product_details,
          required String product_type,
          required String imgUrl,
        }) {
          return showDialog(
              context: context,
              builder: (BuildContext context) {
                return UpdateDialog(
                  productDetails: product_details,
                  productName: product_name,
                  imgUrl: imgUrl,
                  productPrice: product_price,
                  productType: product_type,
                  token: widget.token,
                  id: id,
                  getReload: (reload) {
                    if (reload == true) {
                      productGetData();
                    }
                  },
                  getDialog: (reload) {
                    if (reload == true) {
                      updateOk();
                    } else {
                      updateErorr();
                    }
                  },
                );
              });
        },
        delete: (index, id) {
          deleteData(index, id);
        },
      ),
      columns: const [
        DataColumn(
            label: Text(
          '',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Kanit',
          ),
        )),
        DataColumn(
            label: Text(
          'ประเภท',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Kanit',
          ),
        )),
        DataColumn(
            label: Text(
          'ชื่อสินค้า',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Kanit',
          ),
        )),
        DataColumn(
            label: Text(
          'รูป',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Kanit',
          ),
        )),
        DataColumn(
            label: Text(
          'ราคาสินค้า',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Kanit',
          ),
        )),
        DataColumn(
            label: Text(
          'รายละเอียดเพิ่มเติม',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Kanit',
          ),
        )),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      productGetData();
    });
  }

  Widget searchWiget() {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(bottom: 5, right: 5, left: 5, top: 10),
      decoration: BoxDecoration(
          border: Border.all(width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: TextField(
        onChanged: (value) {
          if (sertext.text.isEmpty) {
            setState(() {
              // datalist = productData!.user!.toList();
              productGetData();
            });
          }
          List<ProductElement> filteredList = productData!.product
              .where((data) =>
                  data.productName
                      .toString()
                      .toLowerCase()
                      .contains(sertext.text.toLowerCase()) ||
                  data.productType
                      .toString()
                      .toLowerCase()
                      .contains(sertext.text.toLowerCase()))
              .toList();
          setState(() {
            productData!.product = filteredList;
          });
        },
        controller: sertext,
        decoration: const InputDecoration(
          hintText: 'ค้นหาข้อมูล',
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AddDialog(
                                    token: widget.token,
                                    getReload: (reload) {
                                      if (reload == true) {
                                        productGetData();
                                      }
                                    },
                                    getDialog: (reload) {
                                      if (reload == true) {
                                        addOk();
                                      } else {
                                        addErorr();
                                      }
                                    },
                                  );
                                },
                              );
                            },
                            icon: const Icon(
                              Icons.add,
                              color: Colors.blue,
                              size: 40,
                            )),
                        searchWiget(),
                        IconButton(
                            onPressed: () {
                              productGetData();
                            },
                            icon: const Icon(
                              Icons.replay_circle_filled_outlined,
                              color: Colors.blue,
                              size: 40,
                            )),
                      ],
                    ),
                  ),
                  tableData()
                ],
              ),
            ),
    );
  }
}
