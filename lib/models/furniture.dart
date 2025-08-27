import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projectmercury/models/slot_setting.dart';
import 'package:projectmercury/models/store_item.dart';
import 'package:projectmercury/data/store_data.dart';

enum Layer { floor, back, middle, front }

/* extension on Layer { */
/*   int compareTo(Layer other) => index.compareTo(other.index); */
/* } */

class PlaceableItem {
  final double? left;
  final double? right;
  final Layer layer;
  final double? height;
  const PlaceableItem({
    this.left,
    this.right,
    this.height,
    this.layer = Layer.floor,
  });
}

enum Direction { sw, se, ne, nw, corner, none }

// Holds data relating to furniture
class Furniture extends PlaceableItem {
  final String name;
  final Direction direction;

  const Furniture({
    required this.name,
    double? left,
    double? right,
    double? height,
    layer = Layer.floor,
    this.direction = Direction.none,
  }) : super(left: left, right: right, height: height, layer: layer);

  String getDirection() {
    String dir = "";
    if (direction == Direction.sw) {
      dir = "_SW";
    } else if (direction == Direction.se) {
      dir = "_SE";
    } else if (direction == Direction.nw) {
      dir = "_NW";
    } else if (direction == Direction.ne) {
      dir = "_NE";
    } else if (direction == Direction.corner) {
      dir = "_CORNER";
    } else {
      dir = "";
    }
    return dir;
  }
}

// Holds data relating to furniture slot
class Slot extends PlaceableItem {
  final String id;
  final int order;
  final List<Furniture> acceptables;
  final String? icon;
  final SlotSetting setting;
  String? item;
  Transaction Function(StoreItem item)? itemEvent;

  Slot({
    required this.id,
    required this.order,
    required this.acceptables,
    required double height,
    required double left,
    required double right,
    layer = Layer.floor,
    /* this.prereq, */
    this.item,
    this.setting = const SlotSetting(),
    this.icon,
    this.itemEvent,
  }) : super(left: left, right: right, height: height, layer: layer);

  set(String? item) {
    this.item = item;
  }

  Furniture? getFurniture(String itemName) {
    if (acceptables.where(((element) => element.name == itemName)).isNotEmpty) {
      return acceptables.singleWhere((element) => element.name == itemName);
    }
    return null;
  } // Sort items by price, and give the ranking of a given item by its price in the slot

  int getItemPriceRank(String itemName) {
    List<StoreItem> si = storeItems
        .where(
            (element) => acceptables.map((e) => e.name).contains(element.item))
        .toList();

    debugPrint(si.length.toString());
    si.sort((a, b) => b.price.compareTo(a.price));
    return si.map((e) => e.item).toList().indexOf(itemName);
  }
}
