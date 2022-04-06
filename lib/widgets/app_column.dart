import 'package:flutter/material.dart';
import 'package:food_delivery_app/utils/colors.dart';
import 'package:food_delivery_app/utils/dimensions.dart';
import 'package:food_delivery_app/widgets/small_text.dart';

import 'big_text.dart';
import 'icon_and_text.dart';

class AppColumn extends StatelessWidget {
  final String text;

  const AppColumn({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BigTextWidget(
          text: text,
          size: Dimensions.font26,
        ),
        SizedBox(
          height: Dimensions.height10,
        ),
        Row(
          children: [
            Wrap(
              children: List.generate(
                5,
                (index) => const Icon(
                  Icons.star,
                  color: AppColors.mainColor,
                  size: 15,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            SmallTextWidget(
              text: '4.5',
            ),
            const SizedBox(
              width: 10,
            ),
            SmallTextWidget(
              text: '1253',
            ),
            const SizedBox(
              width: 10,
            ),
            SmallTextWidget(
              text: 'comments',
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
        SizedBox(
          height: Dimensions.height20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            IconAndTextWidget(
              icon: Icons.circle_sharp,
              iconColor: AppColors.iconColor1,
              text: 'Normal',
            ),
            IconAndTextWidget(
              icon: Icons.location_on,
              iconColor: AppColors.mainColor,
              text: '1.7 km',
            ),
            IconAndTextWidget(
              icon: Icons.access_time_rounded,
              iconColor: AppColors.iconColor2,
              text: '39 min',
            ),
          ],
        ),
      ],
    );
  }
}
