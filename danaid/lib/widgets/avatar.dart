import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Avatar extends StatelessWidget {
  final double radius;
  final VoidCallback? onTap;

  const Avatar({
    super.key,
    this.radius = 40.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final photoUrl = user?.photoURL;
    final displayName = user?.displayName ?? 'U';
    final firstLetter = displayName.isNotEmpty ? displayName[0].toUpperCase() : 'U';

    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        child: photoUrl != null && photoUrl.isNotEmpty
            ? ClipOval(
                child: CachedNetworkImage(
                  imageUrl: photoUrl,
                  width: radius * 2,
                  height: radius * 2,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => CircleAvatar(
                    radius: radius,
                    child: Text(
                      firstLetter,
                      style: TextStyle(fontSize: radius * 0.6),
                    ),
                  ),
                  errorWidget: (context, url, error) => CircleAvatar(
                    radius: radius,
                    child: Text(
                      firstLetter,
                      style: TextStyle(fontSize: radius * 0.6),
                    ),
                  ),
                ),
              )
            : Text(
                firstLetter,
                style: TextStyle(
                  fontSize: radius * 0.6,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
      ),
    );
  }
}
