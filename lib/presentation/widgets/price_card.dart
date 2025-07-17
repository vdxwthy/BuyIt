import 'package:flutter/material.dart';


// TODO Сделать адаптив в будущем:)))
class PriceCard extends StatelessWidget {
  const PriceCard({super.key, required this.price, this.fractional = "00", this.unit = "₽"});
  final String price;
  final String fractional;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          price,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Transform.translate(
              offset: const Offset(0, 3), 
              child: Text(
                fractional,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -3), 
              child: Text(
                unit,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}