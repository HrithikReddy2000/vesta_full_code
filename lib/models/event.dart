import 'package:cloud_firestore/cloud_firestore.dart';

enum Difficulty { easy, hard }

enum EventType { text, email, call, receipt }

enum EventState { actionNeeded, rejected, approved, static }

enum TargetBehavior { none, clickLink, callBack, sendMoney, sendInfo }

class Event {
  String id;
  String sender;
  final String title;
  final EventType type;
  final List dialog;
  Difficulty difficulty;
  TargetBehavior targetBehavior;
  bool isScam;
  bool wasOpened;
  EventState state;
  String? audioPath;
  DateTime? timeSent;
  DateTime? timeActed;
  int? session;
  String? unhideOnResolved;
  bool hidden;

  Event({
    this.id = '',
    this.sender = "stranger",
    required this.title,
    required this.type,
    required this.dialog,
    this.difficulty = Difficulty.easy,
    this.targetBehavior = TargetBehavior.none,
    this.isScam = false,
    this.wasOpened = false,
    this.state = EventState.actionNeeded,
    this.audioPath,
    this.timeSent,
    this.timeActed,
    this.session,
    this.unhideOnResolved,
    this.hidden = false,
  });

  Map<String, dynamic> toJson() {
    return ({
      'id': id,
      'sender': sender,
      'title': title,
      'type': type.name,
      'dialog': dialog,
      'difficulty': difficulty.name,
      'targetBehavior': targetBehavior.name,
      'wasOpened': wasOpened,
      'state': state.name,
      'audioPath': audioPath,
      'isScam': isScam,
      'timeSent': timeSent,
      'timeActed': timeActed,
      'session': session,
      'unHideOnResolved': unhideOnResolved,
      'hidden': hidden,
    });
  }

  static Event fromSnap(Map<String, dynamic> snap) {
    return Event(
      id: snap['id'],
      title: snap['title'],
      sender: snap['sender'],
      type: EventType.values.byName(snap['type'] ?? 'text'),
      dialog: snap['dialog'],
      difficulty: Difficulty.values.byName(snap['difficulty'] ?? 'easy'),
      targetBehavior:
          TargetBehavior.values.byName(snap['targetBehavior'] ?? 'none'),
      wasOpened: snap['wasOpened'] ?? false,
      state: EventState.values.byName(snap['state']),
      audioPath: snap['audioPath'],
      isScam: snap['isScam'],
      timeSent: snap['timeSent'] != null
          ? (snap['timeSent'] as Timestamp).toDate()
          : null,
      timeActed: snap['timeActed'] != null
          ? (snap['timeActed'] as Timestamp).toDate()
          : null,
      session: snap['session'],
      unhideOnResolved: snap['unHideOnResolved'],
      hidden: snap['hidden'] ?? false,
    );
  }

  static Map<String, dynamic> getJson({
    Event? event,
    String? id,
    bool? wasOpened,
    EventState? state,
    String? unhideOnResolved,
    DateTime? timeSent,
    DateTime? timeActed,
    int? session,
    bool? hidden,
  }) {
    Map<String, dynamic> data = {};
    if (event != null) {
      data.addAll(event.toJson());
    }
    if (id != null) {
      data.addAll({'id': id});
    }
    if (wasOpened != null) {
      data.addAll({'wasOpened': wasOpened});
    }
    if (state != null) {
      data.addAll({'state': state.name});
    }
    if (unhideOnResolved != null) {
      data.addAll({'unHideOnResolved': unhideOnResolved});
    }
    if (timeSent != null) {
      data.addAll({'timeSent': timeSent});
    }
    if (timeActed != null) {
      data.addAll({'timeActed': timeActed});
    }
    if (session != null) {
      data.addAll({'session': session});
    }
    if (hidden != null) {
      data.addAll({'hidden': hidden});
    }
    return data;
  }

  Event update({
    String? id,
    DateTime? timeSent,
    int? session,
    String? unhideOnResolved,
    bool? hidden,
  }) {
    this.id = id ?? this.id;
    this.timeSent = timeSent ?? this.timeSent;
    this.session = session ?? this.session;
    this.unhideOnResolved = unhideOnResolved ?? this.unhideOnResolved;
    this.hidden = hidden ?? this.hidden;
    return this;
  }
}
