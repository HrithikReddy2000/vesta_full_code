import 'package:flutter/material.dart';
import 'package:projectmercury/pages/homePage/isometric.dart';
import 'package:projectmercury/pages/homePage/room.dart';
import 'package:projectmercury/resources/app_state.dart';
import 'package:projectmercury/resources/locator.dart';
import 'package:projectmercury/utils/utils.dart';
import 'package:provider/provider.dart';

class FloorPlan extends StatefulWidget {
  final Function callback;
  const FloorPlan(this.callback, {Key? key}) : super(key: key);

  @override
  State<FloorPlan> createState() => _FloorPlanState();
}

class _FloorPlanState extends State<FloorPlan> with TickerProviderStateMixin {
  // For testing, allow rooms to be tapped at any time
  bool testing = false;

  @override
  Widget build(BuildContext context) {
    final List<Room> rooms = [
      locator.get<AppState>().getRoom("living room"),
      locator.get<AppState>().getRoom("bedroom"),
      locator.get<AppState>().getRoom("bathroom"),
      locator.get<AppState>().getRoom("dining room"),
      locator.get<AppState>().getRoom("garage"),
      locator.get<AppState>().getRoom("kitchen"),
    ];
    double homeWidth =
        rooms[0].length + rooms[1].length + rooms[2].length + rooms[0].height;
    double homeHeight = rooms[1].width + rooms[5].width + rooms[1].height;
    return Center(
      child: IsometricView(
        child: SizedBox(
          width: homeWidth,
          height: homeHeight,
          child: Stack(
            children: [
              /*Garage*/
              Positioned(
                right: 0,
                bottom: 0 + rooms[0].width,
                child: _buildRoom(rooms[4]),
              ),

              /*Kitchen*/
              Positioned(
                right: rooms[4].length,
                bottom: 0 + rooms[0].width,
                child: _buildRoom(rooms[5]),
              ),

              /*Diningroom*/
              Positioned(
                right: rooms[5].length + rooms[4].length,
                bottom: 0 + rooms[0].width,
                child: _buildRoom(rooms[3]),
              ),

              /*Bathroom*/
              Positioned(
                bottom: 0,
                right: 0,
                child: _buildRoom(rooms[2]),
              ),

              /*Bedroom*/
              Positioned(
                bottom: 0,
                right: rooms[2].length,
                child: _buildRoom(rooms[1]),
              ),

              /*Livingroom*/
              Positioned(
                bottom: 0,
                right: rooms[2].length + rooms[1].length,
                child: _buildRoom(rooms[0]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  late Animation<double> _animation;
  late AnimationController _controller;
  @override
  initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1200), vsync: this)
      ..repeat(reverse: true);
    _animation = Tween<double>(begin: 20.0, end: 60.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
      /* reverseCurve: Curves.easeIn, */
    ))
      ..addListener(
        () {
          if (_controller.isCompleted) {
            _controller.reverse();
          }
        },
      );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildRoom(Room room) {
    int session = locator.get<AppState>().session;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => setState(
        () {
          bool isActiveRoom = session >= room.unlockOrder;
          if (testing || isActiveRoom) {
            widget.callback.call(room);
          }
          debugPrint(room.name);
        },
      ),
      child: Actor(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            room,
            Selector<AppState, int>(
              builder: (_, session, __) {
                if (session < room.unlockOrder) {
                  return const Icon(
                    Icons.lock,
                    size: 65,
                    color: Color.fromARGB(127, 0, 0, 0),
                  );
                } else if (session == room.unlockOrder &&
                    locator.get<AppState>().sessionProgress != 1) {
                  return AnimatedArrow(
                    animation: _animation,
                  );
                } else {
                  return Container();
                }
              },
              selector: (p0, p1) => p1.session,
            ),
          ],
        ),
      ),
    );
  }
}
