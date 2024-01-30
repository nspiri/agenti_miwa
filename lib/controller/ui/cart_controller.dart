import 'dart:convert';

import 'package:foody/helpers/utils/do_http_request.dart';
import 'package:foody/model/cart_model.dart';
import 'package:foody/model/customer_detail.dart';
import 'package:foody/views/my_controller.dart';
import 'package:get/get.dart';
import 'package:foody/model/order_detail.dart';
import 'package:foody/model/request.dart' as r;

class CartController extends MyController {
  late double order = 0, tax = 30, offer = 50, total = 0;
  List<CartData> carts = [];
  String codCliente;
  CustomerDetail? dettaglio;

  CartController({required this.codCliente});

  getData(String codCliente) async {
    getCliente(codCliente);
  }

  getCliente(String codCliente) async {
    r.Response res = await DoRequest.doHttpRequest(
        nomeCollage: "colsrcli",
        etichettaCollage: "CLIENTE",
        dati: {"cliente": codCliente});

    if (res.code == 200) {
      var a = res.result as dynamic;
      dynamic data = json.decode(jsonEncode(a));
      dettaglio = CustomerDetail.listFromJSON(data[0]);
      update();
    } else {
      //ERRORE
      return null;
    }
  }

  bool increaseAble(CartData cart) {
    return cart.quantity < cart.quantity;
  }

  bool decreaseAble(CartData cart) {
    return cart.quantity > 1;
  }

  void increment(CartData cart) {
    cart.quantity++;
    update();
  }

  void decrement(CartData cart) {
    if (!decreaseAble(cart)) return;
    cart.quantity--;
    update();
  }

  void removeData(index) {
    carts.remove(index);
    update();
  }

  void gotoExplore() {
    Get.toNamed('/foods');
  }

  @override
  void onInit() {
    CartData.dummyList.then((value) {
      carts = value.sublist(0, 7);
      update();
    });
    super.onInit();
  }
}
