import 'package:flutter/material.dart';
import 'package:projectmercury/models/contact.dart';

enum Relationship {
  stranger,
  homeOwners,
  energyService,
  gasService,
  internetService,
  waterAndSewerService,
  securityService,
  spouse,
  daughter,
  son,
  brother,
  closeFriend,
  cousin,
  coWorker,
  neighbor,
  religiousFriend,
  accountingFirm,
  bank,
  healthInsurance,
  doctor,
  dentist,
  pharmacy,
  religiousOrganization,
  charityOrganization,
  politicalParty,
}

extension RelationshipExtension on Relationship {
  Contact get contact {
    switch (this) {
      case Relationship.homeOwners:
      case Relationship.energyService:
      case Relationship.gasService:
      case Relationship.internetService:
      case Relationship.waterAndSewerService:
      case Relationship.securityService:
      case Relationship.spouse:
      case Relationship.daughter:
      case Relationship.son:
      case Relationship.brother:
      case Relationship.closeFriend:
      case Relationship.cousin:
      case Relationship.coWorker:
      case Relationship.neighbor:
      case Relationship.religiousFriend:
      case Relationship.accountingFirm:
      case Relationship.bank:
      case Relationship.healthInsurance:
      case Relationship.doctor:
      case Relationship.dentist:
      case Relationship.pharmacy:
      case Relationship.religiousOrganization:
      case Relationship.charityOrganization:
      case Relationship.politicalParty:
        return contacts.firstWhere((element) => element.relation == this);
      case Relationship.stranger:
        return tempContact;
    }
  }
}

const Contact tempContact = Contact(
  relation: Relationship.stranger,
  name: 'Unknown',
  relationship: 'Stranger',
  phoneNumber: 'Unknown number',
  email: 'Unknown email',
  description: ['No information'],
);

List<Contact> contacts = [
  //homeowners
  const Contact(
    relation: Relationship.homeOwners,
    name: 'Johnson & Carter Home Insurance Company',
    relationship: "Home Owner's Insurance Provider",
    description: [
      "Trusted company for homeowner's insurance for your new house.",
      "You have agreed to pay a yearly service charge of \$500 for homeowner's insurance",
      "Trusted source to approve payment for the service charge listed above",
    ],
    type: ContactType.utility,
    icon: Icons.house,
  ),
  //energy service
  const Contact(
    relation: Relationship.energyService,
    name: 'Renewable Energy Resources',
    relationship: 'Energy Service Provider',
    description: [
      'Trusted company for energy for your new house.',
      'You have agreed to pay a one-time fee of \$500 to set up energy services and install connections.',
      'Trusted source to approve payment for the service charge listed above',
    ],
    type: ContactType.utility,
    icon: Icons.bolt,
  ),
  //gas service
  const Contact(
    relation: Relationship.gasService,
    name: "Jorge's Gas and Services",
    relationship: 'Gas Service Provider',
    description: [
      "Trusted company for gas connection for the heating of your new house.",
      "You have agreed to pay a one-time fee of \$500 to install a heater and gas connection",
      'Trusted source to approve payment for the service charge listed above',
    ],
    type: ContactType.utility,
    icon: Icons.gas_meter,
  ),
  //internet service
  const Contact(
    relation: Relationship.internetService,
    name: 'Crystal Clear Internet Services',
    relationship: 'Internet Service Provider',
    description: [
      "Trusted company for internet service for your new house.",
      "You have agreed to pay a one-time fee of \$500 to set up a high-speed internet connection and install epuipment.",
      "Trusted source to approve payment for the service charge listed above",
    ],
    type: ContactType.utility,
    icon: Icons.signal_cellular_alt,
  ),
  //water and sewer service
  const Contact(
    relation: Relationship.waterAndSewerService,
    name: 'County Water Services',
    relationship: 'Water and Sewer Service Provider',
    description: [
      'Trusted company for water services for your new house.',
      'You have agreed to pay a yearly charge of \$500 for water services.',
      'Trusted source to approve payment for the service charge listed above',
    ],
    type: ContactType.utility,
    icon: Icons.water_drop,
  ),
  //security service
  const Contact(
    relation: Relationship.securityService,
    name: 'Local Security Experts',
    relationship: 'Security Service Provider',
    description: [
      "Trusted company for security for your new house.",
      "You have agreed to pay a one-time fee of \$100 to install security equipment.",
      'Trusted source to approve payment for the service charge listed above',
    ],
    type: ContactType.utility,
    icon: Icons.security,
  ),
  //spouse
  const Contact(
    relation: Relationship.spouse,
    name: 'Taylor',
    relationship: 'Spouse',
    phoneNumber: '555-555-9630',
    email: 'taytertots67@gmail.com',
    description: [
      "Trusted with personal information (i.e., household items, family information), financial information (i.e., all bank account information), and access information (i.e., all passwords, house access)",
      "Trusted source for sending money, clicking links, and calling back"
    ],
    type: ContactType.individual,
    icon: Icons.person,
  ),
  //daughter
  const Contact(
    relation: Relationship.daughter,
    name: 'Ericka',
    relationship: 'Daughter',
    phoneNumber: '555-555-2503',
    email: 'erickaintyler96@outlook.com',
    description: [
      'Trusted with personal information (i.e., household items, family information) and access information (i.e., shared family passwords, house access)',
      'Trusted source for sending money, clicking links, and calling back',
    ],
    type: ContactType.individual,
    icon: Icons.person,
  ),
  //son
  const Contact(
    relation: Relationship.son,
    name: 'Jake',
    relationship: 'Son',
    phoneNumber: '555-555-6018',
    email: 'jake_o_lantern8668@yahoo.com',
    description: [
      'Trusted with personal information (i.e., household items, family information) and access information (i.e., shared family passwords, house access)',
      'Trusted source for sending money, clicking links, and calling back',
    ],
    type: ContactType.individual,
    icon: Icons.person,
  ),
  //brother
  const Contact(
    relation: Relationship.brother,
    name: 'Marcus',
    relationship: 'Brother',
    phoneNumber: '555-555-5069',
    email: 'mechmarc42@hotmail.com',
    description: [
      'Trusted with personal information (i.e., household items, family information), financial information (i.e., family bank account information), and access information (i.e., shared family passwords, house access)',
      'Trusted source for sending money, clicking links, and calling back',
    ],
    type: ContactType.individual,
    icon: Icons.person,
  ),
  //close friend
  const Contact(
    relation: Relationship.closeFriend,
    name: 'Ravi Patel',
    relationship: 'Close Friend',
    phoneNumber: '555-555-7175',
    email: 'rpatel67@gmail.com',
    description: [
      'Trusted with personal information (i.e., family information) and house access (i.e., garage code)',
      'Trusted source for sending money, clicking links, and calling back',
    ],
    type: ContactType.individual,
    icon: Icons.person,
  ),
  //cousin
  const Contact(
    relation: Relationship.cousin,
    name: 'Anthony Williams',
    relationship: 'Cousin',
    phoneNumber: '555-555-6101',
    email: 'antwilliams838@aol.com',
    description: [
      'Trusted with personal information (i.e., family information) and house access (i.e., garage code)',
      'Trusted source for sending money, clicking links, and calling back',
    ],
    type: ContactType.individual,
    icon: Icons.person,
  ),
  // coworker
  const Contact(
    relation: Relationship.coWorker,
    name: 'Maurice Romero',
    relationship: 'Coworker',
    phoneNumber: '555-555-1938',
    email: 'maurisimo48@msn.com',
    description: [
      'Trusted with work information (i.e., work events, work financial and legal information)',
      'Trusted source for sending money for work, clicking links, and calling back',
    ],
    type: ContactType.individual,
    icon: Icons.person,
  ),
  //neighbor
  const Contact(
    relation: Relationship.neighbor,
    name: 'Vivian Choi',
    relationship: 'Neighbor',
    phoneNumber: '555-555-8251',
    email: 'vivianchoi1979@gmail.com',
    description: [
      'Trusted with personal information (i.e., contact information, address/neighborhood information) and house access to water plants (i.e., garage code)',
      'Trusted source for clicking links and calling back',
    ],
    type: ContactType.individual,
    icon: Icons.person,
  ),
  //religious friends
  const Contact(
    relation: Relationship.religiousFriend,
    name: 'Jayden Johnson',
    relationship: 'Friend from Autumn Falls Religious Community',
    phoneNumber: '555-555-3831',
    email: 'jaydenjohnson121282@aol.com',
    description: [
      'Trusted with personal information (i.e., contact information, address/neighborhood information)',
      'Trusted source for sending money for donations, clicking links, and calling back',
    ],
    type: ContactType.individual,
    icon: Icons.person,
  ),
  //accounting firm
  const Contact(
    relation: Relationship.accountingFirm,
    name: 'Ruiz and Brooks Accounting Services',
    relationship: 'Accounting Firm',
    phoneNumber: '555-555-6861',
    email: 'info@rbaccountingservices.com',
    description: [
      'Trusted with personal information (i.e., address, social security number [SSN]), financial information (i.e., bank account information), and legal information (i.e., employer forms and information)',
      'Trusted source for sending money for service payment, clicking links, and calling back',
    ],
    type: ContactType.organization,
    icon: Icons.calculate,
  ),
  //bank
  const Contact(
    relation: Relationship.bank,
    name: 'Southeastern Capital Bank',
    relationship: 'Bank',
    phoneNumber: '555-555-9477',
    email: 'support@secapitalbank.com',
    description: [
      'Trusted with personal information (i.e., address, social security number [SSN]) and financial information (i.e., bank account information, transaction information)',
      'Trusted source for clicking links and calling back',
    ],
    type: ContactType.organization,
    icon: Icons.account_balance,
  ),
  //health insurance insurance
  const Contact(
    relation: Relationship.healthInsurance,
    name: 'RR Ling Health Insurance',
    relationship: 'Health Insurance Company',
    phoneNumber: '555-555-5718',
    email: 'services@rrlinsurance.com',
    description: [
      'Trusted with personal information (i.e., address, social security number [SSN]) and healthcare information (i.e., physician information, healthcare services)',
      'Trusted source for sending money for service payment, clicking links, and calling back',
    ],
    type: ContactType.organization,
    icon: Icons.health_and_safety,
  ),
  //doctor's office
  const Contact(
    relation: Relationship.doctor,
    name: 'Southbrick Medical',
    relationship: "Doctor's Office",
    phoneNumber: '555-555-6619',
    email: 'healthservices@sbmedical.com',
    description: [
      'Trusted with personal information (i.e., address, contact information) and healthcare information (i.e., physician information, insurance information, pharmacy information)',
      'Trusted source for sending money for service payment, clicking links, and calling back',
    ],
    type: ContactType.organization,
    icon: Icons.medical_services,
  ),
  //dentist's offiice
  const Contact(
    relation: Relationship.dentist,
    name: 'Hoffman & Aziz Dental Associates',
    relationship: 'Dentist Office',
    phoneNumber: '555-555-4810',
    email: 'info@hadentalassociates.com',
    description: [
      'Trusted with personal information (i.e., address, contact information) and healthcare information (i.e., physician information, insurance information, pharmacy information)',
      'Trusted source for sending money for service payment, clicking links, and calling back',
    ],
    type: ContactType.organization,
    icon: Icons.tag_faces,
  ),
  //pharmacy
  const Contact(
    relation: Relationship.pharmacy,
    name: 'Waldorf Pharmacy',
    relationship: 'Pharmacy',
    phoneNumber: '555-555-8890',
    email: 'management@waldorfpharmacy.com',
    description: [
      'Trusted with personal information (i.e., address, contact information) and healthcare information (i.e., physician information, insurance information, pharmacy information)',
      'Trusted source for sending money for service payment, clicking links, and calling back',
    ],
    type: ContactType.organization,
    icon: Icons.medication,
  ),
  //religious organization
  const Contact(
    relation: Relationship.religiousOrganization,
    name: 'Autumn Falls Religious Community',
    relationship: 'Religious Organization',
    phoneNumber: '555-555-5899',
    email: 'info@afrccommunication.com',
    description: [
      'Trusted with personal information (i.e., contact information, address/neighborhood information)',
      'Trusted source for sending money for donations, clicking links, and calling back',
    ],
    type: ContactType.organization,
    icon: Icons.groups,
  ),
  //charity organization
  const Contact(
    relation: Relationship.charityOrganization,
    name: 'Cups4Pups',
    relationship: 'Charity Organization',
    phoneNumber: '555-555-3378',
    email: 'donate@cups4pups.org',
    description: [
      'Trusted with personal information (i.e., contact information, address/neighborhood information)',
      'Trusted source for sending money for donations, clicking links, and calling back',
    ],
    type: ContactType.organization,
    icon: Icons.pets,
  ),
  //political party
  const Contact(
      relation: Relationship.politicalParty,
      name: 'Freedom2Vote',
      relationship: 'Political Party',
      phoneNumber: '555-555-6350',
      email: 'freedom2vote.org',
      description: [
        'Trusted with personal information (i.e., contact information, address/neighborhood information)',
        'Trusted source for sending money for donations, clicking links, and calling back',
      ],
      type: ContactType.organization,
      icon: Icons.volunteer_activism),
];
