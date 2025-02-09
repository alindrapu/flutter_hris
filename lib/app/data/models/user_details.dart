class UserDetails {
  final String? email;
  final String? nama;
  final String? token;
  final String? kdAkses;

  UserDetails(
      {required this.email,
      required this.nama,
      required this.token,
      this.kdAkses});
}
