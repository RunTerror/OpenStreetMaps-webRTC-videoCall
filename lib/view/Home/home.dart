import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video/components/card_widget.dart';
import 'package:video/utils/Routes/routenames.dart';
import '../../provider/video_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Stream<List<Map<String, dynamic>>> getVideos() {
    final data = FirebaseFirestore.instance.collection('videos').snapshots();
    return data.map((event) => event.docs.map((e) => e.data()).toList());
  }
  final user = FirebaseAuth.instance.currentUser;
  String username="";
  TextEditingController usernameController=TextEditingController();
  @override
  Widget build(BuildContext context) {

  List<Map<String, dynamic>> list=context.watch<List<Map<String, dynamic>>>();
    var theme = Theme.of(context);
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children:[
            Container(height: 100,color: Colors.purple),
            ListTile(trailing:const Icon(Icons.forward),title: const Text("Profile",style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),),leading:const Icon(Icons.person),onTap: () {
            Navigator.pushNamed(context, RouteNames.profileScreen);
          },),
          ] 
        ),
      ),
      
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
              onPressed: () {
                Provider.of<VideoPickerProvider>(context, listen: false)
                    .pickVideo(context);
              },
              icon: const Icon(
                Icons.video_call,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, RouteNames.loginscreen);
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ))
        ],
        backgroundColor: theme.primaryColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        height: h,
        width: w,
        child: ListView(
          children: [
             TextField(
              onChanged: (value) {
                setState(() {
                  username=value;
                });
              },
              controller: usernameController,
              decoration:const InputDecoration(hintText: "username",prefixIcon: Icon(Icons.person),border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),)
            ),
            const SizedBox(
              height: 5,
            ),
             SizedBox(
              height: h / 1.3,
              child:list.isEmpty?const Center(child: Text("No videos added yet!"),): ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      itemBuilder: (context, index) {
                        final data = list[index];
                        return  (data['cateogry'] == null ||
                                data['date'] == null ||
                                data['description'] == null ||
                                data['location'] == null ||
                                data['name'] == null ||
                                data['title'] == null ||
                                data['videoUrl'] == null ||
                                data['imageUrl'] == null)
                            ? const Center(child: CircularProgressIndicator())
                            : username==""?  CardWidget(
                                data: list[index],
                              ): list[index]['name'].toString().toLowerCase().startsWith(username.toLowerCase())? CardWidget(
                                data: list[index],
                              ): const SizedBox();
                      },
                      itemCount: list.length,
                    )
            )
          ],
        ),
      ),
    );
  }
}
