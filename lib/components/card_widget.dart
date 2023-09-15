import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:video/utils/Routes/routenames.dart';

class CardWidget extends StatelessWidget {
  final Map<String, dynamic> data;
  const CardWidget({super.key, required this.data});
  

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    String calculateTimeAgo(Timestamp dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime.toDate());

    if (difference.inDays >= 1) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
    final Timestamp dateTime=data['date'];
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, RouteNames.videodetials, arguments: data);
        
      },
      child: Container(
        width: w / 1.2,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          color: Colors.grey,
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  CircleAvatar(backgroundImage: CachedNetworkImageProvider(
                   '${data['imageUrl']}')),
                const Spacer(),
                Text(
                  '${data['title']}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('lat: ${data['location']['latitude']}'),
                    Text('lon: ${data['location']['longitude']}')
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(
                  '${data['name']}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                 Text(
                  calculateTimeAgo(dateTime),
                  style:const TextStyle(color: Colors.black),
                ),
                const Spacer(),
                Text('${data['cateogry']}'),
              ],
            )
          ],
        ),
      ),
    );
  }
}
