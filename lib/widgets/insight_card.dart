import 'package:flutter/material.dart';

class InsightCard extends StatelessWidget {
  const InsightCard({
    Key? key,
    required this.title,
    required this.isExpandable,
    this.subtitle,
  }) : super(key: key);

  final String title;
  final String? subtitle;
  final bool isExpandable;
  // TODO: Include chart-related data

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: 350,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          const Radius.circular(10),
        ),
        color: Theme.of(context).cardColor,
      ),
      margin: const EdgeInsets.only(bottom: 40),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                if (isExpandable)
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_right),
                    color: Colors.white,
                  ),
              ],
            ),
            if (subtitle != null)
              Text(
                subtitle!,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
              ),
            Container(
              height: 125,
              child: Center(
                child: Text('Chart placeholder!'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
