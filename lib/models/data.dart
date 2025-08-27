import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projectmercury/models/event.dart';

enum ActionType {
  purchase,
  transaction,
  event,
  progress,
}

class Data {
  String? id;
  String userId;
  String? email;
  ActionType actionType;
  String actionId;
  DateTime time;
  Difficulty? eventLevel;
  int? purchaseRank;
  String? purchaseName;
  bool? userResponse;
  int? pointChange;
  num? balanceChange;
  num? balanceRemaining;
  Data({
    this.id,
    this.email,
    required this.userId,
    required this.actionType,
    required this.actionId,
    this.eventLevel,
    this.purchaseRank,
    this.purchaseName,
    required this.time,
    this.userResponse,
    this.pointChange,
    this.balanceChange,
    this.balanceRemaining,
  });

  Map<String, dynamic> toJson() {
    return ({
      'email': email,
      'userId': userId,
      'actionType': actionType.name,
      'actionId': actionId,
      'time': time,
      'eventLevel': eventLevel?.name,
      'purchaseRank': purchaseRank,
      'purchaseName': purchaseName,
      'userResponse': userResponse,
      'pointChange': pointChange,
      'balanceChange': balanceChange,
      'balanceRemaining': balanceRemaining,
    });
  }

  static Data fromSnap(Map<String, dynamic> snap) {
    return Data(
      id: snap['id'],
      email: snap['email'],
      userId: snap['userId'],
      actionType: ActionType.values.byName(snap['actionType']),
      actionId: snap['actionId'],
      time: (snap['time'] as Timestamp).toDate(),
    );
  }
}
