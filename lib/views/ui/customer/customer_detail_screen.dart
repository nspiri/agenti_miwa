import 'package:flutter/material.dart';
import 'package:foody/controller/ui/customer/customer_detail_controller.dart';
import 'package:foody/helpers/theme/app_style.dart';
import 'package:foody/helpers/utils/global.dart';
import 'package:foody/helpers/utils/show_message_dialogs.dart';
import 'package:foody/helpers/utils/ui_mixins.dart';
import 'package:foody/helpers/utils/utils.dart';
import 'package:foody/helpers/widgets/my_breadcrumb.dart';
import 'package:foody/helpers/widgets/my_breadcrumb_item.dart';
import 'package:foody/helpers/widgets/my_button.dart';
import 'package:foody/helpers/widgets/my_container.dart';
import 'package:foody/helpers/widgets/my_flex.dart';
import 'package:foody/helpers/widgets/my_flex_item.dart';
import 'package:foody/helpers/widgets/my_responsiv.dart';
import 'package:foody/helpers/widgets/my_spacing.dart';
import 'package:foody/helpers/widgets/my_text.dart';
import 'package:foody/helpers/widgets/my_text_style.dart';
import 'package:foody/helpers/widgets/responsive.dart';
import 'package:foody/model/customer_detail.dart';
import 'package:foody/model/scadenziario_cliente.dart';
import 'package:foody/views/layout/layout.dart';
import 'package:foody/widgets/custom_pop_menu.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CustomerDetailScreen extends StatefulWidget {
  const CustomerDetailScreen({super.key});
  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen>
    with SingleTickerProviderStateMixin, UIMixin {
  late CustomerDetailController controller;
  late CustomerDetail? cliente;

  @override
  void initState() {
    cliente = Get.arguments;
    cliente ??= clienteSelezionato;
    controller = Get.put(CustomerDetailController(context: context));
    controller.getData(cliente!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: MyResponsive(builder: (BuildContext context, _, screenMT) {
        return GetBuilder(
          init: controller,
          builder: (controller) {
            return Column(
              children: [
                Padding(
                  padding: MySpacing.x(flexSpacing / 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      screenMT.isMobile ? Container() : pulsanti(),
                      MyBreadcrumb(
                        children: [
                          MyBreadcrumbItem(
                            name: 'Dettaglio',
                            active: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                MySpacing.height(flexSpacing),
                MyFlex(children: [
                  MyFlexItem(
                      sizes: 'lg-4 md-6 sm-6',
                      child: dettaglioCliente(screenMT)),
                  MyFlexItem(
                    sizes: 'lg-8 md-6 sm-6',
                    child: MyFlex(
                      children: [
                        MyFlexItem(
                            sizes: 'lg-12 md-12 sm-12',
                            child: screenMT.isMobile
                                ? progressiviMobile()
                                : progressivi()),
                        MyFlexItem(
                            sizes: 'lg-6 md-12 sm-12', child: noteCliente()),
                        MyFlexItem(
                            sizes: 'lg-6 md-12 sm-12',
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: giorniConsegna(),
                            )),
                      ],
                    ),
                  ),
                ]),
              ],
            );
          },
        );
      }),
    );
  }

  Widget menuPulsanti() {
    return MyContainer.bordered(
      paddingAll: 0,
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: MySpacing.xy(8, 8),
            child: MyButton(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onPressed: () =>
                    {controller.goToOrder(cliente?.codiceCliente ?? "")},
                borderRadiusAll: AppStyle.buttonRadius.medium,
                padding: MySpacing.xy(8, 4),
                splashColor: contentTheme.danger.withAlpha(28),
                backgroundColor: Colors.transparent,
                child: MyText.labelMedium(
                  "Nuovo ordine",
                  fontWeight: 600,
                )),
          ),
          Padding(
            padding: MySpacing.xy(8, 8),
            child: MyButton(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onPressed: () => {Get.toNamed('/admin/customers/orders')},
                borderRadiusAll: AppStyle.buttonRadius.medium,
                padding: MySpacing.xy(8, 4),
                splashColor: contentTheme.danger.withAlpha(28),
                backgroundColor: Colors.transparent,
                child: MyText.labelMedium(
                  "Ordini in corso",
                  fontWeight: 600,
                )),
          ),
          Padding(
            padding: MySpacing.xy(8, 8),
            child: MyButton(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onPressed: () => {Get.toNamed('/admin/customers/timetable')},
                borderRadiusAll: AppStyle.buttonRadius.medium,
                padding: MySpacing.xy(8, 4),
                splashColor: contentTheme.danger.withAlpha(28),
                backgroundColor: Colors.transparent,
                child: MyText.labelMedium(
                  "Scadenziario",
                  fontWeight: 600,
                )),
          ),
          Padding(
            padding: MySpacing.xy(8, 8),
            child: MyButton(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onPressed: () => {Get.toNamed('/admin/customers/historical')},
                borderRadiusAll: AppStyle.buttonRadius.medium,
                padding: MySpacing.xy(8, 4),
                splashColor: contentTheme.danger.withAlpha(28),
                backgroundColor: Colors.transparent,
                child: MyText.labelMedium(
                  "Storico",
                  fontWeight: 600,
                )),
          ),
          Padding(
            padding: MySpacing.xy(8, 8),
            child: MyButton(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onPressed: () {
                  if (cliente?.attrezzature != null) {
                    if (cliente!.attrezzature!.isNotEmpty) {
                      Get.toNamed('/admin/customers/equipment');
                    } else {
                      showAlertMessage(context, "Attenzione",
                          "Il cliente non ha attrezzature assegnate");
                    }
                  }
                },
                borderRadiusAll: AppStyle.buttonRadius.medium,
                padding: MySpacing.xy(8, 4),
                splashColor: contentTheme.danger.withAlpha(28),
                backgroundColor: Colors.transparent,
                child: MyText.labelMedium(
                  "Attrezzature",
                  fontWeight: 600,
                )),
          )
        ],
      ),
    );
  }

  Widget pulsanti() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        MyButton.rounded(
          onPressed: () {
            controller.goToOrder(cliente?.codiceCliente ?? "");
          },
          elevation: 0,
          padding: MySpacing.xy(20, 16),
          backgroundColor: contentTheme.primary,
          child: MyText.bodySmall(
            'Nuovo ordine',
            color: contentTheme.onPrimary,
          ),
        ),
        MySpacing.width(8),
        MyButton.rounded(
          onPressed: () {
            Get.toNamed('/admin/customers/orders');
          },
          elevation: 0,
          padding: MySpacing.xy(20, 16),
          backgroundColor: contentTheme.primary,
          child: MyText.bodySmall(
            'Ordini in corso',
            color: contentTheme.onPrimary,
          ),
        ),
        MySpacing.width(8),
        MyButton.rounded(
          onPressed: () {
            Get.toNamed('/admin/customers/timetable');
          },
          elevation: 0,
          padding: MySpacing.xy(20, 16),
          backgroundColor: contentTheme.primary,
          child: MyText.bodySmall(
            'Scadenziario',
            color: contentTheme.onPrimary,
          ),
        ),
        MySpacing.width(8),
        MyButton.rounded(
          onPressed: () {
            Get.toNamed('/admin/customers/historical');
          },
          elevation: 0,
          padding: MySpacing.xy(20, 16),
          backgroundColor: contentTheme.primary,
          child: MyText.bodySmall(
            'Storico',
            color: contentTheme.onPrimary,
          ),
        ),
        MySpacing.width(8),
        MyButton.rounded(
          onPressed: () {
            if (cliente?.attrezzature != null) {
              if (cliente!.attrezzature!.isNotEmpty) {
                Get.toNamed('/admin/customers/equipment');
              } else {
                showAlertMessage(
                    context, "Il cliente non ha attrezzature assegnate", "");
              }
            }
          },
          elevation: 0,
          padding: MySpacing.xy(20, 16),
          backgroundColor: contentTheme.primary,
          child: MyText.bodySmall(
            'Attrezzature',
            color: contentTheme.onPrimary,
          ),
        ),
      ],
    );
  }

  Widget dettaglioCliente(MyScreenMediaType screenMT) {
    String attivita = "";
    if (controller.dettaglio?.tipoAttivita != null) {
      for (var element in controller.dettaglio!.tipoAttivita!) {
        attivita += "${element.des}, ";
      }
    }
    return MyFlex(runSpacing: 0, children: [
      MyFlexItem(
          child: MyContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: buildProfileDetail(
                      'Codice', controller.dettaglio?.codiceCliente ?? ""),
                ),
                screenMT.isMobile
                    ? CustomPopupMenu(
                        backdrop: true,
                        onChange: (_) {},
                        offsetX: -110,
                        offsetY: 0,
                        menu: Padding(
                          padding: MySpacing.xy(8, 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              MyContainer.roundBordered(
                                  paddingAll: 8,
                                  child: Icon(Icons.more_vert, size: 20)),
                            ],
                          ),
                        ),
                        menuBuilder: (_) => menuPulsanti(),
                      )
                    : Container()
              ],
            ),
            MySpacing.height(10),
            buildProfileDetail(
                'Rag. Sociale', controller.dettaglio?.ragioneSociale ?? ""),
            MySpacing.height(10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: buildProfileDetail(
                      'Nazionalità',
                      controller.getNazionalita(
                              controller.dettaglio?.nazionalita) ??
                          ""),
                ),
                MySpacing.width(10),
                Expanded(
                  flex: 0,
                  child: buildProfileDetail(
                      'Paese',
                      controller.getPaese(controller.dettaglio?.siglaNazione) ??
                          ""),
                ),
              ],
            ),
            MySpacing.height(10),
            buildProfileDetail(
                'Indirizzo', controller.dettaglio?.indirizzo ?? ""),
            MySpacing.height(10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 2,
                  child: buildProfileDetail(
                      'Cap', controller.dettaglio?.cap ?? ""),
                ),
                MySpacing.width(10),
                Expanded(
                  flex: 0,
                  child: buildProfileDetail(
                      'Località', controller.dettaglio?.localita ?? ""),
                ),
                MySpacing.width(10),
                Flexible(
                  flex: 1,
                  child: buildProfileDetail(
                      'Provincia', controller.dettaglio?.provincia ?? ""),
                ),
              ],
            ),
            MySpacing.height(10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: buildProfileDetail(
                      'Telefono', controller.dettaglio?.telefono ?? ""),
                ),
                MySpacing.width(10),
                Expanded(
                  flex: 0,
                  child: buildProfileDetail(
                      'Cellulare', controller.dettaglio?.fax ?? ""),
                ),
              ],
            ),
            MySpacing.height(10),
            buildProfileDetail(
                'Sito Internet', controller.dettaglio?.sitoInternet ?? ""),
            MySpacing.height(10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: buildProfileDetail(
                      'Cod. Fisc.', controller.dettaglio?.codiceFiscale ?? ""),
                ),
                MySpacing.width(10),
                Expanded(
                  flex: 0,
                  child: buildProfileDetail(
                      'P. Iva', controller.dettaglio?.partitaIva ?? ""),
                ),
              ],
            ),
            buildProfileDetail('Tipo Attività', attivita),
            MySpacing.height(10),
            buildProfileDetail(
                'Giorni Di Chiusura', controller.dettaglio?.nota1 ?? ""),
            MySpacing.height(10),
            buildProfileDetail(
                'Orario Chiusura', controller.dettaglio?.nota2 ?? ""),
            MySpacing.height(10),
            Divider(),
            MySpacing.height(10),
            /* MyText.bodyLarge("Condizioni commerciali", fontWeight: 600),
            MySpacing.height(10),*/
            buildProfileDetail(
                'Pag. Abituale', controller.dettaglio?.descPagamento ?? ""),
            MySpacing.height(10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: buildProfileDetail('Fido',
                      "€ ${Utils.formatStringDecimal(double.parse(controller.dettaglio?.valFido ?? ""), 2)}"),
                ),
                MySpacing.width(10),
                Expanded(
                  flex: 0,
                  child: buildProfileDetail('Rischio',
                      "€ ${Utils.formatStringDecimal(double.parse(controller.dettaglio?.rischio ?? ""), 2)}"),
                ),
              ],
            ),
            MySpacing.height(10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: buildProfileDetail('Categ. Statistica',
                      controller.dettaglio?.descCatStat ?? ""),
                ),
                MySpacing.width(10),
                Expanded(
                  flex: 0,
                  child: buildProfileDetail(
                      'Categ. Zona', controller.dettaglio?.descZona ?? ""),
                ),
              ],
            ),
            MySpacing.height(10),
            buildProfileDetail(
                'Fatturare a', controller.dettaglio?.ragSocFattA ?? ""),
            MySpacing.height(10),
            /* Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: buildProfileDetail('Listino Vendita',
                      controller.dettaglio?.descListino ?? ""),
                ),
                MySpacing.width(10),
                Expanded(
                  flex: 0,
                  child: buildProfileDetail(
                      'Assog. Iva', controller.dettaglio?.assoggIva ?? ""),
                ),
              ],
            ),
            MySpacing.height(10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: buildProfileDetail('Categ. Provviggioni',
                      controller.dettaglio?.descCatProv ?? ""),
                ),
                MySpacing.width(10),
                Expanded(
                  flex: 0,
                  child: buildProfileDetail('Categ. Sconti',
                      controller.dettaglio?.descCatSconti ?? ""),
                ),
              ],
            ),
            MySpacing.height(10),
            buildProfileDetail('Sconto Incond.',
                controller.dettaglio?.scontoIncondizionato ?? ""),*/
          ],
        ),
      )),
    ]);
  }

  Widget progressivi() {
    return MyContainer(
      //height: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: MyText.titleMedium("Progressivi", fontWeight: 600),
              ),
            ],
          ),
          MySpacing.height(12),
          Row(
            children: [
              MyContainer.rounded(
                paddingAll: 8,
                color: contentTheme.primary,
                child: Icon(LucideIcons.euro,
                    size: 20, color: contentTheme.onPrimary),
              ),
              MySpacing.width(12),
              MyText.bodyMedium("Val. Ordini/Bolle In Corso", fontWeight: 600),
              Spacer(),
              MyText.bodyLarge(
                  "€ ${Utils.formatStringDecimal(double.parse(controller.dettaglio?.valoreOrdini ?? "0"), 2)}",
                  fontWeight: 600),
            ],
          ),
          MySpacing.height(8),
          Divider(),
          MySpacing.height(8),
          Row(
            children: [
              MyContainer.rounded(
                paddingAll: 8,
                color: contentTheme.primary,
                child: Icon(LucideIcons.euro,
                    size: 20, color: contentTheme.onPrimary),
              ),
              MySpacing.width(12),
              MyText.bodyMedium("Fatturato Anno Precedente", fontWeight: 600),
              Spacer(),
              MyText.bodyLarge(
                  "€ ${Utils.formatStringDecimal(double.parse(controller.dettaglio?.fattAnnPrec ?? "0"), 2)}",
                  fontWeight: 600),
            ],
          ),
          MySpacing.height(8),
          Divider(),
          MySpacing.height(8),
          Row(
            children: [
              MyContainer.rounded(
                paddingAll: 8,
                color: contentTheme.primary,
                child: Icon(LucideIcons.euro,
                    size: 20, color: contentTheme.onPrimary),
              ),
              MySpacing.width(12),
              MyText.bodyMedium("Fatturato Anno Corrente", fontWeight: 600),
              Spacer(),
              MyText.bodyLarge(
                  "€ ${Utils.formatStringDecimal(double.parse(controller.dettaglio?.fattAnnCorr ?? "0"), 2)}",
                  fontWeight: 600),
            ],
          ),
          MySpacing.height(8),
          Divider(),
          MySpacing.height(8),
          Row(
            children: [
              MyContainer.rounded(
                paddingAll: 8,
                color: contentTheme.primary,
                child: Icon(LucideIcons.calendar,
                    size: 20, color: contentTheme.onPrimary),
              ),
              MySpacing.width(12),
              MyText.bodyMedium("Data doc. ultima consegna", fontWeight: 600),
              Spacer(),
              MyText.bodyLarge(
                  Utils.getFormattedDate(
                      controller.dettaglio?.dataUltimaConsegna ?? ""),
                  fontWeight: 600),
            ],
          ),
          MySpacing.height(8),
          Divider(),
          MySpacing.height(8),
          Row(
            children: [
              MyContainer.rounded(
                paddingAll: 8,
                color: contentTheme.primary,
                child: Icon(LucideIcons.paperclip,
                    size: 20, color: contentTheme.onPrimary),
              ),
              MySpacing.width(12),
              MyText.bodyMedium("Documento ultima consegna", fontWeight: 600),
              Spacer(),
              MyText.bodyLarge("${controller.dettaglio?.docUltimaConsegna}",
                  fontWeight: 600),
            ],
          ),
        ],
      ),
    );
  }

  Widget progressiviMobile() {
    return MyContainer(
      //height: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: MyText.titleMedium("Progressivi", fontWeight: 600),
              ),
            ],
          ),
          MySpacing.height(12),
          Row(
            children: [
              MyContainer.rounded(
                paddingAll: 8,
                color: contentTheme.primary,
                child: Icon(LucideIcons.euro,
                    size: 20, color: contentTheme.onPrimary),
              ),
              MySpacing.width(12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText.bodyMedium("Val. Ordini/Bolle In Corso",
                      fontWeight: 600),
                  MyText.bodyLarge(
                      "€ ${Utils.formatStringDecimal(double.parse(controller.dettaglio?.valoreOrdini ?? "0"), 2)}",
                      fontWeight: 600),
                ],
              ),
            ],
          ),
          MySpacing.height(8),
          Divider(),
          MySpacing.height(8),
          Row(
            children: [
              MyContainer.rounded(
                paddingAll: 8,
                color: contentTheme.primary,
                child: Icon(LucideIcons.euro,
                    size: 20, color: contentTheme.onPrimary),
              ),
              MySpacing.width(12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText.bodyMedium("Fatturato Anno Precedente",
                      fontWeight: 600),
                  MyText.bodyLarge(
                      "€ ${Utils.formatStringDecimal(double.parse(controller.dettaglio?.fattAnnPrec ?? "0"), 2)}",
                      fontWeight: 600),
                ],
              ),
            ],
          ),
          MySpacing.height(8),
          Divider(),
          MySpacing.height(8),
          Row(
            children: [
              MyContainer.rounded(
                paddingAll: 8,
                color: contentTheme.primary,
                child: Icon(LucideIcons.euro,
                    size: 20, color: contentTheme.onPrimary),
              ),
              MySpacing.width(12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText.bodyMedium("Fatturato Anno Corrente", fontWeight: 600),
                  MyText.bodyLarge(
                      "€ ${Utils.formatStringDecimal(double.parse(controller.dettaglio?.fattAnnCorr ?? "0"), 2)}",
                      fontWeight: 600),
                ],
              ),
            ],
          ),
          MySpacing.height(8),
          Divider(),
          MySpacing.height(8),
          Row(
            children: [
              MyContainer.rounded(
                paddingAll: 8,
                color: contentTheme.primary,
                child: Icon(LucideIcons.calendar,
                    size: 20, color: contentTheme.onPrimary),
              ),
              MySpacing.width(12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText.bodyMedium("Data doc. ultima consegna",
                      fontWeight: 600),
                  MyText.bodyLarge(
                      Utils.getFormattedDate(
                          controller.dettaglio?.dataUltimaConsegna ?? ""),
                      fontWeight: 600),
                ],
              ),
            ],
          ),
          MySpacing.height(8),
          Divider(),
          MySpacing.height(8),
          Row(
            children: [
              MyContainer.rounded(
                paddingAll: 8,
                color: contentTheme.primary,
                child: Icon(LucideIcons.paperclip,
                    size: 20, color: contentTheme.onPrimary),
              ),
              MySpacing.width(12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText.bodyMedium("Documento ultima consegna",
                      fontWeight: 600),
                  MyText.bodyLarge("${controller.dettaglio?.docUltimaConsegna}",
                      fontWeight: 600),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget scadenziario() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (controller.scadenzoario.isNotEmpty)
              SizedBox(
                width: double.infinity,
                child: PaginatedDataTable(
                  header: Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyText.titleMedium(
                                "Scadenziario",
                                fontWeight: 600,
                              ),
                            ]),
                      ],
                    ),
                  ),
                  sortAscending: true,
                  onSelectAll: (_) => {},
                  dataRowMaxHeight: 52,
                  //columnSpacing: 170,
                  showFirstLastButtons: true,
                  showCheckboxColumn: true,
                  columns: [
                    DataColumn(
                        label: MyText.labelLarge(
                      'Doc.',
                    )),
                    DataColumn(
                        numeric: true,
                        label: MyText.labelLarge(
                          'Numero',
                        )),
                    DataColumn(
                        label: MyText.labelLarge(
                      'Data',
                    )),
                    DataColumn(
                        label: MyText.labelLarge(
                      'Tipo Pagamento',
                    )),
                    DataColumn(
                        label: MyText.labelLarge(
                      'Scadenza',
                    )),
                    DataColumn(
                        numeric: true,
                        label: MyText.labelLarge(
                          'Importo',
                        )),
                  ],
                  source: controller.data!,
                  rowsPerPage: controller.data!.rowCount > 10
                      ? 10
                      : controller.data!.rowCount,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget noteCliente() {
    return MyContainer(
      height: 255,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: MyText.titleMedium("Note", fontWeight: 600),
              ),
            ],
          ),
          MySpacing.height(12),
          Expanded(
            child: TextFormField(
              controller: controller.note,
              keyboardType: TextInputType.multiline,
              maxLines: 10,
              decoration: InputDecoration(
                hintText: "Inserisci qui le note per questo cliente",
                hintStyle: MyTextStyle.bodySmall(xMuted: true),
                border: outlineInputBorder,
                enabledBorder: outlineInputBorder,
                focusedBorder: focusedInputBorder,
                contentPadding: MySpacing.all(16),
                isCollapsed: true,
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
            ),
          ),
          MySpacing.height(12),
          Padding(
            padding: MySpacing.right(0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MyContainer(
                  paddingAll: 8,
                  onTap: () {
                    controller.salvaNote(cliente!.codiceCliente!);
                  },
                  color: contentTheme.primary.withAlpha(40),
                  child: Row(
                    children: [
                      controller.ok == null
                          ? Icon(LucideIcons.save,
                              size: 20, color: contentTheme.primary)
                          : controller.ok == true
                              ? Icon(Icons.done,
                                  size: 20, color: contentTheme.primary)
                              : Icon(Icons.error,
                                  size: 20, color: contentTheme.primary),
                      MySpacing.width(8),
                      MyText.bodyMedium("Salva",
                          fontWeight: 600, color: contentTheme.primary)
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget giorniConsegna() {
    return Visibility(
      visible: controller.dettaglio?.giorniConsegne?.isNotEmpty ?? false,
      child: MyContainer(
        //height: 255,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: MyText.titleMedium("Giorni consegne", fontWeight: 600),
                ),
              ],
            ),
            MySpacing.height(12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText.bodyMedium("Giorno", fontWeight: 600),
                MyText.bodyMedium("Giro", fontWeight: 600),
                MyText.bodyMedium("Chiusura", fontWeight: 600)
              ],
            ),
            MySpacing.height(8),
            for (var i = 0;
                i < (controller.dettaglio?.giorniConsegne?.length ?? 0);
                i++)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyText.bodyMedium(
                      "${controller.dettaglio?.giorniConsegne?[i].giorno}"),
                  MyText.bodyMedium(
                      "${controller.dettaglio?.giorniConsegne?[i].giro}"),
                  MyText.bodyMedium(
                      "${controller.dettaglio?.giorniConsegne?[i].chiusuraOrdini}")
                ],
              )
            /*ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: controller.dettaglio?.giorniConsegne?.length ?? 0,
                itemBuilder: (context, index) {
                  GiorniConsegne data =
                      controller.dettaglio!.giorniConsegne![index];
                  return MyContainer(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MyText.bodyMedium("${data.giorno}"),
                          MyText.bodyMedium("${data.giro}"),
                          MyText.bodyMedium("${data.chiusuraOrdini}")
                        ],
                      )
    
                      /*  MyFlex(children: [
                      MyFlexItem(
                          sizes: "sm-4 md-4 lg-4",
                          child: MyText.bodyMedium("${data.giorno}")),
                      MyFlexItem(
                          sizes: "sm-4 md-4 lg-4",
                          child: MyText.bodyMedium("${data.giro}")),
                      MyFlexItem(
                          sizes: "sm-4 md-4 lg-4",
                          child: MyText.bodyMedium("${data.chiusuraOrdini}"))
                    ])*/
                      );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 12,
                  );
                },
              ),*/
          ],
        ),
      ),
    );
  }

  Widget buildProfileDetail(String title, String subTitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText.bodySmall(title),
        MyText.bodyMedium(subTitle, fontWeight: 600),
      ],
    );
  }

  Widget buildProfileOverView(Color color, IconData icon, String title,
      String subTitle, String text1, String text2) {
    return MyContainer(
      height: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              MyContainer.rounded(
                paddingAll: 8,
                color: color,
                child: Icon(icon, size: 20, color: contentTheme.onPrimary),
              ),
              MySpacing.width(12),
              MyText.bodyMedium(title, fontWeight: 600),
              Spacer(),
              MyText.bodyLarge(subTitle, fontWeight: 600),
            ],
          ),
          Divider(),
          MyText.bodyMedium(text1, fontWeight: 600, xMuted: true),
          MyText.bodyMedium(text2, fontWeight: 600, xMuted: true),
        ],
      ),
    );
  }
}

class MyDataDetailScadenziario extends DataTableSource with UIMixin {
  List<ScadenziarioCliente> listaScadenziario = [];

  MyDataDetailScadenziario(this.listaScadenziario);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => listaScadenziario.length;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    ScadenziarioCliente scadenza = listaScadenziario[index];

    return DataRow(
      cells: [
        DataCell(MyText.bodyMedium(
          "${scadenza.documento}",
          fontWeight: 600,
        )),
        DataCell(MyText.bodyMedium(
          "${scadenza.serie}/${scadenza.numero}",
          fontWeight: 600,
        )),
        DataCell(MyText.bodyMedium(
          Utils.getFormattedDate(scadenza.data!),
          fontWeight: 600,
        )),
        DataCell(MyText.bodyMedium(
          "${scadenza.tipoPagamento}",
          fontWeight: 600,
        )),
        DataCell(MyText.bodyMedium(
          Utils.getFormattedDate(scadenza.dataScadenza!),
          fontWeight: 600,
        )),
        DataCell(MyText.bodyMedium(
          "€ ${Utils.formatStringDecimal(scadenza.importo, 2)}",
          fontWeight: 600,
        )),
      ],
    );
  }

  void gotoEdit(String clientId) {
    Get.toNamed('/admin/customers/edit', arguments: clientId);
  }

  void gotoDetail(String clientId) {
    Get.toNamed('/admin/customers/detail', arguments: clientId);
  }
}
