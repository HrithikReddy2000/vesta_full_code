import 'package:flutter/material.dart';
import 'package:projectmercury/models/furniture.dart';
import 'dart:math' as math;
import 'package:projectmercury/models/store_item.dart';
import 'package:projectmercury/pages/homePage/furniture_card.dart';
import 'package:projectmercury/pages/homePage/slot_card.dart';
import 'package:projectmercury/pages/homePage/isometric.dart';
import 'package:projectmercury/resources/app_state.dart';
import 'package:projectmercury/resources/locator.dart';
import 'package:provider/provider.dart';

class WallAndFlooringMenu extends StatefulWidget {
  final List<String> options;
  final String label;
  const WallAndFlooringMenu(
      {Key? key, required this.options, required this.label})
      : super(key: key);

  @override
  State<WallAndFlooringMenu> createState() => _WallAndFlooringMenuState();
}

class _WallAndFlooringMenuState extends State<WallAndFlooringMenu> {
  int selected = -1;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.label,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width - 50,
            child: GridView.builder(
              shrinkWrap: false,
              itemCount: 5,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height / 2),
              ),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selected = index;
                      debugPrint(index.toString());
                      Navigator.pop(context, widget.options[index]);
                    });
                  },
                  child: Container(
                    color: selected == index ? Colors.red : Colors.blue,
                    child: SizedBox(
                      width: 150,
                      height: 150,
                      child: Image.asset(
                        'assets/textures/${widget.options[index]}',
                        fit: BoxFit.scaleDown,
                        width: 140,
                        height: 140,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Room extends StatefulWidget {
  final String name;
  final String wallTexture;
  final String floorTexture;
  final int unlockOrder;
  final int deployUtil;
  final double width;
  final double length;
  final double height;
  final bool roomBehind;
  final bool roomBeside;
  final List<PlaceableItem> items;
  const Room({
    Key? key,
    required this.unlockOrder,
    this.deployUtil = 2,
    required this.width,
    required this.length,
    required this.height,
    this.wallTexture = 'Plain Wallpaper Option 6.png',
    this.floorTexture = 'darkPlanks.jpg',
    required this.name,
    this.roomBehind = false,
    this.roomBeside = false,
    this.items = const [],
  }) : super(key: key);

  Iterable<Furniture> get furniture => items.whereType<Furniture>();

  Iterable<Slot> get slots => items.whereType<Slot>();

  // remove slots with duplicate id
  Iterable<Slot> get distinctSlots {
    Map<int, Slot> distinctSlots = {};
    for (Slot slot in slots) {
      distinctSlots.addAll({slot.order: slot});
    }
    return distinctSlots.values;
  }

  Iterable<Slot> get distinctFilledSlots =>
      distinctSlots.where((element) => element.item != null);

  Iterable<Slot> slotsByID(int orderNum) =>
      slots.where((s) => s.order == orderNum);

  Iterable<Slot> filledSlots(int? orderNum) {
    return items.whereType<Slot>().where(
        (s) => s.item != null && (orderNum == null || s.order == orderNum));
  }

  /* Iterable<Slot> filledSlotsById(int orderNum) { */
  /*   return filledSlots.where((element) => element.item != null); */
  /* } */

  // Fill all items matching a given ID with a given item
  void fillSlots(int? orderNum, String? item) {
    slots
        .where((s) => orderNum == null ? true : s.order == orderNum)
        .forEach((s) {
      s.set(item);
    });
  }

  @override
  State<Room> createState() => _RoomState();
}

class _RoomState extends State<Room> {
  final Room? _currentRoom = locator.get<AppState>().currentRoom;

  // List<PlaceableItem> prepareItems(roomItems) {
  //   List<PlaceableItem> placeables = [];
  //   bool shouldShowSlots = false;
  //   if (roomItems.isEmpty) {
  //     shouldShowSlots = true;
  //   } else {
  //     shouldShowSlots =
  //         roomItems.where((element) => element.delivered == false).isEmpty &&
  //             !locator.get<AppState>().waitingTransactionAction() &&
  //             !locator.get<AppState>().waitingEventAction();
  //   }
  //   for (final PlaceableItem o in widget.items) {
  //     if (o is Slot) {
  //       if (o.item != null) {
  //         // Add the first acceptable item that matches the slot's item name
  //         placeables.add(
  //           o.acceptables.firstWhere((element) => element.name == o.item),
  //         );
  //       } else if (_currentRoom != null && o.item == null && shouldShowSlots) {
  //         // Add slot if order is 0 or previous slot is filled
  //         if (o.order == 0 || widget.filledSlots(o.order - 1).isNotEmpty) {
  //           placeables.add(o);
  //         }
  //       }
  //     } else if (o is Furniture) {
  //       placeables.add(o);
  //     }
  //   }
  //   // Sort items according to their layer
  //   placeables.sort(
  //     (a, b) => a.layer.index.compareTo(b.layer.index),
  //   );
  //   return placeables;
  // }
  List<PlaceableItem> prepareItems(List<PlaceableItem> roomItems) {
    List<PlaceableItem> placeables = [];
    bool shouldShowSlots = false;

    // Determine if slots should be shown
    if (roomItems.isEmpty) {
      shouldShowSlots = true;
    } else {
      // Remove 'delivered' reference since PlaceableItem has no such getter
      shouldShowSlots = !locator.get<AppState>().waitingTransactionAction() &&
          !locator.get<AppState>().waitingEventAction();
    }

    for (final PlaceableItem o in widget.items) {
      if (o is Slot) {
        if (o.item != null) {
          // Get the first acceptable item matching the slot's item name
          final matchedItem = o.acceptables.firstWhere(
            (element) => element.name == o.item,
            orElse: () => o.acceptables
                .first, // Fallback to first acceptable item if not found
          );

          placeables.add(matchedItem);
        } else if (_currentRoom != null && shouldShowSlots) {
          // Add slot if order is 0 or previous slot is filled
          if (o.order == 0 || widget.filledSlots(o.order - 1).isNotEmpty) {
            placeables.add(o);
          }
        }
      } else if (o is Furniture) {
        placeables.add(o); // Furniture can always be added
      }
    }

    // Sort items by layer
    placeables.sort((a, b) {
      final aIndex = a.layer.index;
      final bIndex = b.layer.index;
      return aIndex.compareTo(bIndex);
    });

    return placeables;
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: IsometricView(
        child: SizedBox(
          width: widget.length + widget.height,
          height: widget.width + widget.height,
          child: Selector<AppState, List<PurchasedItem>>(
            selector: (p0, p1) => p1.purchasedItems,
            builder: (_, roomItems, __) {
              List<PlaceableItem> furnitureAndSlots =
                  prepareItems(roomItems.cast<PlaceableItem>());
              bool shouldFadeWalls = (_currentRoom == null) &&
                  (locator.get<AppState>().session != widget.unlockOrder);
              bool shouldDarkenRoom =
                  locator.get<AppState>().session < widget.unlockOrder;
              return Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomLeft,
                children: [
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: IgnorePointer(
                      ignoring: shouldFadeWalls,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        /* onLongPress: () { */
                        /*   setState(() { */
                        /*     showModalBottomSheet( */
                        /*       isScrollControlled: true, */
                        /*       backgroundColor: Colors.white, */
                        /*       shape: const RoundedRectangleBorder( */
                        /*         borderRadius: BorderRadius.vertical( */
                        /*           top: Radius.circular(16), */
                        /*         ), */
                        /*       ), */
                        /*       context: context, */
                        /*       builder: (context) { */
                        /*         return WallAndFlooringMenu( */
                        /*             label: "Flooring Options", */
                        /*             options: floorOptions[widget.name]!); */
                        /*       }, */
                        /*     ).then( */
                        /*       (value) => */
                        /*           setState(() => widget.floorTexture = value), */
                        /*     ); */
                        /*   }); */
                        /* }, */
                        child: SizedBox(
                          width: widget.length,
                          height: widget.width,
                          child: Container(
                            decoration: BoxDecoration(
                              border: const Border(
                                left: BorderSide(
                                    width: 2,
                                    color: Color.fromARGB(200, 0, 0, 0)),
                                bottom: BorderSide(
                                    width: 2,
                                    color: Color.fromARGB(200, 0, 0, 0)),
                              ),
                              image: DecorationImage(
                                colorFilter: shouldDarkenRoom
                                    ? const ColorFilter.mode(
                                        Color.fromARGB(130, 0, 0, 0),
                                        BlendMode.darken,
                                      )
                                    : null,
                                image: AssetImage(
                                  'assets/textures/${widget.floorTexture}',
                                ),
                                repeat: ImageRepeat.repeat,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IgnorePointer(
                      ignoring: shouldFadeWalls,
                      child: GestureDetector(
                        behavior: HitTestBehavior.deferToChild,
                        child: Container(
                          width: widget.height,
                          height: widget.width,
                          transform: Matrix4.identity()..rotateY(-math.pi / 2),
                          child: RotatedBox(
                            quarterTurns: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    width: 2,
                                    color: Color.fromARGB(
                                        shouldFadeWalls ? 80 : 255, 0, 0, 0),
                                  ),
                                  top: BorderSide(
                                    width: 2,
                                    color: Color.fromARGB(
                                        shouldFadeWalls ? 80 : 255, 0, 0, 0),
                                  ),
                                  bottom: BorderSide(
                                    width: 2,
                                    color: Color.fromARGB(
                                        shouldFadeWalls ? 80 : 255, 0, 0, 0),
                                  ),
                                ),
                                image: DecorationImage(
                                  alignment: Alignment.topLeft,
                                  opacity: widget.roomBehind && shouldFadeWalls
                                      ? 0.2
                                      : 1.0,
                                  colorFilter: shouldDarkenRoom
                                      ? ColorFilter.mode(
                                          Color.fromARGB(
                                            shouldFadeWalls ? 150 : 200,
                                            0,
                                            0,
                                            0,
                                          ),
                                          BlendMode.darken,
                                        )
                                      : null,
                                  image: AssetImage(
                                    'assets/textures/${widget.wallTexture}',
                                  ),
                                  repeat: ImageRepeat.repeat,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: IgnorePointer(
                      ignoring: shouldFadeWalls,
                      child: GestureDetector(
                        behavior: HitTestBehavior.deferToChild,
                        child: Container(
                          width: widget.length,
                          height: widget.height,
                          transform: Matrix4.identity()..rotateX(-math.pi / 2),
                          transformAlignment: Alignment.bottomCenter,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color.fromARGB(
                                    shouldFadeWalls ? 80 : 255, 0, 0, 0),
                                width: 2,
                              ),
                              image: DecorationImage(
                                alignment: Alignment.topLeft,
                                colorFilter: shouldDarkenRoom
                                    ? ColorFilter.mode(
                                        Color.fromARGB(
                                          shouldFadeWalls ? 150 : 200,
                                          0,
                                          0,
                                          0,
                                        ),
                                        BlendMode.darken,
                                      )
                                    : null,
                                opacity: widget.roomBeside && shouldFadeWalls
                                    ? 0.2
                                    : 1.0,
                                image: AssetImage(
                                  'assets/textures/${widget.wallTexture}',
                                ),
                                repeat: ImageRepeat.repeat,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  for (PlaceableItem item in furnitureAndSlots)
                    item is Slot
                        ? SlotCard(
                            slot: item,
                            roomName: widget.name,
                          )
                        : item is Furniture
                            ? FurnitureCard(
                                furniture: item,
                              )
                            : Container(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
