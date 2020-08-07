import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/venue.dart';
import 'address_model.dart';
import 'coordinates_model.dart';
import 'model.dart';

part 'venue_model.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class VenueModel extends Venue implements Model {
  final CoordinatesModel coordinates;
  final AddressModel address;
  VenueModel({
    @required int id,
    String type,
    String description,
    @required String title,
    String timezone,
    String image,
    String shareLink,
    String phone,
    bool allowsNamedAttendees,
    String notes,
    String email,
    String website,
    this.coordinates,
    this.address,
  }) : super(
          id: id,
          type: type,
          description: description,
          title: title,
          shareLink: shareLink,
          timezone: timezone,
          allowsNamedAttendees: allowsNamedAttendees,
          image: image,
          notes: notes,
          phone: phone,
          email: email,
          website: website,
          coordinates: coordinates,
          address: address,
        );
    

  factory VenueModel.fromJson(Map<String, dynamic> json) =>
      _$VenueModelFromJson(json);
  Map<String, dynamic> toJson() => _$VenueModelToJson(this);
}

