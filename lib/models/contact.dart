import 'package:flutter/material.dart';
import 'package:projectmercury/data/contact_data.dart';

enum ContactType { utility, individual, organization }

class Contact {
  final Relationship relation;
  final IconData? icon;
  final String name;
  final String relationship;
  final String? phoneNumber;
  final String? email;
  final List<String> description;
  final ContactType type;
  const Contact({
    required this.relation,
    this.icon,
    required this.name,
    required this.relationship,
    this.phoneNumber,
    this.email,
    required this.description,
    this.type = ContactType.individual,
  });

  Map<String, dynamic> toJson() {
    return ({
      'name': name,
      'relationship': relationship,
    });
  }

  static Contact fromSnap(Map<String, dynamic> snap) {
    return contacts.firstWhere((contact) => contact.name == snap['name'],
        orElse: () => tempContact);
  }

  static Contact fromName(String name) {
    return contacts.firstWhere((contact) => contact.name == name,
        orElse: () => tempContact);
  }
}
