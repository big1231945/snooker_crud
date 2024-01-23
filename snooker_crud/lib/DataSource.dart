import 'package:flutter/material.dart';
import 'package:snooker_crud/Json.dart';

class DataSource extends DataTableSource {
  final List<ProductElement>? getData;

  final Function(int index, int id)? delete;

  final List<bool>? selectedRows;
  Function(
      {required int id,
      required double product_price,
      required String product_name,
      required String product_details,
      required String product_type,
      required String imgUrl})? updateData;

  final Function(int, bool)? onSelectedChanged;
  BuildContext? context;
  DataSource({
    this.getData,
    this.selectedRows,
    this.onSelectedChanged,
    this.context,
    this.updateData,
    this.delete,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= getData!.length) {
      return null;
    }
    bool showImg = true;

    if (getData![index].imgUrl != "") {
      showImg = false;
    }
    return DataRow.byIndex(
      onLongPress: () {},
      index: index,
      cells: [
        DataCell(Row(
          children: [
            IconButton(
                onPressed: () {
                  updateData!(
                      id: getData![index].id,
                      product_details: getData![index].productDetails,
                      imgUrl: getData![index].imgUrl,
                      product_name: getData![index].productName,
                      product_price: getData![index].productPrice,
                      product_type: getData![index].productType);
                },
                icon: const Icon(
                  Icons.edit_note_rounded,
                  color: Color.fromARGB(255, 14, 143, 10),
                )),
            IconButton(
                onPressed: () {
                  delete!(index, getData![index].id);
                },
                icon: const Icon(
                  Icons.delete_sweep_rounded,
                  color: Color.fromARGB(255, 168, 22, 12),
                )),
          ],
        )),
        DataCell(Text(getData![index].productType)),
        DataCell(Text(getData![index].productName)),
        if (showImg)
          const DataCell(SizedBox(
            height: 30,
            width: 30,
          ))
        else
          DataCell(
            SizedBox(
                width: 200,
                height: 200,
                child: Image.network(getData![index].imgUrl)),
          ),
        DataCell(Text(getData![index].productPrice.toString())),
        DataCell(Text(getData![index].productDetails)),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => getData!.length;

  @override
  int get selectedRowCount =>
      // selectedRows!.where((selected) => selected).length;
      0;
}
