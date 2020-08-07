// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VenueModel _$VenueModelFromJson(Map<String, dynamic> json) {
  return VenueModel(
    id: json['id'] as int,
    type: json['type'] as String,
    description: json['description'] as String,
    title: json['title'] as String,
    timezone: json['timezone'] as String,
    image: json['image'] as String,
    shareLink: json['share_link'] as String,
    phone: json['phone'] as String,
    allowsNamedAttendees: json['allows_named_attendees'] as bool,
    notes: json['notes'] as String,
    email: json['email'] as String,
    website: json['website'] as String,
    coordinates: json['coordinates'] == null
        ? null
        : CoordinatesModel.fromJson(
            json['coordinates'] as Map<String, dynamic>),
    address: json['address'] == null
        ? null
        : AddressModel.fromJson(json['address'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$VenueModelToJson(VenueModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'description': instance.description,
      'title': instance.title,
      'timezone': instance.timezone,
      'allows_named_attendees': instance.allowsNamedAttendees,
      'image': instance.image,
      'phone': instance.phone,
      'notes': instance.notes,
      'email': instance.email,
      'share_link': instance.shareLink,
      'website': instance.website,
      'coordinates': instance.coordinates?.toJson(),
      'address': instance.address?.toJson(),
    };
