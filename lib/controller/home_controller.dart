import 'package:foody/views/my_controller.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeController extends MyController {
  int selectTime = 1;
  // int selectedId = 0;
  String selectedDailyTask = 'Today';

  List listaPulsanti = [
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
      "image": "assets/images/home/nuovo_cliente.png",
      "name": "Nuovo Cliente",
      "url": ""
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

  void onSelect(int index) async {
    if (listaPulsanti[index]['url'] == "") {
      Get.toNamed("/admin/customers/create");
    } else {
      final Uri url = Uri.parse(listaPulsanti[index]['url']);
      if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
      }
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

  Map restaurant = {
    'List': [
      {
        'image': "assets/images/food/domino's.png",
        'name': 'Domino\'s Pizza',
        'star': 5,
        'charges': 'Buy 2 get 1 Free',
        'title': 'Pizza',
        'range': '2 km',
        'delivery': false
      },
      {
        'image': 'assets/images/food/pizza_hut.png',
        'name': 'Pizza Hut',
        'star': '4.2',
        'charges': 'Free Delivery',
        'title': 'Pizza',
        'range': '3.1 km',
        'delivery': true
      },
      {
        'image': 'assets/images/food/carrows.png',
        'name': 'Carrows Restaurant',
        'star': '1.5',
        'charges': '\$0.99 Delivery',
        'title': 'Fish',
        'range': '1 km',
        'delivery': true
      },
      {
        'image': "assets/images/food/mc_donald's.png",
        'name': 'McDonald\'s',
        'star': '5',
        'charges': '\$1.99 Delivery',
        'title': 'Burger',
        'range': '0.2 km',
        'delivery': true
      },
      {
        'image': 'assets/images/food/kfc.png',
        'name': 'KFC',
        'star': '3.3',
        'charges': 'Buy 3 get 1 Free',
        'title': 'Chicken',
        'range': '20 km',
        'delivery': false
      },
      {
        'image': 'assets/images/food/burger_king.png',
        'name': 'Burger King',
        'star': '3',
        'charges': 'Free Delivery',
        'title': 'Burger',
        'range': '6.1 km',
        'delivery': true
      },
    ]
  };
}
