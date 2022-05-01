class Place {
  final String id;
  final String name;
  final List location;
  final String createdBy;

  Place({this.id, this.name, this.location, this.createdBy});

  Map<String, dynamic> toMap() => {
        'name': name,
        'location': location,
        'createdBy': createdBy,
      };

  Place.fromMap(String documentId, Map<String, dynamic> map)
      : id = documentId,
        name = map['name'],
        location = map['location'],
        createdBy = map['createdBy'];
}
