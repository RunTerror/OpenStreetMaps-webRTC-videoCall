import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video/provider/profile_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user=FirebaseAuth.instance.currentUser;

  Stream<Map<String, dynamic>> getImageUrl(){
    final snapshots=FirebaseFirestore.instance.collection('users').doc(user!.uid).snapshots();
   return snapshots.map((event) => event.data()!);
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final profileprovider=Provider.of<ProfileProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 5),
        height: h,
        width: w,
        child: Column(
          children: [
            InkWell(
                onTap: ()async {
                 await profileprovider.source(context);
                 if(context.mounted){
                   await profileprovider.upLoadImage(context);
                 }
                },
                child:StreamBuilder(builder: (context, snapshot) {
                  if(snapshot.connectionState==ConnectionState.waiting){
                    return const CircularProgressIndicator();
                  }
                  final data=snapshot.data;
                  return data!['profileUrl']==null? const CircularProgressIndicator(): CircleAvatar(
                  backgroundColor: theme.primaryColor,
                  backgroundImage: CachedNetworkImageProvider(data['profileUrl']),
                  radius: w / 5,
                );
                },stream: getImageUrl(),)),
          ],
        ),
      ),
    );
  }
}
