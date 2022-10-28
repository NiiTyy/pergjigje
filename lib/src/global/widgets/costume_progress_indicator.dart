import 'package:flutter/material.dart';
import 'package:pergjigje/src/global/constants/colors.dart';

class CostumeProgressIndicator extends StatelessWidget {
  const CostumeProgressIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: AppColors.progresIndicatorColor,
      ),
    );
  }
}
