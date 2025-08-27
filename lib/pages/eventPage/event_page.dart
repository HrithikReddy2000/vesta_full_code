import 'package:flutter/material.dart';
import 'package:projectmercury/models/event.dart';
import 'package:projectmercury/pages/eventPage/event_card.dart';
import 'package:projectmercury/resources/app_state.dart';
import 'package:provider/provider.dart';

class EventPage extends StatelessWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Selector<AppState, List<Event>>(
            selector: (p0, p1) => p1.deployedEvents,
            builder: (_, events, __) {
              if (events.isNotEmpty) {
                return Flexible(
                  child: ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      return EventCard(event: events[index]);
                    },
                  ),
                );
              } else {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'You have no messages yet. Check again later.',
                      style: TextStyle(fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
