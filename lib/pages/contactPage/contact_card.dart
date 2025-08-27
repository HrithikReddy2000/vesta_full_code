import 'package:flutter/material.dart';
import 'package:projectmercury/utils/utils.dart';
import 'package:projectmercury/models/contact.dart';

class ContactCard extends StatelessWidget {
  final Contact contact;
  const ContactCard({
    Key? key,
    required this.contact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        child: Container(
          decoration: elevatedCardDecor(context),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(contact.icon, size: 50),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            contact.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            contact.relationship,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                contact.phoneNumber != null
                    ? listItem(
                        leftMargin: 58,
                        textSize: 20,
                        text: contact.phoneNumber ?? '',
                      )
                    : Container(),
                contact.email != null
                    ? listItem(
                        leftMargin: 58,
                        textSize: 20,
                        text: contact.email ?? '',
                      )
                    : Container(),
              ],
            ),
          ),
        ),
        onTap: () => animatedDialog(
          context: context,
          duration: 250,
          widget: mainDialog(
            context,
            header: Container(),
            body: Column(
              children: [
                const SizedBox(height: 8),
                Icon(
                  contact.icon,
                  size: 50,
                ),
                Text(
                  contact.name,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '(${contact.relationship})',
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                const Divider(),
                contact.phoneNumber != null
                    ? listItem(
                        leftMargin: 25,
                        textSize: 25,
                        text: 'Phone #: ${contact.phoneNumber ?? ''}',
                      )
                    : Container(),
                contact.email != null
                    ? listItem(
                        leftMargin: 25,
                        textSize: 25,
                        text: 'Email: ${contact.email ?? ''}',
                      )
                    : Container(),
                for (String s in contact.description) ...[
                  listItem(leftMargin: 25, textSize: 25, text: s),
                  const SizedBox(height: 5),
                ],
                const SizedBox(height: 12),
              ],
            ),
            footer: Container(),
          ),
        ),
      ),
    );
  }
}
