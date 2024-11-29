import 'package:get/get.dart';

import '../modules/DashboardWs/bindings/dashboard_ws_binding.dart';
import '../modules/DashboardWs/views/dashboard_ws_view.dart';
import '../modules/add_topic/bindings/add_topic_binding.dart';
import '../modules/add_topic/views/add_topic_view.dart';
import '../modules/community/bindings/community_binding.dart';
import '../modules/community/views/community_view.dart';
import '../modules/connect/bindings/connect_binding.dart';
import '../modules/connect/views/connect_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/gedungRamah/bindings/gedung_ramah_binding.dart';
import '../modules/gedungRamah/views/gedung_ramah_view.dart';
import '../modules/gedungramah_details/bindings/gedungramah_details_binding.dart';
import '../modules/gedungramah_details/views/gedungramah_details_view.dart';
import '../modules/history/bindings/history_binding.dart';
import '../modules/history/views/history_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/layout/bindings/layout_binding.dart';
import '../modules/layout/views/layout_view.dart';
import '../modules/loginPage/bindings/login_page_binding.dart';
import '../modules/loginPage/views/login_page_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/topic_details/bindings/topic_details_binding.dart';
import '../modules/topic_details/views/topic_details_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LAYOUT;
  static const LOGIN = Routes.LOGIN_PAGE;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN_PAGE,
      page: () => const LoginPageView(),
      binding: LoginPageBinding(),
    ),
    GetPage(
      name: _Paths.COMMUNITY,
      page: () => const CommunityView(),
      binding: CommunityBinding(),
    ),
    GetPage(
      name: _Paths.HISTORY,
      page: () => const HistoryView(),
      binding: HistoryBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.LAYOUT,
      page: () => const LayoutView(),
      binding: LayoutBinding(),
    ),
    GetPage(
      name: _Paths.GEDUNG_RAMAH,
      page: () => const GedungRamahView(),
      binding: GedungRamahBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.CONNECT,
      page: () => const ConnectView(),
      binding: ConnectBinding(),
    ),
    GetPage(
      name: _Paths.TOPIC_DETAILS,
      page: () => const TopicDetailsView(),
      binding: TopicDetailsBinding(),
    ),
    GetPage(
      name: _Paths.GEDUNGRAMAH_DETAILS,
      page: () => const GedungramahDetailsView(),
      binding: GedungramahDetailsBinding(),
    ),
    GetPage(
      name: _Paths.ADD_TOPIC,
      page: () => const AddTopicView(),
      binding: AddTopicBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD_WS,
      page: () => const DashboardWsView(),
      binding: DashboardWsBinding(),
    ),
  ];
}
