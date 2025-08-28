import 'dart:math';
import 'package:projectmercury/models/furniture.dart';
import 'package:projectmercury/models/store_item.dart';
import 'package:projectmercury/models/transaction.dart';
import 'package:projectmercury/data/store_data.dart';
import 'package:projectmercury/resources/app_state.dart';
import 'package:projectmercury/resources/locator.dart';

import '../utils/utils.dart';

List<int> depositAmount = [
  16000,
  12000,
  8500,
  19000,
  11000,
  9000,
];

// Transactions
Transaction initialTransaction({int? session}) => Transaction(
      id: session == null
          ? getRoomInit(locator.get<AppState>().rooms[0].name)
          : getRoomInit(locator.get<AppState>().rooms[session - 1].name),
      description: session == null
          ? 'Initial Deposit'
          : 'Deposit for furnishing ${locator.get<AppState>().rooms[session - 1].name}.',
      amount: session == null ? depositAmount[0] : depositAmount[session - 1],
      timeStamp: DateTime.now(),
      initialState: TransactionState.approved,
      type: TransactionType.deposit,
    );

Transaction itemTransaction(
  StoreItem item,
  Slot slot,
  String itemId,
  String? eventId,
) {
  bool delay = eventId != null;
  if (slot.setting.scamStore) {
    return Transaction(
      description: 'Purchased ${item.name} from ${item.seller.fake}',
      amount: -item.price,
      initialState:
          delay ? TransactionState.pending : TransactionState.actionNeeded,
      isScam: true,
      linkedEventId: eventId,
      type: TransactionType.falseChargeHard,
      transactionOnDispute: [
        Transaction(
          description: 'Refund for fake item',
          amount: item.price,
          initialState: TransactionState.approved,
          type: TransactionType.refund,
        ),
      ],
      transactionOnResolved: [
        Transaction(
          description: 'Purchased ${item.name} from ${item.seller.real}',
          amount: -item.price,
          linkedItemId: itemId,
          type: TransactionType.legit,
        ),
      ],
    );
  }
  if (slot.setting.scamStoreDuplicate) {
    return Transaction(
      description: 'Purchased ${item.name} from ${item.seller.real}',
      amount: -item.price,
      initialState:
          delay ? TransactionState.pending : TransactionState.actionNeeded,
      linkedItemId: itemId,
      linkedEventId: eventId,
      type: TransactionType.legit,
      transactionOnResolved: [
        Transaction(
          description: 'Purchased ${item.name} from ${item.seller.fake}',
          amount: -item.price,
          isScam: true,
          type: TransactionType.wrongItemHard,
          transactionOnDispute: [
            Transaction(
              description: 'Refund for fake item',
              amount: item.price,
              initialState: TransactionState.approved,
              type: TransactionType.refund,
            ),
          ],
        ),
      ],
    );
  }
  if (slot.setting.wrongSlotItem) {
    late StoreItem wrongItem;
    int itemIndex =
        slot.acceptables.indexWhere((element) => element.name == item.item);
    if (itemIndex < slot.acceptables.length - 1) {
      itemIndex++;
    } else {
      itemIndex--;
    }
    if (itemIndex < 0) {
      List<StoreItem> randomItems =
          storeItems.where((element) => element.name != item.name).toList();
      wrongItem = randomItems[Random().nextInt(randomItems.length)];
    } else {
      wrongItem = storeItems.firstWhere(
          (element) => element.item == slot.acceptables[itemIndex].name);
    }
    return Transaction(
      description: 'Purchased ${wrongItem.name} from ${wrongItem.seller.real}',
      amount: -wrongItem.price,
      initialState:
          delay ? TransactionState.pending : TransactionState.actionNeeded,
      isScam: true,
      linkedEventId: eventId,
      type: TransactionType.wrongItemHard,
      transactionOnDispute: [
        Transaction(
          description: 'Refund for wrong item',
          amount: wrongItem.price,
          initialState: TransactionState.approved,
          type: TransactionType.refund,
        ),
      ],
      transactionOnResolved: [
        Transaction(
          description: 'Purchased ${item.name} from ${item.seller.real}',
          amount: -item.price,
          linkedItemId: itemId,
          type: TransactionType.legit,
        ),
      ],
    );
  }
  if (slot.setting.randomItem != null) {
    StoreItem wrongItem = slot.setting.randomItem!;
    return Transaction(
      description: 'Purchased ${wrongItem.name} from ${wrongItem.seller.real}',
      amount: -wrongItem.price,
      initialState:
          delay ? TransactionState.pending : TransactionState.actionNeeded,
      linkedEventId: eventId,
      isScam: true,
      type: TransactionType.wrongItemEasy,
      transactionOnDispute: [
        Transaction(
          description: 'Refund for wrong item',
          amount: wrongItem.price,
          initialState: TransactionState.approved,
          type: TransactionType.refund,
        ),
      ],
      transactionOnResolved: [
        Transaction(
          description: 'Purchased ${item.name} from ${item.seller.real}',
          amount: -item.price,
          linkedItemId: itemId,
          type: TransactionType.legit,
        ),
      ],
    );
  }
  if (slot.setting.falseCharge != null) {
    StoreItem wrongItem = slot.setting.falseCharge!;
    return Transaction(
      description: 'Purchased ${item.name} from ${item.seller.real}',
      amount: -item.price,
      initialState:
          delay ? TransactionState.pending : TransactionState.actionNeeded,
      linkedItemId: itemId,
      linkedEventId: eventId,
      type: TransactionType.legit,
      transactionOnResolved: [
        Transaction(
          description:
              'Purchased ${wrongItem.name} from ${wrongItem.seller.real}',
          amount: -wrongItem.price,
          isScam: true,
          type: TransactionType.falseChargeEasy,
          transactionOnDispute: [
            Transaction(
              description: 'Refund for false charge',
              amount: wrongItem.price,
              initialState: TransactionState.approved,
              type: TransactionType.refund,
            ),
          ],
        ),
      ],
    );
  }
  if (slot.setting.overchargeRate != 0) {
    return Transaction(
      description: 'Purchased ${item.name} from ${item.seller.real}',
      amount: -(item.price * (1 + slot.setting.overchargeRate)),
      isScam: true,
      initialState:
          delay ? TransactionState.pending : TransactionState.actionNeeded,
      linkedItemId: itemId,
      linkedEventId: eventId,
      type: slot.setting.overchargeRate < .375
          ? TransactionType.overchargeEasy
          : TransactionType.overchargeHard,
      transactionOnDispute: [
        Transaction(
          description: 'Refund for overcharge',
          amount: item.price * slot.setting.overchargeRate,
          initialState: TransactionState.approved,
          type: TransactionType.refund,
        ),
      ],
    );
  }
  if (slot.setting.doubleCharge) {
    return Transaction(
      description: 'Purchased ${item.name} from ${item.seller.real}',
      amount: -(item.price),
      initialState:
          delay ? TransactionState.pending : TransactionState.actionNeeded,
      linkedEventId: eventId,
      type: TransactionType.legit,
      transactionOnResolved: [
        Transaction(
          description: 'Purchased ${item.name} from ${item.seller.real}',
          amount: -(item.price),
          isScam: true,
          linkedItemId: itemId,
          type: TransactionType.dupChargeEasy,
          transactionOnDispute: [
            Transaction(
              description: 'Refund for double charge',
              amount: item.price,
              initialState: TransactionState.approved,
              type: TransactionType.refund,
            ),
          ],
        ),
      ],
    );
  }
  if (slot.setting.doubleAfterEvent.isNotEmpty) {
    return Transaction(
      description: 'Purchased ${item.name} from ${item.seller.real}',
      amount: -(item.price),
      initialState:
          delay ? TransactionState.pending : TransactionState.actionNeeded,
      linkedEventId: eventId,
      linkedItemId: itemId,
      eventOnResolved: slot.setting.doubleAfterEvent,
      type: TransactionType.legit,
      transactionOnResolved: [
        Transaction(
          description: 'Purchased ${item.name} from ${item.seller.real}',
          initialState: TransactionState.pending,
          amount: -(item.price),
          isScam: true,
          type: TransactionType.dupChargeHard,
          transactionOnDispute: [
            Transaction(
              description: 'Refund for double charge',
              amount: item.price,
              initialState: TransactionState.approved,
              type: TransactionType.refund,
            ),
          ],
        ),
      ],
    );
  }
  return Transaction(
    description: 'Purchased ${item.name} from ${item.seller.real}',
    amount: -(item.price),
    initialState:
        delay ? TransactionState.pending : TransactionState.actionNeeded,
    linkedItemId: itemId,
    linkedEventId: eventId,
    type: TransactionType.legit,
  );
}

Transaction? utilityTransaction(int session) {
  switch (session) {
    case 1:
      return Transaction(
        id: 'Bd_Util',
        description:
            'Internet Connection and Modem Installation Fee, One-time charge from Crystal Clear Internet Services',
        amount: -500,
        type: TransactionType.legit,
      );
    case 2:
      return Transaction(
        id: 'LR_Util',
        description:
            'Home Owners\' Insurance, Yearly Service charge from Johnson & Carter Home Insurance Company',
        amount: -500,
        type: TransactionType.legit,
        transactionOnResolved: [
          Transaction(
            description:
                'Home Owners\' Insurance, Yearly Service charge from Johnson & Carter Home Insurance Company',
            amount: -500,
            isScam: true,
            type: TransactionType.dupChargeEasy,
            transactionOnDispute: [
              Transaction(
                description: 'Refund for duplicate charge',
                amount: 500,
                initialState: TransactionState.approved,
                type: TransactionType.refund,
              ),
            ],
          ),
        ],
      );
    case 3:
      return Transaction(
        id: 'Ba_Util',
        description:
            'Home Water Connection and Set-up Services Fee, One-time charge from County Water Services',
        amount: -500,
        type: TransactionType.legit,
      );
    case 4:
      return Transaction(
        id: 'K_Util',
        description:
            'Home Gas and Heating Installation Fee, One-time charge from Jorge\'s Gas and Services',
        amount: -500,
        eventOnResolved: [1021, 1017],
        type: TransactionType.legit,
        transactionOnResolved: [
          Transaction(
            description:
                'Home Gas and Heating Installation Fee, One-time charge from Jorge\'s Gas and Services',
            amount: -500,
            initialState: TransactionState.pending,
            isScam: true,
            type: TransactionType.dupChargeHard,
            transactionOnDispute: [
              Transaction(
                type: TransactionType.refund,
                description: 'Refund for duplicate charge',
                amount: 500,
                initialState: TransactionState.approved,
              ),
            ],
          ),
        ],
      );
    case 5:
      return Transaction(
        id: 'D_Util',
        description:
            'Home Energy Set-up Service Fee, One-time charge from Renewable Energy Resources',
        amount: -500,
        type: TransactionType.legit,
        transactionOnResolved: [
          Transaction(
            description:
                'Monthly Lawn Flamingo Shipment charge from Patios 4 U',
            amount: -500,
            isScam: true,
            type: TransactionType.falseChargeEasy,
            transactionOnDispute: [
              Transaction(
                description: 'Refund for false charge',
                amount: 500,
                initialState: TransactionState.approved,
                type: TransactionType.refund,
              ),
            ],
          ),
        ],
      );
    case 6:
      return Transaction(
        id: 'Ga_Util',
        description:
            'Home Security Set-up Service Fee, Ont-time charge from Local Security Experts',
        amount: -500,
        type: TransactionType.legit,
      );
    default:
      return null;
  }
}
