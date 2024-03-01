import 'package:flutter/material.dart';
import 'package:foody/controller/ui/customer/customer_detail_controller.dart';
import 'package:foody/helpers/utils/global.dart';
import 'package:foody/helpers/utils/ui_mixins.dart';
import 'package:foody/helpers/utils/utils.dart';
import 'package:foody/helpers/widgets/my_breadcrumb.dart';
import 'package:foody/helpers/widgets/my_breadcrumb_item.dart';
import 'package:foody/helpers/widgets/my_container.dart';
import 'package:foody/helpers/widgets/my_flex.dart';
import 'package:foody/helpers/widgets/my_flex_item.dart';
import 'package:foody/helpers/widgets/my_spacing.dart';
import 'package:foody/helpers/widgets/my_text.dart';
import 'package:foody/helpers/widgets/my_text_style.dart';
import 'package:foody/helpers/widgets/responsive.dart';
import 'package:foody/model/customer_detail.dart';
import 'package:foody/model/order_detail.dart';
import 'package:foody/model/scadenziario_cliente.dart';
import 'package:foody/views/layout/layout.dart';
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
    controller = Get.put(CustomerDetailController());
    controller.getData(cliente!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String attivita = "";
    if (controller.dettaglio?.tipoAttivita != null) {
      for (var element in controller.dettaglio!.tipoAttivita!) {
        attivita += "${element.des}, ";
      }
    }

    return Layout(
      child: GetBuilder(
        init: controller,
        builder: (controller) {
          return Column(
            children: [
              Padding(
                padding: MySpacing.x(flexSpacing),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          /*MyContainer.rounded(
                            paddingAll: 0,
                            height: 60,
                            width: 60,
                            child: Icon(
                              LucideIcons.userCircle2,
                              size: 50,
                              color: contentTheme.primary,
                            ), /*Image.asset(
                                        Images.avatars[0],
                                        fit: BoxFit.cover,
                                      )*/
                          ),
                          MySpacing.width(12),*/
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyText.bodyLarge(
                                    controller.dettaglio?.ragioneSociale ?? "-",
                                    fontWeight: 600,
                                    maxLines: 2),
                                MyText.bodySmall(
                                    controller.dettaglio?.codiceCliente ?? "",
                                    maxLines: 1),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    /*MyText.titleMedium(
                      "Dettaglio Cliente",
                      fontSize: 18,
                      fontWeight: 600,
                    ),*/
                    MyBreadcrumb(
                      children: [
                        MyBreadcrumbItem(name: 'Admin'),
                        MyBreadcrumbItem(
                            name: 'Dettaglio Cliente', active: true),
                      ],
                    ),
                  ],
                ),
              ),
              MySpacing.height(flexSpacing),
              Padding(
                padding: MySpacing.x(flexSpacing / 2),
                child: MyFlex(children: [
                  MyFlexItem(
                      sizes: 'lg-3 md-6',
                      child: MyFlex(contentPadding: false, children: [
                        MyFlexItem(
                            child: MyContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Divider(height: 40),
                              //if (controller.dettaglio?.email != "")
                              buildProfileDetail(
                                  'E-mail', controller.dettaglio?.email ?? "-"),
                              //if (controller.dettaglio?.email != "")
                              MySpacing.height(20),
                              //if (controller.dettaglio?.telefono != "")
                              buildProfileDetail('Telefono',
                                  controller.dettaglio?.telefono ?? "-"),
                              //if (controller.dettaglio?.telefono != "")
                              MySpacing.height(20),
                              //if (controller.dettaglio?.codiceFiscale != "")
                              buildProfileDetail('Codice Fiscale',
                                  controller.dettaglio?.codiceFiscale ?? "-"),
                              //if (controller.dettaglio?.codiceFiscale != "")
                              MySpacing.height(20),
                              //if (controller.dettaglio?.partitaIva != "")
                              buildProfileDetail('Partita Iva',
                                  controller.dettaglio?.partitaIva ?? "-"),
                              //if (controller.dettaglio?.partitaIva != "")
                              MySpacing.height(20),
                              //if (controller.dettaglio?.localita != "")
                              buildProfileDetail('Località',
                                  "${controller.dettaglio?.siglaNazione} ${controller.dettaglio?.localita} (${controller.dettaglio?.provincia}) - ${controller.dettaglio?.cap}"),
                              //if (controller.dettaglio?.localita != "")
                              MySpacing.height(20),
                              //if (controller.dettaglio?.indirizzo != "")
                              buildProfileDetail('Indirizzo',
                                  controller.dettaglio?.indirizzo ?? "-"),
                              //if (controller.dettaglio?.indirizzo != "")
                              MySpacing.height(20),
                              //if (controller.dettaglio?.sitoInternet != "")
                              buildProfileDetail('Sito Internet',
                                  controller.dettaglio?.sitoInternet ?? "-"),
                              //if (controller.dettaglio?.sitoInternet != "")
                              MySpacing.height(20),
                              //if (attivita != "")
                              buildProfileDetail('Tipo Attività', attivita),
                              /*if (attivita != "")*/ MySpacing.height(20),
                              //if (controller.dettaglio?.nota1 != "")
                              buildProfileDetail('Giorni Di Chiusura',
                                  controller.dettaglio?.nota1 ?? "-"),
                              //if (controller.dettaglio?.nota1 != "")
                              MySpacing.height(20),
                              //if (controller.dettaglio?.nota2 != "")
                              buildProfileDetail('Orario Chiusura',
                                  controller.dettaglio?.nota2 ?? ""),
                              //if (controller.dettaglio?.nota2 != "")
                              MySpacing.height(20),
                              if (controller.dettaglio?.descPagamento != "")
                                buildProfileDetail('Pag. Abituale',
                                    controller.dettaglio?.descPagamento ?? ""),
                            ],
                          ),
                        )),
                      ])),
                  MyFlexItem(
                    sizes: 'lg-9 md-6',
                    child: MyFlex(
                      contentPadding: false,
                      children: [
                        MyFlexItem(
                          sizes: 'lg-6 md-12',
                          child: MyContainer(
                            height: 250,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: MyText.titleMedium("Progressivi",
                                          fontWeight: 600),
                                    ),
                                    Spacer(),
                                    MyContainer.rounded(
                                      paddingAll: 0,
                                      height: 50,
                                      width: 50,
                                      child: IconButton(
                                        icon: Icon(
                                          LucideIcons.history,
                                          size: 40,
                                        ),
                                        color: contentTheme.primary,
                                        onPressed: () {
                                          Get.toNamed('/admin/customers/edit');
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    MyContainer.rounded(
                                      paddingAll: 8,
                                      color: contentTheme.primary,
                                      child: Icon(LucideIcons.euro,
                                          size: 20,
                                          color: contentTheme.onPrimary),
                                    ),
                                    MySpacing.width(12),
                                    MyText.bodyMedium(
                                        "Val. Ordini/Bolle In Corso",
                                        fontWeight: 600),
                                    Spacer(),
                                    MyText.bodyLarge(
                                        "€ ${controller.dettaglio?.valoreOrdini}",
                                        fontWeight: 600),
                                  ],
                                ),
                                Divider(),
                                Row(
                                  children: [
                                    MyContainer.rounded(
                                      paddingAll: 8,
                                      color: contentTheme.primary,
                                      child: Icon(LucideIcons.euro,
                                          size: 20,
                                          color: contentTheme.onPrimary),
                                    ),
                                    MySpacing.width(12),
                                    MyText.bodyMedium(
                                        "Fatturato Anno Precedente",
                                        fontWeight: 600),
                                    Spacer(),
                                    MyText.bodyLarge(
                                        "€ ${controller.dettaglio?.fattAnnPrec}",
                                        fontWeight: 600),
                                  ],
                                ),
                                Divider(),
                                Row(
                                  children: [
                                    MyContainer.rounded(
                                      paddingAll: 8,
                                      color: contentTheme.primary,
                                      child: Icon(LucideIcons.euro,
                                          size: 20,
                                          color: contentTheme.onPrimary),
                                    ),
                                    MySpacing.width(12),
                                    MyText.bodyMedium("Fatturato Anno Corrente",
                                        fontWeight: 600),
                                    Spacer(),
                                    MyText.bodyLarge(
                                        "€ ${controller.dettaglio?.fattAnnCorr}",
                                        fontWeight: 600),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        MyFlexItem(
                          sizes: 'lg-6 md-12',
                          child: MyContainer(
                            height: 250,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: MyText.titleMedium("Note",
                                          fontWeight: 600),
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
                                      hintText:
                                          "Inserisci qui le note per questo cliente",
                                      hintStyle:
                                          MyTextStyle.bodySmall(xMuted: true),
                                      border: outlineInputBorder,
                                      enabledBorder: outlineInputBorder,
                                      focusedBorder: focusedInputBorder,
                                      contentPadding: MySpacing.all(16),
                                      isCollapsed: true,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                    ),
                                  ),
                                ),
                                MySpacing.height(12),
                                Padding(
                                  padding: MySpacing.right(12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      MyContainer(
                                        paddingAll: 8,
                                        onTap: () {
                                          controller.salvaNote(
                                              cliente!.codiceCliente!);
                                        },
                                        color:
                                            contentTheme.primary.withAlpha(40),
                                        child: Row(
                                          children: [
                                            controller.ok == null
                                                ? Icon(LucideIcons.save,
                                                    size: 20,
                                                    color: contentTheme.primary)
                                                : controller.ok == true
                                                    ? Icon(Icons.done,
                                                        size: 20,
                                                        color: contentTheme
                                                            .primary)
                                                    : Icon(Icons.error,
                                                        size: 20,
                                                        color: contentTheme
                                                            .primary),
                                            MySpacing.width(8),
                                            MyText.bodyMedium("Salva",
                                                fontWeight: 600,
                                                color: contentTheme.primary)
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        MyFlexItem(
                          child: Column(
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
                                          padding:
                                              const EdgeInsets.only(top: 16),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
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
                                        rowsPerPage:
                                            controller.data!.rowCount > 10
                                                ? 10
                                                : controller.data!.rowCount,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        /* buildProfileOverView(
                              contentTheme.primary,
                              LucideIcons.euro,
                              "Val. Ordini/Bolle In Corso",
                              "€ ${controller.dettaglio?.valoreOrdini}",
                              "Point Used: 150",
                              "Outstanding: 200"),
                        )*/
                        /* MyFlexItem(
                            sizes: 'lg-4',
                            child: MyContainer(
                              height: 150,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      MyContainer.rounded(
                                        paddingAll: 8,
                                        color: contentTheme.danger,
                                        child: Icon(LucideIcons.eye,
                                            size: 20,
                                            color: contentTheme.onPrimary),
                                      ),
                                      MySpacing.width(12),
                                      MyText.bodyMedium('Total Visit',
                                          fontWeight: 600),
                                      Spacer(),
                                      MyText.bodyLarge('180', fontWeight: 600),
                                    ],
                                  ),
                                  MySpacing.height(8),
                                  Divider(),
                                  MySpacing.height(20),
                                  MyText.bodyMedium("Last Visit: 24 Aug 2022",
                                      fontWeight: 600, xMuted: true),
                                ],
                              ),
                            )),*/
                      ],
                    ),
                  ),
//TABELLA
                ]),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildProfileDetail(String title, String subTitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText.bodyMedium(title, fontWeight: 600),
        MyText.bodyMedium(subTitle, fontWeight: 600, xMuted: true),
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
