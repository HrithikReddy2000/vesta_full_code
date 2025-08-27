import 'package:flutter/material.dart';
import 'package:projectmercury/models/furniture.dart';
import 'package:projectmercury/models/slot_setting.dart';
import 'package:projectmercury/models/store_item.dart';
import 'package:projectmercury/models/transaction.dart';

// Holds data relating to furniture slot
class Slot {
  final int id;
  final int? prereq;
  final double height;
  final Offset position;
  final List<Furniture> acceptables;
  final String? visual;
  final SlotSetting setting;
  String? item;
  Transaction Function(StoreItem item)? itemEvent;

  Slot({
    required this.id,
    required this.height,
    required this.acceptables,
    required this.position,
    this.prereq,
    this.item,
    this.setting = const SlotSetting(),
    this.visual,
    this.itemEvent,
  });
  set(String? item) {
    this.item = item;
  }

  get(String itemName) =>
      acceptables.where((element) => element.name == itemName);
}
