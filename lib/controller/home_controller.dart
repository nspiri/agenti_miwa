import 'package:foody/helpers/utils/global.dart';
import 'package:foody/model/customer_detail.dart';
import 'package:foody/model/customer_list.dart';
import 'package:foody/views/my_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/dialog/dialog_route.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeController extends MyController {
  int selectTime = 1;
  int numStatoCli = 0, numAttrezz = 0;
  String selectedDailyTask = 'Today';
  List<StatoCliente> statoClienti = [];
  List<Attrezzatura> attrezzature = [];

  List listaPulsanti = [
    {
      "image": "assets/images/home/nuovo_cliente.png",
      "name": "Nuovo Cliente",
      "url": "/admin/customers/create",
      "hover": false
    },
    {
      "image": "assets/images/home/nuovo_ordine.png",
      "name": "Nuovo Ordine",
      "url": "/cart",
      "hover": false
    },
    {
      "image": "assets/images/home/ordini_in_corso.png",
      "name": "Ordini In Corso",
      "url": "/admin/orders",
      "hover": false
    },
    {
      "image": "assets/images/home/statistiche.png",
      "name": "Statistiche Vendite",
      "url": "/admin/stats",
      "hover": false
    },
    {
      "image": "assets/images/home/stato_cliente.png",
      "name": "Stato Clienti",
      "url": "/admin/customers/state",
      "hover": false
    },
    {
      "image": "assets/images/home/attrezzature.png",
      "name": "Stato Attrezzature",
      "url": "/admin/equipment",
      "hover": false
    },
  ];

  List listaLink = [
    {
      "image": "assets/images/home/catalogo.png",
      "name": "Catalogo",
      "url": "https://miwasrl.com/index.php/cataloghi"
    },
    {
      "image": "assets/images/home/ricette.png",
      "name": "Ricette",
      "url": "https://miwasrl.com/index.php/ricette"
    },
    {
      "image": "assets/images/home/eventi.png",
      "name": "Eventi",
      "url": "https://miwasrl.com/index.php/eventi"
    },
    {
      "image": "assets/images/home/promozioni.png",
      "name": "Promozioni",
      "url":
          "https://drive.google.com/drive/folders/1OZjz7-h_5iWA5norBcF4ciV5UvBbW4Ry?usp=sharing"
    },
  ];

  getDati() {
    StatoCliente.dummyList.then((value) {
      statoClienti = value;
      numStatoCli = value.length;
      update();
    });
    Attrezzatura.dummyList.then((value) {
      attrezzature = value;
      numAttrezz = value.length;
      update();
    });
  }

  void onSelectPulsante(int index) async {
    if (listaPulsanti[index]["url"] == "/cart" && clienteSelezionato == null) {
      Get.toNamed("/admin/customers");
    } else {
      if (listaPulsanti[index]["url"] == "/admin/equipment") {
        Get.toNamed(listaPulsanti[index]["url"], arguments: attrezzature);
      } else if (listaPulsanti[index]["url"] == "/admin/customers/state") {
        Get.toNamed(listaPulsanti[index]["url"], arguments: statoClienti);
      } else {
        Get.toNamed(listaPulsanti[index]["url"]);
      }
    }

    update();
  }

  void onSelectLink(int index) async {
    final Uri url = Uri.parse(listaLink[index]['url']);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
    update();
  }

  void selectRevenue(String time) {
    selectedDailyTask = time;
    update();
  }

  void onSelectRevenue(int select) {
    selectTime = select;

    update();
  }
}
