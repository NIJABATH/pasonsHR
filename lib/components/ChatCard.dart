import 'package:flutter/material.dart';
import 'package:pasons_HR/Models/MessageDetails.dart';


// import '../../../constants.dart';
import '../Constants.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({
    Key? key,
     required this.messageDetails,
    required this.press,
  }) : super(key: key);

   final MessageDetails messageDetails;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding, vertical: kDefaultPadding * 0.75),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  // backgroundImage: AssetImage(messageDetails.imagePath),
                  // backgroundImage: Image.network(messageDetails.imagePath) as ImageProvider,
                backgroundImage:  'myMarkerThumb' != 'noImage'
                ? NetworkImage(messageDetails.imagePath)
                : AssetImage('assets/images/noImageAvailable.png') as ImageProvider,
                ),
                if (messageDetails.isActive)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 16,
                      width: 16,
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            width: 3),
                      ),
                    ),
                  )
              ],
            ),
            Expanded(
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      messageDetails.groupName,
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 8),
                    Opacity(
                      opacity: 0.64,
                      child: Text(
                        messageDetails.lastMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Opacity(
              opacity: 0.64,
              child: Text(messageDetails.messageTime),
            ),
          ],
        ),
      ),
    );
  }
}