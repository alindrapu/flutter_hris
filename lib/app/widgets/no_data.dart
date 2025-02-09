import 'package:flutter/material.dart';
import 'package:hris/app/styles/styles.dart';

class NoDataWidget extends StatelessWidget {
  final String message;

  const NoDataWidget({Key? key, this.message = 'Tidak ada data'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_rounded,
            size: 80,
            color: Styles.themeLight.withOpacity(0.6),
          ),
          const SizedBox(height: 10),
          Text(
            message,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Styles.themeDark.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "Silakan cek kembali nanti",
            style: TextStyle(
              fontSize: 14,
              color: Styles.themeDark.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}
