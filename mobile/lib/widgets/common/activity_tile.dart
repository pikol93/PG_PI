import "package:flutter/material.dart";

class ActivityTile extends StatelessWidget {
  final String headline;
  final String imagePath;
  final Widget screen;

  const ActivityTile({
    super.key,
    required this.headline,
    required this.imagePath,
    required this.screen,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () async {
          final pendingResult = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );

          if (context.mounted) {
            Navigator.pop(context, pendingResult);
          }
        },
        child: Card(
          elevation: 5,
          child: Column(
            children: [
              Expanded(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(headline),
              ),
            ],
          ),
        ),
      );
}
