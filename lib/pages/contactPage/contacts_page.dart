import 'package:flutter/material.dart';
import 'package:projectmercury/data/contact_data.dart';

import 'contact_card.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    contacts.sort(
      (a, b) => a.name.compareTo(b.name),
    );
    return Scaffold(
      body: Column(
        children: [
          Flexible(
            child: Scrollbar(
              child: ListView.builder(
                itemBuilder: (context, index) => ContactCard(
                  contact: contacts[index],
                ),
                itemCount: contacts.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
