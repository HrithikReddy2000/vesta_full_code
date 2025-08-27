import 'package:flutter/material.dart';
import 'package:projectmercury/pages/homePage/room.dart';
import 'package:projectmercury/resources/app_state.dart';
import 'package:projectmercury/resources/firestore_methods.dart';
import 'package:projectmercury/resources/locator.dart';
import 'package:projectmercury/resources/time_controller.dart';
import 'package:provider/provider.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    final TimerController timer = locator.get<TimerController>();
    final FirestoreMethods firestore = locator.get<FirestoreMethods>();

    return ChangeNotifierProvider.value(
      value: timer,
      child: Scaffold(
        body: SizedBox(
          width: double.infinity,
          child: Consumer<AppState>(builder: (_, event, __) {
            int session = event.session;
            Room? sessionRoom = event.sessionRoom;
            List<int> roomProgress = event.roomProgress;
            List<int> eventProgress = event.eventProgress;
            double progress = event.sessionProgress;
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Consumer<TimerController>(
                  builder: (_, timer, __) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Total time on app:',
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              timer.totalTime,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                Column(
                  children: [
                    Text(
                      session > event.rooms.length
                          ? 'Game Progress'
                          : 'Session $session Progress',
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 12),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.grey,
                            value: session > event.rooms.length ? 1 : progress,
                            strokeWidth: 10,
                          ),
                        ),
                        Text(
                          session > event.rooms.length
                              ? '100%'
                              : '${(progress * 100).round()}%',
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text('Checklist:'),
                    if (session > event.rooms.length) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (sessionRoom != null) ...[
                            const Icon(Icons.check_box_outlined),
                            const Text('Furnish you home'),
                          ],
                        ],
                      ),
                    ] else ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (sessionRoom != null) ...[
                            roomProgress[0] == roomProgress[1]
                                ? const Icon(Icons.check_box_outlined)
                                : const Icon(Icons.check_box_outline_blank),
                            Text(
                                'Fully furnish ${sessionRoom.name}: ${roomProgress.join('/')}'),
                          ],
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (sessionRoom != null) ...[
                            eventProgress[0] == eventProgress[1]
                                ? const Icon(Icons.check_box_outlined)
                                : const Icon(Icons.check_box_outline_blank),
                            Text(
                                'Respond to messages: ${eventProgress.join('/')}'),
                          ],
                        ],
                      ),
                      // Make sure all transactions and events are completed
                      if (event.sessionProgress >= .98) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            event.sessionProgress == 1
                                ? const Icon(Icons.check_box_outlined)
                                : const Icon(Icons.check_box_outline_blank),
                            const Text(
                                'Wrap up (Complete all transactions and events)'),
                          ],
                        ),
                      ],
                    ],
                  ],
                ),
                Column(
                  children: [
                    if (locator.get<AppState>().session <=
                        locator.get<AppState>().rooms.length) ...[
                      ElevatedButton(
                        onPressed: progress == 1
                            ? () async {
                                await firestore.incrementSession();
                              }
                            : null,
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Complete Session',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ] else ...[
                      const Text(
                        'Congratulations!',
                        style: TextStyle(fontSize: 20),
                      ),
                      const Text(
                        'Your home is fully furnished.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                    const SizedBox(height: 12),
                  ],
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
