import 'package:cloud_firestore/cloud_firestore.dart';

class StoreItem {
  final String name;
  final num price;
  final String item;
  final Seller seller;
  const StoreItem({
    this.name = '',
    this.price = 0,
    this.item = '',
    this.seller = Seller.unknown,
  });

  Map<String, dynamic> toJson() {
    return ({
      'name': name,
      'price': price,
      'item': item,
      'seller': seller.name,
    });
  }

  static StoreItem fromSnap(Map<String, dynamic> snap) {
    return StoreItem(
      name: snap['name'],
      price: snap['price'],
      item: snap['item'],
      seller: Seller.values.byName(snap['seller']),
    );
  }
}

class PurchasedItem extends StoreItem {
  String id;
  String? room;
  int? slotID;
  int? priceRank;
  DateTime? timeBought;
  final bool delivered;

  PurchasedItem({
    name = '',
    price = 0,
    item = '',
    seller = Seller.unknown,
    this.id = '',
    this.slotID,
    this.room = '',
    this.priceRank,
    this.timeBought,
    this.delivered = true,
  }) : super(
          name: name,
          price: price,
          item: item,
          seller: seller,
        );

  @override
  Map<String, dynamic> toJson() {
    return ({
      'id': id,
      'name': name,
      'price': price,
      'item': item,
      'seller': seller.name,
      'slotID': slotID,
      'room': room,
      'priceRank': priceRank,
      'timeBought': timeBought,
      'delivered': delivered,
    });
  }

  static PurchasedItem fromSnap(Map<String, dynamic> snap) {
    return PurchasedItem(
      id: snap['id'] ?? '',
      name: snap['name'],
      price: snap['price'],
      item: snap['item'],
      seller: Seller.values.byName(snap['seller']),
      slotID: snap['slotID'],
      room: snap['room'],
      priceRank: snap['priceRank'],
      timeBought: snap['timeBought'] != null
          ? (snap['timeBought'] as Timestamp).toDate()
          : null,
      delivered: snap['delivered'] ?? true,
    );
  }
}

enum Seller {
  unknown,
  furnitureDunRyte,
  fineFurnitureImports,
  angelsHouseholdAppliances,
  maggiesFurnitureDepot,
  theFurnitureSpot,
  gustavesDesigns,
  furnitureYourWay,
  matildaMaes,
  futureFurniture,
  meublesdeMoreau,
  centralOutletFurniture,
  marcelasAntiques,
  theMusicCenter,
  topNotchContractors,
  amirsEclectics,
  homePatioAndLawn,
  furnitureClassics,
  modernElectronicsAndMore,
  donsPawnshop,
  phillipesFurniture,
  furnitureNow,
  belmirasDesigns,
  nyalasAntiques,
  jiaHuisFurnitureDepot,
  parthsLocalFurniture,
  ellesElectronicEclectics,
  tinasToysForTinyTots,
  deansConnectionServices,
  secondhandFurniture,
}

extension SellerExtension on Seller {
  String get real {
    switch (this) {
      case Seller.amirsEclectics:
        return "Amir's Eclectics";
      case Seller.donsPawnshop:
        return "Don's Pawn Shop";
      case Seller.fineFurnitureImports:
        return 'Fine Furniture Imports';
      case Seller.furnitureYourWay:
        return 'Furniture Your Way';
      case Seller.furnitureClassics:
        return 'Furniture Classics';
      case Seller.furnitureDunRyte:
        return 'Furniture Dun Ryte';
      case Seller.furnitureNow:
        return 'Furniture Now';
      case Seller.futureFurniture:
        return 'Future Furniture';
      case Seller.gustavesDesigns:
        return "Gustave's Designs";
      case Seller.homePatioAndLawn:
        return 'Home Patio and Lawn';
      case Seller.jiaHuisFurnitureDepot:
        return "Jia Hui's Furniture Depot";
      case Seller.maggiesFurnitureDepot:
        return "Maggie's Furniture Depot";
      case Seller.marcelasAntiques:
        return "Marcela's Antiques";
      case Seller.matildaMaes:
        return "Furniture and Other Oddities by Matilda Maes";
      case Seller.meublesdeMoreau:
        return 'Meubles de Moreau';
      case Seller.modernElectronicsAndMore:
        return 'Modern Electronics and More';
      case Seller.phillipesFurniture:
        return "Phillipe's Furniture";
      case Seller.centralOutletFurniture:
      //old
      case Seller.secondhandFurniture:
        return 'Central Outlet Furniture';
      case Seller.theFurnitureSpot:
        return 'The Furniture Spot';
      case Seller.theMusicCenter:
        return 'Current Music Center';
      case Seller.topNotchContractors:
        return 'Top Notch Contractors';
      case Seller.belmirasDesigns:
        return "Belmira's Designs";
      case Seller.nyalasAntiques:
        return "Nyala's Antiques";
      case Seller.parthsLocalFurniture:
        return "Parth's Local Furniture";
      case Seller.angelsHouseholdAppliances:
        return "Angel's Household Appliances and Electronics";
      case Seller.ellesElectronicEclectics:
        return "Elle's Electronic Eclectics";
      case Seller.tinasToysForTinyTots:
        return "Tina's Toys for Tiny Tots";
      case Seller.deansConnectionServices:
        return "Dean's Connection Services";
      default:
        return 'Unknown Store';
    }
  }

  String get fake {
    switch (this) {
      case Seller.furnitureDunRyte:
        return 'Furniture Dun Now';
      case Seller.marcelasAntiques:
        return "Marabelle's Antiques";
      case Seller.modernElectronicsAndMore:
        return "Modern Electronics Now";
      case Seller.topNotchContractors:
        return "Top Dollar Contractors";
      case Seller.centralOutletFurniture:
        return "Eastern Outlet Furniture";
      case Seller.jiaHuisFurnitureDepot:
        return "Jean Han's Furniture Depot";
      case Seller.nyalasAntiques:
        return "Nara's Antiques";
      case Seller.furnitureYourWay:
        return "Furniture On Your Time";
      default:
        return 'Suspicious Store';
    }
  }
}
