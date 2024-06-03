import 'dart:isolate';

import 'package:mexalorder/helpers/storage/local_storage.dart';
import 'package:mexalorder/helpers/utils/global.dart';
import 'package:get/route_manager.dart';
import 'package:flutter/material.dart';
import 'package:mexalorder/helpers/services/url_service.dart';
import 'package:mexalorder/helpers/theme/theme_customizer.dart';
import 'package:mexalorder/helpers/utils/my_shadow.dart';
import 'package:mexalorder/helpers/utils/ui_mixins.dart';
import 'package:mexalorder/helpers/widgets/my_card.dart';
import 'package:mexalorder/helpers/widgets/my_container.dart';
import 'package:mexalorder/helpers/widgets/my_spacing.dart';
import 'package:mexalorder/helpers/widgets/my_text.dart';
import 'package:mexalorder/images.dart';
import 'package:mexalorder/widgets/custom_pop_menu.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:package_info_plus/package_info_plus.dart';

typedef LeftbarMenuFunction = void Function(String key);

class LeftbarObserver {
  static Map<String, LeftbarMenuFunction> observers = {};

  static attachListener(String key, LeftbarMenuFunction fn) {
    observers[key] = fn;
  }

  static detachListener(String key) {
    observers.remove(key);
  }

  static notifyAll(String key) {
    for (var fn in observers.values) {
      fn(key);
    }
  }
}

class LeftBar extends StatefulWidget {
  final bool isCondensed;

  const LeftBar({Key? key, this.isCondensed = false}) : super(key: key);

  @override
  _LeftBarState createState() => _LeftBarState();
}

class _LeftBarState extends State<LeftBar>
    with SingleTickerProviderStateMixin, UIMixin {
  final ThemeCustomizer customizer = ThemeCustomizer.instance;

  bool isCondensed = false;
  String path = UrlService.getCurrentUrl();

  bool isOffline = false;
  bool isHover = false;

  String version = "", code = "";

  @override
  void initState() {
    super.initState();
    isOffline = LocalStorage.getOffline();
    getVersion();
  }

  getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    code = packageInfo.buildNumber;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    isCondensed = widget.isCondensed;
    return MyCard(
      paddingAll: 0,
      shadow: MyShadow(position: MyShadowPosition.centerRight, elevation: 0.2),
      child: AnimatedContainer(
        color: leftBarTheme.background,
        width: isCondensed ? 70 : 254,
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 200),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 53,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                          onTap: () {
                            Get.toNamed('/home');
                          },
                          child: Image.asset(
                            Images.logoMiwa,
                            height: widget.isCondensed ? 96 : 128,
                            // color: contentTheme.primary,
                          )),
                      /* if (!widget.isCondensed)
                        Flexible(
                          fit: FlexFit.loose,
                          child: MySpacing.width(16),
                        ),
                      if (!widget.isCondensed)
                        Flexible(
                          fit: FlexFit.loose,
                          child: MyText.labelLarge(
                            "Miwa",
                            style: GoogleFonts.raleway(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: theme.colorScheme.primary,
                              letterSpacing: 1,
                            ),
                            maxLines: 1,
                          ),
                        )*/
                    ],
                  ),
                ),
                Divider(
                  color: contentTheme.secondary.withAlpha(40),
                ),
                Expanded(
                    child: SingleChildScrollView(
                  physics: const PageScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MySpacing.height(16),
                      //LabelWidget(isCondensed: isCondensed, label: "Client App"),
                      NavigationItem(
                        iconData: LucideIcons.home,
                        title: "Home",
                        isCondensed: isCondensed,
                        route: '/home',
                      ),
                      /* NavigationItem(
                        iconData: LucideIcons.shoppingBag,
                        title: "Foods",
                        isCondensed: isCondensed,
                        route: '/foods',
                      ),*/
                      if (!isOffline)
                        NavigationItem(
                          iconData: LucideIcons.shoppingCart,
                          title: "Ordine",
                          isCondensed: isCondensed,
                          route: '/cart',
                        ),
                      if ((LocalStorage.getCarrello()?.length ?? 0) > 0 ||
                          LocalStorage.getOffline())
                        NavigationItem(
                          iconData: LucideIcons.shoppingCart,
                          title: "Lista",
                          isCondensed: isCondensed,
                          route: '/list',
                        ),
                      /*  NavigationItem(
                        iconData: LucideIcons.listOrdered,
                        title: "Order",
                        isCondensed: isCondensed,
                        route: '/orders',
                      ),
                      NavigationItem(
                        iconData: LucideIcons.messagesSquare,
                        title: "Chat",
                        isCondensed: isCondensed,
                        route: '/chat',
                      ),
                      LabelWidget(isCondensed: isCondensed, label: "Admin Panel"),
                      NavigationItem(
                        iconData: LucideIcons.layoutDashboard,
                        title: "Dashboard",
                        isCondensed: isCondensed,
                        route: '/dashboard',
                      ),
                      MenuWidget(
                        iconData: LucideIcons.store,
                        isCondensed: isCondensed,
                        title: "Orders",
                        children: [
                          MenuItem(
                            title: "List",
                            isCondensed: isCondensed,
                            route: '/admin/orders',
                            iconData: LucideIcons.scrollText,
                          ),
                          MenuItem(
                            title: "Detail",
                            isCondensed: isCondensed,
                            route: '/admin/orders/detail',
                            iconData: LucideIcons.listOrdered,
                          ),
                        ],
                      ),*/
                      NavigationItem(
                        iconData: LucideIcons.dessert,
                        title: "Articoli",
                        isCondensed: isCondensed,
                        route: '/admin/food',
                      ),
                      MenuWidget(
                        iconData: LucideIcons.users,
                        isCondensed: isCondensed,
                        title: "Clienti",
                        children: [
                          if (!isOffline)
                            MenuItem(
                              title: "Lista",
                              isCondensed: isCondensed,
                              route: '/admin/customers',
                            ),
                          MenuItem(
                            title: "Dettaglio",
                            isCondensed: isCondensed,
                            route: '/admin/customers/detail',
                          ),
                          if (!isOffline)
                            MenuItem(
                              title: "Ordini in corso",
                              isCondensed: isCondensed,
                              route: '/admin/customers/orders',
                            ),
                          MenuItem(
                            title: "Scadenzario",
                            isCondensed: isCondensed,
                            route: '/admin/customers/timetable',
                          ),
                          MenuItem(
                            title: "Storico",
                            isCondensed: isCondensed,
                            route: '/admin/customers/historical',
                          ),
                          MenuItem(
                            title: "Attrezzature",
                            isCondensed: isCondensed,
                            route: '/admin/customers/equipment',
                          ),
                          if (!isOffline)
                            MenuItem(
                              title: "Nuovo Cliente",
                              isCondensed: isCondensed,
                              route: '/admin/customers/create',
                            ),
                        ],
                      ),
                      if (!isOffline)
                        NavigationItem(
                          iconData: LucideIcons.listOrdered,
                          title: "Ordini in corso",
                          isCondensed: isCondensed,
                          route: '/admin/orders',
                        ),
                      /* MenuWidget(
                        iconData: LucideIcons.users,
                        isCondensed: isCondensed,
                        title: "Ordini in corso",
                        children: [
                          MenuItem(
                            title: "Lista",
                            isCondensed: isCondensed,
                            route: '/admin/orders',
                          ),
                          MenuItem(
                            title: "Dettaglio",
                            isCondensed: isCondensed,
                            route: '/admin/customers/detail',
                          ),
                        ],
                      ),*/
                      if (!isOffline)
                        NavigationItem(
                          iconData: LucideIcons.euro,
                          title: "Scadenzario",
                          isCondensed: isCondensed,
                          route: '/admin/timetable',
                        ),
                      if (!isOffline)
                        NavigationItem(
                          iconData: LucideIcons.barChartBig,
                          title: "Statistiche Vendite",
                          isCondensed: isCondensed,
                          route: '/admin/stats',
                        ),
                      if (isOffline)
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          onHover: (event) {
                            setState(() {
                              isHover = true;
                            });
                          },
                          onExit: (event) {
                            setState(() {
                              isHover = false;
                            });
                          },
                          child: MyContainer(
                            onTap: () {
                              LocalStorage.setOffline(false);
                              /*  LocalStorage.setArticoli([]);
                              LocalStorage.setListini([]);
                              LocalStorage.setDettCli(null);
                              LocalStorage.setNote("");
                              LocalStorage.setOrdini([]);
                              LocalStorage.setScadenzario([]);
                              LocalStorage.setStorico([]);*/

                              isOffline = false;
                              setState(() {});
                              Get.toNamed('/home',
                                  arguments: clienteSelezionato);
                            },
                            margin: MySpacing.fromLTRB(16, 0, 16, 8),
                            color: Colors.transparent,
                            padding: MySpacing.xy(8, 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                  child: Icon(
                                    LucideIcons.wifi,
                                    color: (isHover /*|| isActive*/)
                                        ? leftBarTheme.activeItemColor
                                        : leftBarTheme.onBackground,
                                    size: 20,
                                  ),
                                ),
                                if (!widget.isCondensed)
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: MySpacing.width(16),
                                  ),
                                if (!widget.isCondensed)
                                  Expanded(
                                    flex: 3,
                                    child: MyText.labelLarge(
                                      "Ritorna online",
                                      overflow: TextOverflow.clip,
                                      maxLines: 1,
                                      color: /* isActive || */ isHover
                                          ? leftBarTheme.activeItemColor
                                          : leftBarTheme.onBackground,
                                    ),
                                  )
                              ],
                            ),
                          ),
                        ),
                      /*MenuWidget(
                        iconData: LucideIcons.users,
                        isCondensed: isCondensed,
                        title: "Sellers",
                        children: [
                          MenuItem(
                            title: "List",
                            isCondensed: isCondensed,
                            route: '/admin/sellers',
                          ),
                          MenuItem(
                            title: "Detail",
                            isCondensed: isCondensed,
                            route: '/admin/sellers/detail',
                          ),
                          MenuItem(
                            title: "Add",
                            isCondensed: isCondensed,
                            route: '/admin/sellers/create',
                          ),
                          MenuItem(
                            title: "Edit",
                            isCondensed: isCondensed,
                            route: '/admin/sellers/edit',
                          ),
                        ],
                      ),
                      MenuWidget(
                        iconData: LucideIcons.soup,
                        isCondensed: isCondensed,
                        title: "Restaurant",
                        children: [
                          MenuItem(
                            title: "List",
                            isCondensed: isCondensed,
                            route: '/admin/restaurants',
                          ),
                          MenuItem(
                            title: "Detail",
                            isCondensed: isCondensed,
                            route: '/admin/restaurants/detail',
                          ),
                          MenuItem(
                            title: "Add",
                            isCondensed: isCondensed,
                            route: '/admin/restaurants/create',
                          ),
                          MenuItem(
                            title: "Edit",
                            isCondensed: isCondensed,
                            route: '/admin/restaurants/edit',
                          ),
                        ],
                      ),*/
                      /*MenuWidget(
                        iconData: LucideIcons.dessert,
                        isCondensed: isCondensed,
                        title: "Food",
                        children: [
                          MenuItem(
                            title: "List",
                            isCondensed: isCondensed,
                            route: '/admin/food',
                          ),
                          MenuItem(
                            title: "Detail",
                            isCondensed: isCondensed,
                            route: '/admin/food/detail',
                          ),
                          MenuItem(
                            title: "Add",
                            isCondensed: isCondensed,
                            route: '/admin/food/create',
                          ),
                          MenuItem(
                            title: "Edit",
                            isCondensed: isCondensed,
                            route: '/admin/food/edit',
                          ),
                        ],
                      ),
            
                      NavigationItem(
                        iconData: LucideIcons.wallet2,
                        title: "Wallet",
                        isCondensed: isCondensed,
                        route: '/admin/wallet',
                      ),
                      NavigationItem(
                        iconData: LucideIcons.settings,
                        title: "Setting",
                        isCondensed: isCondensed,
                        route: '/admin/setting',
                      ),
            
                      MySpacing.height(20),
                      if (!isCondensed)
                        Padding(
                            padding: MySpacing.x(12),
                            child: MyContainer(
                              height: 220,
                              color: contentTheme.primary.withAlpha(40),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    LucideIcons.utensilsCrossed,
                                  ),
                                  MyText.bodyLarge(
                                    "Unbox Delight, Savor Every Bite: Your Culinary Adventure Awaits!",
                                    fontWeight: 600,
                                    textAlign: TextAlign.center,
                                  ),
                                  MyContainer(
                                    onTap: () {},
                                    paddingAll: 8,
                                    color: contentTheme.primary,
                                    child: MyText.bodyMedium(
                                      "Contact Support",
                                      color: contentTheme.onPrimary,
                                      fontWeight: 600,
                                    ),
                                  )
                                ],
                              ),
                            )),*/
                      // MySpacing.height(16),

                      // NavigationItem(
                      //   iconData:  LucideIcons.logOut,
                      //   title: "Logout",
                      //   isCondensed: isCondensed,
                      //   route: '/setting',
                      // ),
                      // Padding(
                      //   padding: MySpacing.fromLTRB(24, 0, 16, 8),
                      //   child: Row(
                      //     children: [
                      //       Icon(
                      //         LucideIcons.logOut,
                      //         size: 20,
                      //         color: contentTheme.danger,
                      //       ),
                      //       MySpacing.width(16),
                      //       !isCondensed
                      //           ? MyText.bodyMedium(
                      //               "Logout",
                      //               fontWeight: 600,
                      //               color: contentTheme.danger,
                      //             )
                      //           : SizedBox(),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ))
              ],
            ),
            Positioned(
              bottom: 5,
              right: 5,
              child: Center(
                child: Text(
                  "Versione: $version ($code)",
                  style: TextStyle(fontSize: 10),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget labelWidget(String label) {
    return isCondensed
        ? MySpacing.empty()
        : Container(
            padding: MySpacing.xy(24, 8),
            child: MyText.labelSmall(
              label.toUpperCase(),
              color: leftBarTheme.labelColor,
              muted: true,
              maxLines: 1,
              overflow: TextOverflow.clip,
              fontWeight: 700,
            ),
          );
  }
}

class LabelWidget extends StatefulWidget {
  final bool isCondensed;
  final String label;

  const LabelWidget(
      {super.key, required this.isCondensed, required this.label});

  @override
  State<LabelWidget> createState() => _LabelWidgetState();
}

class _LabelWidgetState extends State<LabelWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.isCondensed) {
      return SizedBox();
    }
    return Container(
        margin: MySpacing.fromLTRB(16, 0, 16, 8),
        child: MyText.bodySmall(
          widget.label,
          muted: true,
          fontWeight: 600,
        ));
  }
}

class MenuWidget extends StatefulWidget {
  final IconData iconData;
  final String title;
  final bool isCondensed;
  final bool active;
  final List<MenuItem> children;

  const MenuWidget(
      {super.key,
      required this.iconData,
      required this.title,
      this.isCondensed = false,
      this.active = false,
      this.children = const []});

  @override
  _MenuWidgetState createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget>
    with UIMixin, SingleTickerProviderStateMixin {
  bool isHover = false;
  bool isActive = false;
  late Animation<double> _iconTurns;
  late AnimationController _controller;
  bool popupShowing = true;
  Function? hideFn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    _iconTurns = _controller.drive(Tween<double>(begin: 0.0, end: 0.5)
        .chain(CurveTween(curve: Curves.easeIn)));
    LeftbarObserver.attachListener(widget.title, onChangeMenuActive);
  }

  void onChangeMenuActive(String key) {
    if (key != widget.title) {
      onChangeExpansion(false);
    }
  }

  void onChangeExpansion(value) {
    isActive = value;
    if (isActive) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var route = UrlService.getCurrentUrl();
    isActive = widget.children.any((element) => element.route == route);
    onChangeExpansion(isActive);
    if (hideFn != null) {
      hideFn!();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isCondensed) {
      return CustomPopupMenu(
        backdrop: true,
        show: popupShowing,
        hideFn: (_) => hideFn = _,
        onChange: (_) {
          popupShowing = _;
        },
        placement: CustomPopupMenuPlacement.right,
        menu: MouseRegion(
          cursor: SystemMouseCursors.click,
          onHover: (event) {
            setState(() {
              isHover = true;
            });
          },
          onExit: (event) {
            setState(() {
              isHover = false;
            });
          },
          child: MyContainer.transparent(
            margin: MySpacing.fromLTRB(16, 0, 16, 8),
            color: isActive || isHover
                ? leftBarTheme.activeItemBackground
                : Colors.transparent,
            padding: MySpacing.xy(8, 8),
            child: Center(
              child: Icon(
                widget.iconData,
                color: (isHover || isActive)
                    ? leftBarTheme.activeItemColor
                    : leftBarTheme.onBackground,
                size: 20,
              ),
            ),
          ),
        ),
        menuBuilder: (_) => MyContainer(
          paddingAll: 8,
          borderRadiusAll: 8,
          width: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: widget.children,
          ),
        ),
      );
    } else {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        onHover: (event) {
          setState(() {
            isHover = true;
          });
        },
        onExit: (event) {
          setState(() {
            isHover = false;
          });
        },
        child: MyContainer.transparent(
          margin: MySpacing.fromLTRB(24, 0, 16, 0),
          paddingAll: 0,
          child: ListTileTheme(
            contentPadding: const EdgeInsets.all(0),
            dense: true,
            horizontalTitleGap: 0.0,
            minLeadingWidth: 0,
            child: ExpansionTile(
                tilePadding: MySpacing.zero,
                initiallyExpanded: isActive,
                maintainState: true,
                onExpansionChanged: (_) {
                  LeftbarObserver.notifyAll(widget.title);
                  onChangeExpansion(_);
                },
                trailing: RotationTransition(
                  turns: _iconTurns,
                  child: Icon(
                    LucideIcons.chevronDown,
                    size: 18,
                    color: leftBarTheme.onBackground,
                  ),
                ),
                iconColor: leftBarTheme.activeItemColor,
                childrenPadding: MySpacing.x(12),
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      widget.iconData,
                      size: 20,
                      color: isHover || isActive
                          ? leftBarTheme.activeItemColor
                          : leftBarTheme.onBackground,
                    ),
                    MySpacing.width(18),
                    Expanded(
                      child: MyText.labelLarge(
                        widget.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        color: isHover || isActive
                            ? leftBarTheme.activeItemColor
                            : leftBarTheme.onBackground,
                      ),
                    ),
                  ],
                ),
                collapsedBackgroundColor: Colors.transparent,
                shape: const RoundedRectangleBorder(
                  side: BorderSide(color: Colors.transparent),
                ),
                backgroundColor: Colors.transparent,
                children: widget.children),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
    LeftbarObserver.detachListener(widget.title);
  }
}

class MenuItem extends StatefulWidget {
  final IconData? iconData;
  final String title;
  final bool isCondensed;
  final String? route;

  const MenuItem({
    Key? key,
    this.iconData,
    required this.title,
    this.isCondensed = false,
    this.route,
  }) : super(key: key);

  @override
  _MenuItemState createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> with UIMixin {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    //bool isActive = UrlService.getCurrentUrl() == widget.route;
    return GestureDetector(
      onTap: () {
        if (widget.route != null) {
          if (widget.route == "/admin/customers/detail" ||
              widget.route == "/admin/customers/edit" ||
              widget.route == "/admin/customers/timetable" ||
              widget.route == "/admin/customers/equipment" ||
              widget.route == "/admin/customers/historical" ||
              widget.route == "/admin/customers/orders") {
            if (clienteSelezionato != null) {
              Get.toNamed(widget.route!);
            } else {
              Get.toNamed("/admin/customers/list");
            }
          } else {
            Get.toNamed(widget.route!);
          }
        }
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onHover: (event) {
          setState(() {
            isHover = true;
          });
        },
        onExit: (event) {
          setState(() {
            isHover = false;
          });
        },
        child: MyContainer.transparent(
          margin: MySpacing.fromLTRB(4, 0, 8, 4),
          color: /* isActive ||*/
              isHover ? leftBarTheme.activeItemBackground : Colors.transparent,
          width: MediaQuery.of(context).size.width,
          padding: MySpacing.xy(18, 7),
          child: MyText.bodySmall(
            "${widget.isCondensed ? "-" : "- "}  ${widget.title}",
            overflow: TextOverflow.clip,
            maxLines: 1,
            textAlign: TextAlign.left,
            fontSize: 12.5,
            color: /*isActive ||*/ isHover
                ? leftBarTheme.activeItemColor
                : leftBarTheme.onBackground,
            fontWeight: /* isActive ||*/ isHover ? 600 : 500,
          ),
        ),
      ),
    );
  }
}

class NavigationItem extends StatefulWidget {
  final IconData? iconData;
  final String title;
  final bool isCondensed;
  final String? route;

  const NavigationItem(
      {Key? key,
      this.iconData,
      required this.title,
      this.isCondensed = false,
      this.route})
      : super(key: key);

  @override
  _NavigationItemState createState() => _NavigationItemState();
}

class _NavigationItemState extends State<NavigationItem> with UIMixin {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    //bool isActive = UrlService.getCurrentUrl() == widget.route;
    return GestureDetector(
      onTap: () {
        if (widget.route != null) {
          if (widget.route == "/cart" || widget.route == "/list") {
            if (clienteSelezionato != null) {
              if (clienteSelezionato?.attivo == true) {
                Get.toNamed(widget.route!);
              }
              // Get.toNamed(widget.route!);
            } else {
              Get.toNamed("/admin/customers/list");
            }
          } else {
            //isActive = UrlService.getCurrentUrl() == widget.route;
            Get.toNamed(widget.route!);
          }
          //MyRouter.pushReplacementNamed(context, widget.route!, arguments: 1);
        }
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onHover: (event) {
          setState(() {
            isHover = true;
          });
        },
        onExit: (event) {
          setState(() {
            isHover = false;
          });
        },
        child: MyContainer(
          margin: MySpacing.fromLTRB(16, 0, 16, 8),
          color: /*isActive ||*/
              isHover ? leftBarTheme.activeItemBackground : Colors.transparent,
          padding: MySpacing.xy(8, 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.iconData != null)
                Center(
                  child: Icon(
                    widget.iconData,
                    color: (isHover /*|| isActive*/)
                        ? leftBarTheme.activeItemColor
                        : leftBarTheme.onBackground,
                    size: 20,
                  ),
                ),
              if (!widget.isCondensed)
                Flexible(
                  fit: FlexFit.loose,
                  child: MySpacing.width(16),
                ),
              if (!widget.isCondensed)
                Expanded(
                  flex: 3,
                  child: MyText.labelLarge(
                    widget.title,
                    overflow: TextOverflow.clip,
                    maxLines: 1,
                    color: /* isActive || */ isHover
                        ? leftBarTheme.activeItemColor
                        : leftBarTheme.onBackground,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
