import 'package:flutter/material.dart';
import 'package:snooker_crud/page/ProductPage.dart';

class MainPage extends StatefulWidget {
  final String username;
  final String token;

  const MainPage({
    super.key,
    required this.username,
    required this.token,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Text> appBarTitle = [
    const Text(
      'คลังสินค้า',
      style: TextStyle(
        fontFamily: 'Kanit',
      ),
    ),
  ];
  List<IconButton> button = [
    IconButton(
        onPressed: () {}, icon: const Icon(Icons.person_add_alt_1_rounded))
  ];

  int pageIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> page = [ProductPage(token: widget.token)];
    return Scaffold(
      appBar: AppBar(title: appBarTitle[pageIndex]),
      drawer: Drawer(
          child: ListView(
        children: [
          DrawerHeader(
              child: Center(
                  child: Column(
            children: [
              const Text(
                'บริษัท N.P.D ก้าวไกลกรุ๊ปจำกัด',
                style: TextStyle(fontSize: 25, color: Colors.black),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                widget.username,
                style: const TextStyle(fontSize: 20, color: Colors.black),
              ),
            ],
          ))),
          ListTile(
            leading: const Icon(Icons.production_quantity_limits_outlined,
                color: Colors.black),
            title: const Text(
              'สินค้า',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            onTap: () async {
              setState(() {
                pageIndex = 0;
              });
            },
          ),
          Align(
              alignment: FractionalOffset.center,
              child:Column(
                children: <Widget>[
                  const Divider(),
                  ListTile(
                    onTap: () {
                     Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                    },
                    leading: const Icon(Icons.logout, color: Colors.black),
                    title: const Text(
                      "Logout",
                      style: TextStyle(fontSize: 14),
                    ),
                    
                  )
                ],
              ))
        ],
      )),
      body: page[pageIndex],
    );
  }
}
