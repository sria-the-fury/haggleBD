import 'package:flutter/material.dart';

class LegendWidget extends StatelessWidget {
  final List productData;
  const LegendWidget({Key? key, required this.productData}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: productData.map(
          (data) => Container(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: buildLegend(
            color: data.color,
            text: data.name,
            // isSquare: true,
          )),
    )
        .toList(),
  );

  Widget buildLegend({
    required Color color,
    required String text,
    bool isSquare = false,
    double size = 16,
    Color textColor = const Color(0xff505050),
  }) =>
      Row(
        children: <Widget>[
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
              color: color,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          )
        ],
      );
}