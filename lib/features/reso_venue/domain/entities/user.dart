
import 'package:Reso_venue/features/reso_venue/domain/entities/venue.dart';
import 'package:equatable/equatable.dart';
import 'address.dart';
import 'coordinates.dart';

class User extends Equatable{
  final int id;
  final String email;
  String publicId;
  final DateTime dateJoined;
  final String firstName;
  final String lastName;
  bool isLocked;
  Coordinates coordinates;
  Address address;
  List<Venue> venues;
  int currentVenue = 0;
  
  User({
    this.id,  
    this.email,
    this.publicId,
    this.dateJoined,
    this.firstName,
    this.lastName,
    this.coordinates,
    this.address,
    this.isLocked,
    this.venues,
  }) : this.currentVenue = 0;

  @override
  List<Object> get props => [id];

}