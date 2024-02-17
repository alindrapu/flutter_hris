class Api {
  static const _baseUrl =
      "https://lamprey-fluent-bison.ngrok-free.app/api";
  static const login = "$_baseUrl/login"; 
  static const register = "$_baseUrl/register";
  static const logout = "$_baseUrl/logout";
  static const listJabatan = "$_baseUrl/list-jabatan";
  static const listAgama = "$_baseUrl/list-agama";
  static const newPassword = "$_baseUrl/new-password";
  static const newKdAkses = "$_baseUrl/new-kd-akses";
  static const newKdPass = "$_baseUrl/new-kd-password";
  static const addPegawaiCurrent = "$_baseUrl/add-pegawai-current";
  static const updateCurrentPosition = "$_baseUrl/update-current-position";
  static const absenPegawai = "$_baseUrl/presensi-pegawai";
  static const checkAbsen = "$_baseUrl/check-presensi";
  static const last5Days = "$_baseUrl/last-v-days";
}

