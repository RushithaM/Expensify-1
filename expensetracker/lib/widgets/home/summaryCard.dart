import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget summary(context, String emoji, String title, double amount, String dir) {
  return Container(
    height: 170,
    decoration: BoxDecoration(
      border: Border.all(color: Color(0xFFE0E4F5), width: 3),
      borderRadius: BorderRadius.circular(8.0),
    ),
    width: ((MediaQuery.of(context).size.width - 40) / 2) - 5,
    child: Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji,
              style: TextStyle(
                fontSize: 32,
                color: Color(0xFF3C3C3C),
                fontWeight: FontWeight.w400,
              )),
          SizedBox(height: 7),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/icons/home/triangle${dir}.svg',
                  width: 20, height: 20),
              SizedBox(width: 7),
              Text(title,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF3C3C3C),
                    fontWeight: FontWeight.w400,
                  ))
            ],
          ),
          SizedBox(height: 5),
          Text(
              "₹ ${(amount >= 10000000) ? amount.toInt() : amount.toStringAsFixed(2)}",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ))
        ],
      ),
    ),
  );
}
