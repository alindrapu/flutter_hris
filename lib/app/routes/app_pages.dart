import 'package:get/get.dart';

import '../modules/add_pegawai/bindings/add_pegawai_binding.dart';
import '../modules/add_pegawai/views/add_pegawai_view.dart';
import '../modules/detail_presensi/bindings/detail_presensi_binding.dart';
import '../modules/detail_presensi/views/detail_presensi_view.dart';
import '../modules/forgot_password/bindings/forgot_password_binding.dart';
import '../modules/forgot_password/views/forgot_password_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/new_kd_akses/bindings/new_kd_akses_binding.dart';
import '../modules/new_kd_akses/views/new_kd_akses_view.dart';
import '../modules/new_kd_pass/bindings/new_kd_pass_binding.dart';
import '../modules/new_kd_pass/views/new_kd_pass_view.dart';
import '../modules/new_password/bindings/new_password_binding.dart';
import '../modules/new_password/views/new_password_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/update_password/bindings/update_password_binding.dart';
import '../modules/update_password/views/update_password_view.dart';
import '../modules/update_profile/bindings/update_profile_binding.dart';
import '../modules/update_profile/views/update_profile_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.home;

  static final routes = [
    GetPage(
        name: _Paths.home,
        page: () => HomeView(),
        binding: HomeBinding(),
        transition: Transition.fadeIn),
    GetPage(
      name: _Paths.addPegawai,
      page: () => const AddPegawaiView(),
      binding: AddPegawaiBinding(),
    ),
    GetPage(
      name: _Paths.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.newPassword,
      page: () => const NewPasswordView(),
      binding: NewPasswordBinding(),
    ),
    GetPage(
      name: _Paths.forgotPassword,
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
        name: _Paths.profile,
        page: () => ProfileView(),
        binding: ProfileBinding(),
        transition: Transition.fadeIn),
    GetPage(
      name: _Paths.updatePassword,
      page: () => const UpdatePasswordView(),
      binding: UpdatePasswordBinding(),
    ),
    GetPage(
      name: _Paths.updateProfile,
      page: () => const UpdateProfileView(),
      binding: UpdateProfileBinding(),
    ),
    GetPage(
      name: _Paths.newKdAkses,
      page: () => const NewKdAksesView(),
      binding: NewKdAksesBinding(),
    ),
    GetPage(
      name: _Paths.newKdPass,
      page: () => const NewKdPassView(),
      binding: NewKdPassBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_PRESENSI,
      page: () => const DetailPresensiView(),
      binding: DetailPresensiBinding(),
    ),
  ];
}
