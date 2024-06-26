import 'package:flutter/material.dart';
import 'package:mexalorder/helpers/services/auth_services.dart';
import 'package:mexalorder/helpers/storage/local_storage.dart';
import 'package:mexalorder/helpers/utils/global.dart';
import 'package:mexalorder/helpers/utils/utils.dart';
import 'package:mexalorder/views/auth/forgot_password_screen.dart';
import 'package:mexalorder/views/auth/login_screen.dart';
import 'package:mexalorder/views/auth/register_account_screen.dart';
import 'package:mexalorder/views/ui/Attrezzature/attrezzature_screen.dart';
import 'package:mexalorder/views/ui/Lista/lista_screen.dart';
import 'package:mexalorder/views/ui/Ordini/ordine_dettaglio_screen.dart';
import 'package:mexalorder/views/ui/Ordini/ordini_screen.dart';
import 'package:mexalorder/views/ui/Statistiche/statistiche_screen.dart';
import 'package:mexalorder/views/ui/cart_screen.dart';
import 'package:mexalorder/views/home_screen.dart';
import 'package:mexalorder/views/ui/customer/attrezzature_customer.dart';
import 'package:mexalorder/views/ui/customer/ordini_customer_screen.dart';
import 'package:mexalorder/views/ui/customer/scadenziario_customer_screen.dart';
import 'package:mexalorder/views/ui/customer/state_customers_screen.dart';
import 'package:mexalorder/views/ui/customer/storico_customer_screen.dart';
import 'package:mexalorder/views/ui/Articolo/add_food_screen.dart';
import 'package:mexalorder/views/ui/Articolo/food_detail_screen.dart';
import 'package:mexalorder/views/ui/Articolo/food_edit_screen.dart';
import 'package:mexalorder/views/ui/order_screen.dart';
import 'package:mexalorder/views/ui/Articolo/articoli_list_screen.dart';
import 'package:mexalorder/views/ui/foods_screen.dart';
import 'package:mexalorder/views/ui/Scadenziario/add_restaurant_screen.dart';
import 'package:mexalorder/views/ui/Scadenziario/edit_restaurant_screen.dart';
import 'package:mexalorder/views/ui/Scadenziario/scadenziario_list.dart';
//import 'package:mexalorder/views/ui/chat_screen.dart';
import 'package:mexalorder/views/ui/customer/add_customer_screen.dart';
import 'package:mexalorder/views/ui/customer/customer_detail_screen.dart';
import 'package:mexalorder/views/ui/customer/customer_list_screen.dart';
import 'package:mexalorder/views/ui/dashboard_screen.dart';
/*import 'package:mexalorder/views/ui/seller/add_seller_screen.dart';
import 'package:mexalorder/views/ui/seller/seller_detail_screen.dart';
import 'package:mexalorder/views/ui/seller/seller_edit_screen.dart';
import 'package:mexalorder/views/ui/seller/seller_list_screen.dart';
import 'package:mexalorder/views/ui/setting_screen.dart';*/
import 'package:mexalorder/views/ui/wallet_screen.dart';
import 'package:get/get.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    bool isOffline = LocalStorage.getOffline();
    if (!isOffline) {
      Utils.controllaLogin();
    }
    if (route == "/admin/customers/detail" ||
        route == "/admin/customers/orders" ||
        route == "/admin/customers/historical" ||
        route == "/admin/customers/timetable" ||
        route == "/admin/customers/equipment" ||
        route == "/cart" ||
        route == "/list") {
      if (clienteSelezionato?.codiceCliente == "") {
        return const RouteSettings(name: '/admin/customers/list');
      }
    } else if (route == "/admin/orderdetail") {
      if (ordineSelezionato == null) {
        return const RouteSettings(name: '/admin/orders');
      }
    }
    return AuthService.isLoggedIn
        ? null
        : const RouteSettings(name: '/auth/login');
  }
}

getPageRoute() {
  var routes = [
    GetPage(
        name: '/',
        page: () => const HomeScreen(),
        middlewares: [AuthMiddleware()]),
    GetPage(
        name: '/home',
        page: () => const HomeScreen(),
        middlewares: [AuthMiddleware()]),
    GetPage(
        name: '/dashboard',
        page: () => const DashboardScreen(),
        middlewares: [AuthMiddleware()]),

    ///*************AUTH*************///
    GetPage(name: '/auth/login', page: () => const LoginScreen()),
    GetPage(
        name: '/auth/register_account',
        page: () => const RegisterAccountScreen()),
    GetPage(
        name: '/auth/forgot_password',
        page: () => const ForgotPasswordScreen()),

    ///*************PAGES*************///

    ///Chat
    /*   GetPage(
        name: '/chat',
        page: () => const ChatScreen(),
        middlewares: [AuthMiddleware()]),*/

    /// ORDINI
    GetPage(
        name: '/admin/orders',
        page: () => const OrdiniListScreen(),
        middlewares: [AuthMiddleware()]),
    GetPage(
        name: '/admin/orderdetail',
        page: () => const OrderDetailScreen(),
        middlewares: [AuthMiddleware()]),

    /// Orders
    /*  GetPage(
        name: '/admin/orders',
        page: () => const OrderListScreen(),
        middlewares: [AuthMiddleware()]),
    GetPage(
        name: '/admin/orders/detail',
        page: () => const OrderDetailScreen(),
        middlewares: [AuthMiddleware()]),*/

    /// Customers
    GetPage(
        name: '/admin/customers',
        page: () => const CustomerListScreen(),
        middlewares: [AuthMiddleware()]),
    GetPage(
        name: '/admin/customers/detail',
        page: () => const CustomerDetailScreen(),
        middlewares: [AuthMiddleware()]),
    GetPage(
        name: '/admin/customers/create',
        page: () => const AddCustomerScreen(),
        middlewares: [AuthMiddleware()]),
    GetPage(
        name: '/admin/customers/historical',
        page: () => const EditCustomerScreen(),
        middlewares: [AuthMiddleware()]),
    GetPage(
        name: '/admin/customers/orders',
        page: () => const OrdiniListCustomerScreen(),
        middlewares: [AuthMiddleware()]),
    GetPage(
        name: '/admin/customers/timetable',
        page: () => const ScadenziarioScreen(),
        middlewares: [AuthMiddleware()]),
    GetPage(
        name: '/admin/customers/equipment',
        page: () => const AttrezzatureScreen(),
        middlewares: [AuthMiddleware()]),
    GetPage(
        name: '/admin/customers/state',
        page: () => const CustomerStateScreen(),
        middlewares: [AuthMiddleware()]),
    GetPage(
        name: '/admin/equipment',
        page: () => const AttrezzatureCondScreen(),
        middlewares: [AuthMiddleware()]),

    /// Seller
    /*  GetPage(
        name: '/admin/sellers',
        page: () => const SellerListScreen(),
        middlewares: [AuthMiddleware()]),
    GetPage(
        name: '/admin/sellers/detail',
        page: () => const SellerDetailScreen(),
        middlewares: [AuthMiddleware()]),
    GetPage(
        name: '/admin/sellers/create',
        page: () => const AddSellerScreen(),
        middlewares: [AuthMiddleware()]),
    GetPage(
        name: '/admin/sellers/edit',
        page: () => const SellerEditScreen(),
        middlewares: [AuthMiddleware()]),*/

    /// Restaurants
    GetPage(
        name: '/admin/timetable',
        page: () => const ScadenziarioListScreen(),
        middlewares: [AuthMiddleware()]),
    /* GetPage(
        name: '/admin/restaurants/detail',
        page: () => const RestaurantDetailScreen(),
        middlewares: [AuthMiddleware()]),*/

    GetPage(
        name: '/admin/restaurants/create',
        page: () => const AddRestaurantScreen(),
        middlewares: [AuthMiddleware()]),

    GetPage(
        name: '/admin/restaurants/edit',
        page: () => const EditRestaurantScreen(),
        middlewares: [AuthMiddleware()]),

    /// Cart

    GetPage(
        name: '/cart',
        page: () => const CartScreen(),
        middlewares: [AuthMiddleware()]),

    GetPage(
        name: '/list',
        page: () => const ListaScreen(),
        middlewares: [AuthMiddleware()]),

    GetPage(
        name: '/admin/stats',
        page: () => const StatisticheListScreen(),
        middlewares: [AuthMiddleware()]),

    /// Food
    GetPage(
        name: '/admin/food',
        page: () => const FoodListScreen(),
        middlewares: [AuthMiddleware()]),
    GetPage(
        name: '/admin/food/detail',
        page: () => const FoodDetailScreen(),
        middlewares: [AuthMiddleware()]),
    GetPage(
        name: '/admin/food/create',
        page: () => const AddFoodScreen(),
        middlewares: [AuthMiddleware()]),
    GetPage(
        name: '/admin/food/edit',
        page: () => const FoodEditScreen(),
        middlewares: [AuthMiddleware()]),

    /// Foods
    GetPage(
        name: '/foods',
        page: () => const FoodsScreen(),
        middlewares: [AuthMiddleware()]),

    /// Order
    GetPage(
        name: '/orders',
        page: () => const OrderScreen(),
        middlewares: [AuthMiddleware()]),

    /// Wallet
    GetPage(
        name: '/admin/wallet',
        page: () => const WalletScreen(),
        middlewares: [AuthMiddleware()]),

    /// Setting
    /*   GetPage(
        name: '/admin/setting',
        page: () => const SettingScreen(),
        middlewares: [AuthMiddleware()]),*/
  ];
  return routes
      .map((e) => GetPage(
          name: e.name,
          page: e.page,
          middlewares: e.middlewares,
          transition: Transition.noTransition))
      .toList();
}
