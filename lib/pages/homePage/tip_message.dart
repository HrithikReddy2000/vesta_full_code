import 'package:projectmercury/resources/app_state.dart';
import 'package:projectmercury/resources/locator.dart';
import 'package:flutter/material.dart';

List<InlineSpan>? tipMessage() {
  final event = locator.get<AppState>();
  if (!event.showTip) {
    return null;
  }
  if (event.showBadge[0]) {
    if (event.purchasedItems.isEmpty) {
      if (event.currentRoom == null) {
        return [
          const TextSpan(
              text: "Welcome to Vesta! Click on the room below to start.")
        ];
      } else {
        return [
          const TextSpan(
              text:
                  "Let's start your first purchase! Click on the oulined object(s) below to get started.")
        ];
      }
    } else {
      if (event.currentRoom == null) {
        return [
          const TextSpan(text: "Click on a room to continue furnishing.")
        ];
      } else {
        return [
          const TextSpan(
              text:
                  "You are ready to make your next purchase. Click on the outlined object(s) below.")
        ];
      }
    }
  } else if (event.showBadge[1]) {
    return [
      const TextSpan(text: "You have a new transaction. Go to the"),
      const WidgetSpan(child: Icon(Icons.attach_money)),
      const TextSpan(text: "tab to check it out."),
    ];
  } else if (event.showBadge[3]) {
    if (event.actionNeededEvent != null) {
      String title = event.actionNeededEvent!.title;
      if (title.startsWith('Receipt')) {
        return [
          const TextSpan(text: "You have puchased an item. Go to the "),
          const WidgetSpan(child: Icon(Icons.mail)),
          const TextSpan(text: " tab to check out the receipt."),
        ];
      } else {
        return [
          const TextSpan(text: "You have a new mail. Go to the "),
          const WidgetSpan(child: Icon(Icons.mail)),
          const TextSpan(text: " tab to check it out."),
        ];
      }
    }
  } else if (event.showBadge[4]) {
    if (event.sessionRoom != null
        ? event.sessionRoom!.unlockOrder != event.rooms.length
        : false) {
      return [
        TextSpan(
            text:
                "Your ${event.sessionRoom!.name} is fully furnished. Go to the "),
        const WidgetSpan(child: Icon(Icons.info)),
        const TextSpan(text: " tab to unlock your next room!"),
      ];
    } else {
      return [
        const TextSpan(
            text:
                "Congratulations! You have completed the VESTA app. Thank you for playing!!!")
      ];
    }
  } else {
    return null;
  }
  return null;
}
