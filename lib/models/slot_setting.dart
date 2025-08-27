import 'package:projectmercury/models/store_item.dart';

class SlotSetting {
  final num overchargeRate;
  final bool doubleCharge;
  final bool wrongSlotItem;
  final StoreItem? randomItem;
  final StoreItem? falseCharge;
  final bool scamStore;
  final bool scamStoreDuplicate;
  final List<int> delayEvent;
  final List<int> doubleAfterEvent;
  const SlotSetting({
    this.overchargeRate = 0,
    this.doubleCharge = false,
    this.wrongSlotItem = false,
    this.randomItem,
    this.falseCharge,
    this.scamStore = false,
    this.scamStoreDuplicate = false,
    this.delayEvent = const [],
    this.doubleAfterEvent = const [],
  });
}
