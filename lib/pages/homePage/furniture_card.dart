import 'package:flutter/material.dart';
import 'package:projectmercury/models/furniture.dart';
import 'package:projectmercury/pages/homePage/isometric.dart';

class FurnitureCard extends StatelessWidget {
  final Furniture furniture;
  final Slot? slot;

  const FurnitureCard({
    Key? key,
    required this.furniture,
    this.slot,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: furniture.left ?? slot?.left ?? 0.0,
      right: furniture.right ?? slot?.right ?? 0.0,
      child: Actor(
        alignment: Alignment.center,
        child: furniture.direction != Direction.none
            ? Image.asset(
                'assets/furniture/${furniture.name}_${furniture.direction.name.toUpperCase()}.png',
                height: furniture.height ?? slot?.height ?? 100.0,
              )
            : Image.asset(
                'assets/furniture/${furniture.name}.png',
                height: furniture.height ?? slot?.height ?? 100.0,
              ),
      ),
    );
  }
}

/// Creates a card to display furniture.
