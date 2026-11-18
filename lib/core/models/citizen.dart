class Citizen {
  final int? id;
  final String fullName;
  final String phone;
  final String? email;
  final String? nationalId;
  Citizen({this.id, required this.fullName, required this.phone, this.email, this.nationalId});
  factory Citizen.fromJson(Map<String, dynamic> j) => Citizen(
    id: j['id'], fullName: j['full_name'], phone: j['phone'],
    email: j['email'], nationalId: j['national_id'],
  );
}
