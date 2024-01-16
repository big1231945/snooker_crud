import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:snooker_crud/ServerConfig.dart';
import 'package:snooker_crud/page/MainPage.dart';
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool loading = false;

  void goNextPage(String token) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MainPage(
            username: usernameController.text,
            token: token,
          ),
        ));
  }

  Future userNotCorrectAlert() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(20)),
          alignment: Alignment.center,
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            Container(
                width: 125,
                height: 50,
                margin: const EdgeInsets.only(bottom: 10),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'ยืนยัน',
                      style: TextStyle(fontSize: 16),
                    ))),
          ],
          title: const Column(
            children: [
              Icon(Icons.error_outline_rounded, size: 100,color: Colors.limeAccent),
              Text(
                'แจ้งเตือน',
                style: TextStyle(color: Colors.red),
              )
            ],
          ),
          content: const SizedBox(
            height: 30,
            child: Column(
              children: [
                Text(
                  'username หรือ password ไม่ถูกต้อง',
                )
              ],
            ),
          )),
    );
  }

  Future errorAlert() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(20)),
          alignment: Alignment.center,
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            Container(
                width: 125,
                height: 50,
                margin: const EdgeInsets.only(bottom: 10),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'ยืนยัน',
                      style: TextStyle(fontSize: 16),
                    ))),
          ],
          title: const Column(
            children: [
              Icon(Icons.error_outline_rounded, size: 100,color: Colors.limeAccent),
              Text(
                'แจ้งเตือน',
                style: TextStyle(color: Colors.red),
              )
            ],
          ),
          content: const SizedBox(
            height: 30,
            child: Column(
              children: [
                Text(
                  'เกิดข้อผิดพลาด',
                )
              ],
            ),
          )),
    );
  }

  Future connectionErrorAlert() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(20)),
          alignment: Alignment.center,
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            Container(
                width: 125,
                height: 50,
                margin: const EdgeInsets.only(bottom: 10),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'ยืนยัน',
                      style: TextStyle(fontSize: 16),
                    ))),
          ],
          title: const Column(
            children: [
              Icon(Icons.error_outline_rounded, size: 100,color: Colors.limeAccent),
              Text(
                'แจ้งเตือน',
                style: TextStyle(color: Colors.red),
              )
            ],
          ),
          content: const SizedBox(
            height: 60,
            child: Column(
              children: [
                Text(
                  'เกิดข้อผิดพลาด เชื่อมต่อกับ Server ไม่สำเร็จ',
                  textAlign: TextAlign.center,
                )
              ],
            ),
          )),
    );
  }

  Future formEmptyAlert() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(20)),
          alignment: Alignment.center,
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            Container(
                width: 125,
                height: 50,
                margin: const EdgeInsets.only(bottom: 10),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'ยืนยัน',
                      style: TextStyle(fontSize: 16),
                    ))),
          ],
          title: const Column(
            children: [
              Icon(Icons.error_outline_rounded, size: 100,color: Colors.yellow),
              Text(
                'แจ้งเตือน',
                style: TextStyle(color: Colors.red),
              )
            ],
          ),
          content: const SizedBox(
            height: 30,
            child: Column(
              children: [
                Text(
                  'username หรือ password ไม่ถูกต้อง',
                )
              ],
            ),
          )),
    );
  }

  pop() {
    Navigator.pop(context);
  }

  Future<void> login() async {
    Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    Map<String,String> body ={
            "username": usernameController.text,
            "password": passwordController.text,
          };
    try {
      final http.Response  response = await http.post(
          Uri.parse("${ServerConfig.url}/api/admin/login"),
          headers: headers,
          body: body);
      if (response.statusCode == 200) {
        setState(() {
          loading = false;
        });
        Map<String, dynamic> token = json.decode(response.body);
        String access = token["access_token"];
        goNextPage(access);
        
      } else if (response.statusCode == 400) {
        userNotCorrectAlert();
        setState(() {
          loading = false;
        });
      } else {
        errorAlert();
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      print(e);
      connectionErrorAlert();
      setState(() {
        loading = false;
      });
    }
  }

  Widget body() {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Color.fromARGB(255, 68, 68, 68))),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  margin: const EdgeInsets.only(
                    bottom: 20,
                  ),
                  child: const Text(
                    'บริษัท N.P.D ก้าวไกลกรุ๊ปจำกัด',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  )),
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                width: 300,
                child: TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'ชื่อผู้ใช้')),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                width: 300,
                child: TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: 'รหัสผ่าน')),
              ),
              SizedBox(
                width: 300,
                height: 50,
                child: ElevatedButton(
                  child: const Text(
                    'เข้าสู่ระบบ',
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () async {
                    setState(() {
                      loading = true;
                    });

                    if (usernameController.text.isEmpty ||
                        passwordController.text.isEmpty) {
                      formEmptyAlert();
                      setState(() {
                        loading = false;
                      });
                    } else {
                      login();
                    }
                    setState(() {
                      loading = false;
                    });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: loading ? const CircularProgressIndicator() : body(),
      ),
    );
  }
}
