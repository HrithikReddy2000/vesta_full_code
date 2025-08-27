import 'package:cloud_firestore/cloud_firestore.dart' as db;

enum TransactionState {
  pending,
  actionNeeded,
  disputed,
  approved,
}

enum TransactionType {
  deposit,
  refund,
  legit,
  overchargeEasy,
  overchargeHard,
  wrongItemEasy,
  wrongItemHard,
  falseChargeEasy,
  falseChargeHard,
  dupChargeEasy,
  dupChargeHard,
}

class Transaction {
  String id;
  final String description;
  final num amount;
  DateTime? timeStamp;
  DateTime? timeActed;
  final TransactionState initialState;
  TransactionState currentState;
  bool hidden;
  final String? linkedItemId;
  final String? linkedEventId;
  final bool isScam;
  final List<Transaction> transactionOnDispute;
  final List<Transaction> transactionOnResolved;
  final List<int> eventOnResolved;
  final TransactionType? type;

  Transaction({
    this.id = '',
    required this.description,
    required this.amount,
    this.hidden = false,
    this.initialState = TransactionState.actionNeeded,
    this.currentState = TransactionState.pending,
    this.timeStamp,
    this.timeActed,
    this.linkedItemId,
    this.linkedEventId,
    this.isScam = false,
    this.transactionOnDispute = const [],
    this.transactionOnResolved = const [],
    this.eventOnResolved = const [],
    this.type,
  });

  Map<String, dynamic> toJson() {
    return ({
      'id': id,
      'description': description,
      'amount': amount,
      'hidden': hidden,
      'initialState': initialState.name,
      'currentState': currentState.name,
      'timeStamp': timeStamp,
      'timeActed': timeActed,
      'isScam': isScam,
      'linkedItemId': linkedItemId,
      'linkedEventId': linkedEventId,
      'transactionOnDispute': tListToJson(transactionOnDispute),
      'transactionOnResolved': tListToJson(transactionOnResolved),
      'eventOnResolved': eventOnResolved,
      'type': type?.name,
    });
  }

  factory Transaction.fromSnap(Map<String, dynamic> snap) {
    List<Transaction> transactionOnDispute = [];
    List<Transaction> transactionOnResolved = [];
    List<int> eventOnResolved = [];
    for (Map<String, dynamic> transaction in snap['transactionOnDispute']) {
      transactionOnDispute.add(Transaction.fromSnap(transaction));
    }
    for (Map<String, dynamic> transaction in snap['transactionOnResolved']) {
      transactionOnResolved.add(Transaction.fromSnap(transaction));
    }
    for (int event in snap['eventOnResolved'] ?? []) {
      eventOnResolved.add(event);
    }
    return Transaction(
      id: snap['id'],
      description: snap['description'],
      amount: snap['amount'],
      hidden: snap['hidden'] ?? false,
      timeStamp: snap['timeStamp'] != null
          ? (snap['timeStamp'] as db.Timestamp).toDate()
          : null,
      timeActed: snap['timeActed'] != null
          ? (snap['timeActed'] as db.Timestamp).toDate()
          : null,
      initialState: TransactionState.values.byName(snap['initialState']),
      currentState: TransactionState.values.byName(snap['currentState']),
      isScam: snap['isScam'] ?? false,
      linkedItemId: snap['linkedItemId'],
      linkedEventId: snap['linkedEventId'],
      transactionOnDispute: transactionOnDispute,
      transactionOnResolved: transactionOnResolved,
      eventOnResolved: eventOnResolved,
      type: snap['type'] != null
          ? TransactionType.values.byName(snap['type'])
          : null,
    );
  }

  static Map<String, dynamic> getJson({
    Transaction? transaction,
    String? id,
    TransactionState? currentState,
    bool? hidden,
    DateTime? timeStamp,
    DateTime? timeActed,
    String? linkedEventId,
  }) {
    Map<String, dynamic> data = {};
    if (transaction != null) {
      data.addAll(transaction.toJson());
    }
    if (id != null) {
      data.addAll({'id': id});
    }
    if (currentState != null) {
      data.addAll({'currentState': currentState.name});
    }
    if (hidden != null) {
      data.addAll({'hidden': hidden});
    }
    if (timeStamp != null) {
      data.addAll({'timeStamp': timeStamp});
    }
    if (timeActed != null) {
      data.addAll({'timeActed': timeActed});
    }
    if (linkedEventId != null) {
      data.addAll({'linkedEventId': linkedEventId});
    }
    return data;
  }

  List<Map<String, dynamic>> tListToJson(List list) {
    List<Map<String, dynamic>> json = [];
    for (Transaction item in list) {
      json.add(item.toJson());
    }
    return json;
  }
}
