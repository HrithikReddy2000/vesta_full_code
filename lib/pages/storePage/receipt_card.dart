import 'package:flutter/material.dart';
import 'package:projectmercury/models/store_item.dart';
import 'package:projectmercury/utils/utils.dart';

class ReceiptCard extends StatelessWidget {
  final PurchasedItem purchasedItem;
  const ReceiptCard({required this.purchasedItem, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/furniture/${purchasedItem.item}.png',
                errorBuilder: (context, _, stacktrace) {
                  return Image.asset(
                    'assets/furniture/${purchasedItem.item}_NE.png',
                    height: 75,
                    errorBuilder: (context, _, stacktrace) {
                      return Image.asset(
                        'assets/furniture/${purchasedItem.item}_NW.png',
                        height: 75,
                      );
                    },
                  );
                },
                height: 75,
              ),
              Flexible(
                child: Column(
                  children: [
                    Text(
                      purchasedItem.name,
                      style: const TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      purchasedItem.seller.real,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      purchasedItem.timeBought.toString(),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Text(formatCurrency.format(purchasedItem.price),
                  style: const TextStyle(fontSize: 28)),
            ],
          ),
        ],
      ),
    );
  }
}
