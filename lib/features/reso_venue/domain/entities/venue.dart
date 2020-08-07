import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'address.dart';
import 'coordinates.dart';
import 'timeslot.dart';
import 'user.dart';

class Venue extends Equatable {
  int id;
  String type;
  String description;
  String title;
  String timezone;
  bool allowsNamedAttendees;
  String image;
  String phone;
  String notes;
  String email;
  String shareLink;
  String website;
  Coordinates coordinates;
  Address address;
  Venue({
    @required this.id,
    @required this.type,
    @required this.description,
    @required this.title,
    this.timezone,
    this.image,
    this.notes,
    this.phone,
    this.email,
    this.shareLink,
    this.website,
    this.coordinates,
    this.address,
    this.allowsNamedAttendees
  });

  @override
  List<Object> get props => [id];
  static const types = <String>[
    "All",
    "Retail",
    "Real Estate",
    "Restaurant",
    "Grocery",
    "Coffee",
    "Gym",
    "Gas",
    "Mail",
    "Repair",
    "Beauty",
    "Education"
  ];
}