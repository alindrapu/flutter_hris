class Api {
  static const _baseUrl = "https://absensinet-api.alindraputra.info/api";
  static const login = "$_baseUrl/login";
  static const register = "$_baseUrl/register";
  static const logout = "$_baseUrl/logout";
  static const listJabatan = "$_baseUrl/list-jabatan";
  static const listAgama = "$_baseUrl/list-agama";
  static const listJenisCuti = "$_baseUrl/list-jenis-cuti";
  static const newPassword = "$_baseUrl/new-password";
  static const newKdAkses = "$_baseUrl/new-kd-akses";
  static const newKdPass = "$_baseUrl/new-kd-password";
  static const addPegawaiCurrent = "$_baseUrl/add-pegawai-current";
  static const updateCurrentPosition = "$_baseUrl/update-current-position";
  static const absenPegawai = "$_baseUrl/presensi-pegawai";
  static const checkAbsen = "$_baseUrl/check-presensi";
  static const last5Days = "$_baseUrl/last-v-days";
  static const requestCuti = "$_baseUrl/request-cuti";
  static const histories = "$_baseUrl/histories";
  static const detailPresensi = "$_baseUrl/detail-presensi";
  static const listApproveCuti = "$_baseUrl/get-list-permohonan-cuti";
  static const downloadLogPresensi = "$_baseUrl/presensi/export-xls";
  static const approveCuti = "$_baseUrl/update-cuti";
}
