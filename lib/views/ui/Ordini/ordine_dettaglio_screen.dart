// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:foody/controller/ui/Ordini/ordine_dettaglio_controller.dart';
import 'package:foody/helpers/utils/global.dart';
import 'package:foody/helpers/utils/ui_mixins.dart';
import 'package:foody/helpers/utils/utils.dart';
import 'package:foody/helpers/widgets/my_container.dart';
import 'package:foody/helpers/widgets/my_flex.dart';
import 'package:foody/helpers/widgets/my_flex_item.dart';
import 'package:foody/helpers/widgets/my_spacing.dart';
import 'package:foody/helpers/widgets/my_text.dart';
import 'package:foody/helpers/widgets/my_text_style.dart';
import 'package:foody/helpers/widgets/responsive.dart';
import 'package:foody/images.dart';
import 'package:foody/model/ordine.dart';
import 'package:foody/views/layout/layout.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({super.key});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen>
    with SingleTickerProviderStateMixin, UIMixin {
  late OrderDetailController controller;
  late Ordine? ordine;

  @override
  void initState() {
    ordine = Get.arguments;
    ordine ??= ordineSelezionato;
    controller = Get.put(OrderDetailController(context: context));
    controller.getData(ordine!);
    super.initState();
  }

  /* _displayStoricoArticolo(BuildContext context, Articolo art) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: Duration(milliseconds: 300),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return SafeArea(
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: ModalListaStoricoArticolo(
                codCliente: cliente?.codiceCliente ?? "",
                articolo: art,
              )),
        );
      },
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: GetBuilder(
        init: controller,
        builder: (controller) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: MySpacing.x(flexSpacing),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyText.titleMedium(
                        "Dettaglio ordine",
                        fontSize: 18,
                        fontWeight: 600,
                      ),
                      MySpacing.width(8),
                      MyContainer(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        paddingAll: 8,
                        color: contentTheme.primary,
                        child: Row(
                          children: [
                            Icon(
                              LucideIcons.doorClosed,
                              size: 20,
                              color: contentTheme.onPrimary,
                            ),
                            MySpacing.width(8),
                            MyText.bodyMedium(
                              "Chiudi",
                              color: contentTheme.onPrimary,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                MySpacing.height(flexSpacing),
                Padding(
                  padding: MySpacing.x(flexSpacing / 2),
                  child: MyFlex(
                    children: [
                      MyFlexItem(
                          sizes: 'lg-7',
                          child: !controller.loading
                              ? listaCarrello()
                              : Column(
                                  children: [
                                    MyText.titleLarge(
                                      "Caricamento...",
                                      fontWeight: 600,
                                    ),
                                    MySpacing.height(24),
                                    CircularProgressIndicator(
                                      color: contentTheme.primary,
                                      strokeWidth: 3,
                                    ),
                                  ],
                                )),
                      MyFlexItem(
                          sizes: 'lg-5',
                          child: MyContainer(
                            child: buildCard(),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget listaCarrello() {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: controller.righeDett.length,
      itemBuilder: (context, index) {
        RigaDettaglio data = controller.righeDett[index];
        return MyContainer(
            width: double.infinity,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: immagine(data),
                ),
                Expanded(
                  child: descrizione(data),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: quantita(data),
                ),
              ],
            ));
      },
      separatorBuilder: (context, index) {
        return SizedBox(
          height: 12,
        );
      },
    );
  }

  Widget immagine(RigaDettaglio data) {
    return MyContainer(
      height: 100,
      width: 100,
      paddingAll: 0,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: data.arime != null
          ? Image.memory(
              data.arime!,
              fit: BoxFit.cover,
            )
          : Image(
              image: ExactAssetImage(Images.noImage),
              fit: BoxFit.cover,
            ),
    );
  }

  Widget descrizione(RigaDettaglio data) {
    return MyFlex(
      wrapCrossAlignment: WrapCrossAlignment.center,
      children: [
        MyFlexItem(
          sizes: "md-12 lg-12 sm-12",
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  /*InkWell(
                    onTap: () {
                      _displayStoricoArticolo(context, data);
                    },
                    child: Icon(
                      LucideIcons.history,
                      size: 26,
                      color: contentTheme.primary,
                    ),
                  ),
                  MySpacing.width(8),*/
                  MyText.bodyMedium(
                    "${data.ocdsc} (${Utils.formatStringDecimal(data.ocqta, 2)} ${data.arum})",
                    fontWeight: 600,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: MyText.bodySmall(
                  "Codice: ${data.ocart}",
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: MyText.bodySmall(
                  "Prezzo: € ${Utils.formatStringDecimal(data.ocprz, 3)}",
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: MyText.bodySmall(
                    "Sconto: ${data.ocsco == "" ? "Nessuno sconto" : data.ocsco}${data.ocsco == "" ? "" : "%"}"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget quantita(RigaDettaglio data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          child: MyText.titleMedium(
            maxLines: 1,
            "${Utils.formatStringDecimal((data.occol ?? 0).toDouble(), 0)} * ${Utils.formatStringDecimal(data.ocqta, 2)} ${data.arum}",
            fontWeight: 800,
            textAlign: TextAlign.right,
          ),
        ),
        MySpacing.height(4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            MyText.bodyLarge("€ ${Utils.formatStringDecimal((data.ocruv), 2)}",
                fontWeight: 800),
            MySpacing.height(4),
            MyText.bodySmall(
              " Iva ${data.ocali?.trim()}%",
            ),
          ],
        ),
        /*  MySpacing.height(4),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Center(
              child: MyText.bodySmall(
                "Prov: ",
                //fontWeight: 600,
              ),
            ),
            MyText.bodySmall(
              "${data.ocpro}%",
              //fontWeight: 600,
            ),
          ],
        ),*/
      ],
    );
  }

  dropdown<T>(
      List<DropdownMenuItem<T>> items,
      Function(T? value) onChanged,
      String title,
      T? valoreSelezionato,
      List<Widget> Function(BuildContext)? selectedBuilder) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText.labelMedium(
          title,
        ),
        MySpacing.height(4),
        DropdownButtonFormField<T>(
          dropdownColor: contentTheme.background,
          isDense: true,
          items: items,
          icon: Icon(
            LucideIcons.chevronDown,
            size: 20,
          ),
          decoration: InputDecoration(
            hintStyle: MyTextStyle.bodySmall(xMuted: true),
            border: outlineInputBorder,
            enabledBorder: outlineInputBorder,
            focusedBorder: focusedInputBorder,
            contentPadding: MySpacing.all(8),
            isCollapsed: true,
            floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
          //validator: controller.basicValidator.getValidation(validation),
          value: valoreSelezionato,
          selectedItemBuilder: selectedBuilder,
          onChanged: (value) {
            onChanged(value);
          },
        )
      ],
    );
  }

  Widget buildCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText.bodyLarge(
                'Cliente',
                fontWeight: 600,
              ),
              MySpacing.height(20),
              MyText.bodyMedium(
                controller.ordine?.occliDesc ?? "",
                fontWeight: 600,
                muted: true,
              ),
              MySpacing.height(12),
              MyText.bodyMedium(
                "${controller.ordine?.occliLoc} (${controller.ordine?.occliPro})",
                fontWeight: 600,
                muted: true,
              ),
              MySpacing.height(12),
              Divider(),
              MySpacing.height(8),
              MyText.bodyLarge(
                'Pagamento',
                fontWeight: 600,
              ),
              MyText.bodyMedium(
                controller.ordine?.ocpagDesc ?? "",
                fontWeight: 600,
                muted: true,
              ),
              MySpacing.height(8),
              Divider(),
            ],
          ),
        ),
        MySpacing.height(8),
        MyText.bodyLarge(
          'Totale carrello',
          fontWeight: 600,
        ),
        MySpacing.height(20),
        buildCardDetail('Totale documento',
            '€ ${Utils.formatStringDecimal(controller.ordine?.octdo, 2)}'),
        MySpacing.height(12),
        buildCardDetail('Sconto abbuono',
            '€ ${Utils.formatStringDecimal(controller.ordine?.ocabb, 2)}'),
        /* MySpacing.height(12),
        buildCardDetail('= Totale da pagare',
            '€ ${Utils.formatStringDecimal(controller.ordine?.octdp, 2)}'),*/
        MySpacing.height(12),
        Divider(),
        MySpacing.height(12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText.bodyLarge(
              "Totale da pagare",
              fontWeight: 600,
            ),
            MyText.bodyLarge(
              '€ ${Utils.formatStringDecimal(controller.ordine?.octdp, 2)}',
              fontWeight: 600,
            )
          ],
        ),
        MySpacing.height(12),
      ],
    );
  }

  Widget buildCardDetail(String title, String subTitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MyText.bodyMedium(
          title,
          fontWeight: 600,
          muted: true,
        ),
        MyText.bodyMedium(
          subTitle,
          fontWeight: 600,
          muted: true,
        )
      ],
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
