import 'package:flutter/material.dart';
import 'package:foody/controller/ui/customer/add_customer_controller.dart';
import 'package:foody/helpers/theme/app_themes.dart';
import 'package:foody/helpers/utils/ui_mixins.dart';
import 'package:foody/helpers/widgets/my_breadcrumb.dart';
import 'package:foody/helpers/widgets/my_breadcrumb_item.dart';
import 'package:foody/helpers/widgets/my_button.dart';
import 'package:foody/helpers/widgets/my_container.dart';
import 'package:foody/helpers/widgets/my_flex.dart';
import 'package:foody/helpers/widgets/my_flex_item.dart';
import 'package:foody/helpers/widgets/my_form_validator.dart';
import 'package:foody/helpers/widgets/my_spacing.dart';
import 'package:foody/helpers/widgets/my_text.dart';
import 'package:foody/helpers/widgets/my_text_style.dart';
import 'package:foody/helpers/widgets/responsive.dart';
import 'package:foody/model/customer_category.dart';
import 'package:foody/model/nazionalita.dart';
import 'package:foody/model/pagamenti.dart';
import 'package:foody/model/tipo_attivita.dart';
import 'package:foody/model/tipo_soc.dart';
import 'package:foody/model/zone_clienti.dart';
import 'package:foody/views/layout/layout.dart';
import 'package:get/get.dart';
import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:time_range/time_range.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:search_choices/search_choices.dart';

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen>
    with SingleTickerProviderStateMixin, UIMixin {
  late AddCustomerController controller;

  @override
  void initState() {
    controller = Get.put(AddCustomerController(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                    MyText.titleMedium(
                      "Aggiungi Cliente",
                      fontSize: 18,
                      fontWeight: 600,
                    ),
                    MyBreadcrumb(
                      children: [
                        MyBreadcrumbItem(name: 'Admin'),
                        MyBreadcrumbItem(
                            name: 'Aggiungi Cliente', active: true),
                      ],
                    ),
                  ],
                ),
              ),
              MySpacing.height(flexSpacing),
              Padding(
                padding: MySpacing.x(flexSpacing),
                child: MyContainer(
                  padding: MySpacing.xy(0, 10),
                  child: Form(
                    autovalidateMode: AutovalidateMode.disabled,
                    key: controller.basicValidator.formKey,
                    child: Column(
                      children: [
                        MyFlex(
                          runSpacing: 8,
                          children: [
                            MyFlexItem(
                                sizes: "md-6 sm-12",
                                child: MyFlex(runSpacing: 8, children: [
                                  MyFlexItem(
                                    sizes: "md-12 sm-12",
                                    child: buildTextField(
                                        'Rag. Sociale',
                                        "",
                                        controller.basicValidator
                                            .getController("ragioneSociale"),
                                        controller.basicValidator
                                            .getValidation("ragioneSociale"),
                                        true,
                                        60,
                                        TextInputType.text),
                                  ),
                                  MyFlexItem(
                                    sizes: "md-6 sm-12",
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: CheckboxListTile(
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        contentPadding: EdgeInsets.zero,
                                        dense: true,
                                        title: MyText.bodyMedium(
                                          "Privato",
                                          fontWeight: 600,
                                        ),
                                        value: controller.isChecked,
                                        onChanged: (value) =>
                                            controller.onChangeCheckBox(value),
                                      ),
                                    ),
                                  ),
                                  MyFlexItem(
                                    sizes: "md-6 sm-12",
                                    child: buildDropDownField<TipoSocieta>(
                                        controller.tipoSocieta
                                            .map(
                                              (societa) =>
                                                  DropdownMenuItem<TipoSocieta>(
                                                value: societa,
                                                child: MyText.labelMedium(
                                                  societa.descrizione ?? "",
                                                ),
                                              ),
                                            )
                                            .toList(), (value) {
                                      controller.tiposocietaSelezionata = value;
                                      controller.update();
                                    }, "tipoSoc", "Tipo società",
                                        controller.tiposocietaSelezionata),
                                  ),
                                  MyFlexItem(
                                    sizes: "md-6 sm-12",
                                    child: buildTextField(
                                        'Cod. Fiscale',
                                        "",
                                        controller.basicValidator
                                            .getController("codFisc"),
                                        controller.basicValidator
                                            .getValidation("codFisc"),
                                        true,
                                        16,
                                        TextInputType.text),
                                  ),
                                  MyFlexItem(
                                    sizes: "md-6 sm-12",
                                    child: buildTextField(
                                        'Partita Iva',
                                        "",
                                        controller.basicValidator
                                            .getController("partIva"),
                                        controller.basicValidator
                                            .getValidation("partIva"),
                                        !controller.isChecked,
                                        11,
                                        TextInputType.text),
                                  ),
                                  MyFlexItem(
                                    sizes: "md-6 sm-12",
                                    child: buildDropDownField<Nazionalita>(
                                        controller.nazionalita
                                            .map(
                                              (naz) =>
                                                  DropdownMenuItem<Nazionalita>(
                                                value: naz,
                                                child: MyText.labelMedium(
                                                  naz.descrizione ?? "",
                                                ),
                                              ),
                                            )
                                            .toList(), (value) {
                                      controller.nazionalitaSelezionata = value;
                                      controller.update();
                                    }, "nazionalita", "Nazionalità",
                                        controller.nazionalitaSelezionata),
                                  ),
                                  MyFlexItem(
                                      sizes: "md-6 sm-12",
                                      child: searchChoise(
                                          "Paese",
                                          controller.basicValidator
                                              .getController("paese"),
                                          "P",
                                          controller.basicValidator
                                              .getValidation("paese"))),
                                  MyFlexItem(
                                    sizes: "md-12 sm-12",
                                    child: buildTextField(
                                        'Indirizzo',
                                        "",
                                        controller.basicValidator
                                            .getController("indirizzo"),
                                        controller.basicValidator
                                            .getValidation("indirizzo"),
                                        true,
                                        48,
                                        TextInputType.text),
                                  ),
                                  MyFlexItem(
                                    sizes: "md-3 sm-12",
                                    child: buildTextField(
                                        'Cap',
                                        "",
                                        controller.basicValidator
                                            .getController("cap"),
                                        controller.basicValidator
                                            .getValidation("cap"),
                                        true,
                                        5,
                                        TextInputType.number),
                                  ),
                                  MyFlexItem(
                                      sizes: "md-7 sm-12",
                                      child: searchChoise(
                                          "Località",
                                          controller.basicValidator
                                              .getController("localita"),
                                          "L",
                                          controller.basicValidator
                                              .getValidation("localita"))),
                                  MyFlexItem(
                                    sizes: "md-2 sm-12",
                                    child: buildTextField(
                                        'Prov.',
                                        "",
                                        controller.basicValidator
                                            .getController("provincia"),
                                        controller.basicValidator
                                            .getValidation("provincia"),
                                        true,
                                        4,
                                        TextInputType.text),
                                  ),
                                  MyFlexItem(
                                    sizes: "md-6 sm-12",
                                    child: buildTextField(
                                        'Telefono',
                                        "",
                                        controller.basicValidator
                                            .getController("telefono"),
                                        controller.basicValidator
                                            .getValidation("telefono"),
                                        true,
                                        24,
                                        TextInputType.number),
                                  ),
                                  MyFlexItem(
                                    sizes: "md-6 sm-12",
                                    child: buildTextField(
                                        'Cellulare',
                                        "",
                                        controller.basicValidator
                                            .getController("fax"),
                                        controller.basicValidator
                                            .getValidation("fax"),
                                        true,
                                        24,
                                        TextInputType.number),
                                  ),
                                  MyFlexItem(
                                    sizes: "md-12 sm-12",
                                    child: buildTextField(
                                        "Email",
                                        "",
                                        controller.basicValidator
                                            .getController("email"),
                                        controller.basicValidator
                                            .getValidation("email"),
                                        true,
                                        60,
                                        TextInputType.emailAddress),
                                  ),
                                  MyFlexItem(
                                    sizes: "md-8 sm-12",
                                    child: buildTextField(
                                        'Pec',
                                        "",
                                        controller.basicValidator
                                            .getController("pec"),
                                        controller.basicValidator
                                            .getValidation("pec"),
                                        true,
                                        60,
                                        TextInputType.emailAddress),
                                  ),
                                  MyFlexItem(
                                    sizes: "md-4 sm-12",
                                    child: buildTextField(
                                        'Codice SDI',
                                        "",
                                        controller.basicValidator
                                            .getController("codSDI"),
                                        controller.basicValidator
                                            .getValidation("codSDI"),
                                        true,
                                        7,
                                        TextInputType.text),
                                  ),
                                ])),
                            MyFlexItem(
                                sizes: "md-6 sm-12",
                                child: MyFlex(
                                  runSpacing: 8,
                                  children: [
                                    /* MyFlexItem(
                                      sizes: "md-12 sm-12",
                                      child: buildDropDownField<Pagamenti>(
                                          controller.pagamenti
                                              .map(
                                                (naz) =>
                                                    DropdownMenuItem<Pagamenti>(
                                                  value: naz,
                                                  child: MyText.labelMedium(
                                                    naz.descrizione ?? "",
                                                  ),
                                                ),
                                              )
                                              .toList(), (value) {
                                        controller.pagamentoSelezionato = value;
                                        controller.update();
                                      }, "pagamenti", "Pagamento",
                                          controller.pagamentoSelezionato),
                                    ),*/
                                    MyFlexItem(
                                      sizes: "md-12 sm-12",
                                      child: buildTextField(
                                          'Internet',
                                          "",
                                          controller.basicValidator
                                              .getController("internet"),
                                          controller.basicValidator
                                              .getValidation("internet"),
                                          true,
                                          60,
                                          TextInputType.text),
                                    ),
                                    MyFlexItem(
                                      sizes: "md-12 sm-12",
                                      child: buildDropDownField<ZoneClienti>(
                                          controller.zoneClienti
                                              .map(
                                                (zona) => DropdownMenuItem<
                                                    ZoneClienti>(
                                                  value: zona,
                                                  child: MyText.labelMedium(
                                                    zona.cydes ?? "",
                                                  ),
                                                ),
                                              )
                                              .toList(), (value) {
                                        controller.zonaClienteSelezionata =
                                            value;
                                        controller.update();
                                      }, "zoneCli", "Zone Clienti",
                                          controller.zonaClienteSelezionata),
                                    ),
                                    MyFlexItem(
                                      sizes: "md-12 sm-12",
                                      child:
                                          buildDropDownField<CustomerCategory>(
                                              controller.categorieClienti
                                                  .map(
                                                    (cat) => DropdownMenuItem<
                                                        CustomerCategory>(
                                                      value: cat,
                                                      child: MyText.labelMedium(
                                                        cat.cxdes ?? "",
                                                      ),
                                                    ),
                                                  )
                                                  .toList(), (value) {
                                        controller.categoriaClienteSelezionata =
                                            value;
                                        controller.update();
                                      },
                                              "catCli",
                                              "Categoria Cliente",
                                              controller
                                                  .categoriaClienteSelezionata),
                                    ),
                                    MyFlexItem(
                                        sizes: "md-12 sm-12",
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            MyText.labelMedium(
                                              "Tipo Attività",
                                            ),
                                            MySpacing.height(4),
                                            MultiSelectDropDown(
                                              hint: "",
                                              showClearIcon: false,
                                              controller: controller
                                                  .controllerTipoAttivita,
                                              onOptionSelected: (options) {},
                                              options: <ValueItem<
                                                  TipoAttivita>>[
                                                ...controller.tipoAttivita
                                              ],

                                              optionTextStyle:
                                                  MyTextStyle.labelMedium(),
                                              inputDecoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(4)),
                                                border: Border.all(
                                                    strokeAlign: 1,
                                                    color: theme.colorScheme
                                                        .onBackground
                                                        .withAlpha(80),
                                                    width: 1),
                                              ),
                                              selectionType:
                                                  SelectionType.multi,
                                              chipConfig: const ChipConfig(
                                                  wrapType: WrapType.wrap),
                                              //dropdownHeight: 300,
                                              selectedOptionIcon: const Icon(
                                                  Icons.check_circle),
                                              selectedOptionBackgroundColor:
                                                  contentTheme.background,
                                              selectedOptionTextColor:
                                                  contentTheme.primary,
                                              dropdownBackgroundColor:
                                                  contentTheme.background,
                                              dropdownMargin: 5,
                                              optionsBackgroundColor:
                                                  contentTheme.background,
                                            ),
                                          ],
                                        )),
                                    MyFlexItem(
                                        sizes: "md-12 sm-12",
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            MyText.labelMedium(
                                              "Giorni di chiusura",
                                            ),
                                            MySpacing.height(4),
                                            MultiSelectDropDown(
                                              hint: "",
                                              showClearIcon: false,
                                              controller:
                                                  controller.controllerGiorni,
                                              onOptionSelected: (options) {},
                                              options: <ValueItem<List>>[
                                                ...controller.giorni
                                              ],
                                              optionTextStyle:
                                                  MyTextStyle.labelMedium(),
                                              inputDecoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(4)),
                                                border: Border.all(
                                                    strokeAlign: 1,
                                                    color: theme.colorScheme
                                                        .onBackground
                                                        .withAlpha(80),
                                                    width: 1),
                                              ),
                                              selectionType:
                                                  SelectionType.multi,
                                              chipConfig: const ChipConfig(
                                                  wrapType: WrapType.wrap),
                                              //dropdownHeight: 300,
                                              selectedOptionIcon: const Icon(
                                                  Icons.check_circle),
                                              selectedOptionBackgroundColor:
                                                  contentTheme.background,
                                              selectedOptionTextColor:
                                                  contentTheme.primary,
                                              dropdownBackgroundColor:
                                                  contentTheme.background,
                                              dropdownMargin: 5,
                                              optionsBackgroundColor:
                                                  contentTheme.background,
                                            ),
                                          ],
                                        )),
                                    MyFlexItem(
                                        sizes: "md-12 sm-12",
                                        child: TimeRange(
                                            fromTitle: MyText.labelMedium(
                                                "Chiuso dalle"),
                                            toTitle: MyText.labelMedium("Alle"),
                                            titlePadding: 0,
                                            textStyle: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                color: contentTheme.cardText),
                                            activeTextStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: contentTheme.primary),
                                            borderColor:
                                                contentTheme.cardBorder,
                                            backgroundColor: Colors.transparent,
                                            activeBackgroundColor:
                                                contentTheme.background,
                                            firstTime:
                                                TimeOfDay(hour: 9, minute: 0),
                                            lastTime:
                                                TimeOfDay(hour: 21, minute: 00),
                                            timeStep: 30,
                                            timeBlock: 30,
                                            onRangeCompleted: (range) {
                                              controller
                                                  .setOrarioChiusura(range);
                                            },
                                            onFirstTimeSelected:
                                                (startHour) {})),
                                    MyFlexItem(
                                      sizes: "md-12 sm-12",
                                      child: buildTextField(
                                          'Note',
                                          "",
                                          controller.basicValidator
                                              .getController("nota2"),
                                          controller.basicValidator
                                              .getValidation("nota2"),
                                          true,
                                          199,
                                          TextInputType.text),
                                    ),
                                  ],
                                )),

                            /* Separatore */
                            MyFlexItem(
                                child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Divider(),
                            )),
                            /* Separatore */
                            MyFlexItem(
                              sizes: "md-12 sm-12",
                              child: CheckboxListTile(
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                title: MyText.bodyLarge(
                                  "Destinazione diversa",
                                  fontWeight: 600,
                                ),
                                value: controller.destDiversa,
                                onChanged: (value) =>
                                    controller.onChangeDestDiversa(value),
                              ),
                            ),
                            MyFlexItem(
                                sizes: "md-6 sm-12",
                                child: Visibility(
                                  visible: controller.destDiversa,
                                  child: MyFlex(
                                    runSpacing: 8,
                                    children: [
                                      MyFlexItem(
                                        sizes: "md-12 sm-12",
                                        child: buildTextField(
                                            'Rag. Sociale',
                                            "",
                                            controller.basicValidator
                                                .getController("ragSocDest"),
                                            controller.basicValidator
                                                .getValidation("ragSocDest"),
                                            true,
                                            60,
                                            TextInputType.text),
                                      ),
                                      MyFlexItem(
                                        sizes: "md-6 sm-12",
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 12),
                                          child: CheckboxListTile(
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            contentPadding: EdgeInsets.zero,
                                            dense: true,
                                            title: MyText.bodyMedium(
                                              "Privato",
                                              fontWeight: 600,
                                            ),
                                            value: controller.isCheckedDest,
                                            onChanged: (value) => controller
                                                .onChangeCheckBoxDest(value),
                                          ),
                                        ),
                                      ),
                                      MyFlexItem(
                                        sizes: "md-6 sm-12",
                                        child: buildDropDownField<TipoSocieta>(
                                            controller.tipoSocieta
                                                .map(
                                                  (societa) => DropdownMenuItem<
                                                      TipoSocieta>(
                                                    value: societa,
                                                    child: MyText.labelMedium(
                                                      societa.descrizione ?? "",
                                                    ),
                                                  ),
                                                )
                                                .toList(), (value) {
                                          controller
                                                  .tiposocietaSelezionataDest =
                                              value;
                                          controller.update();
                                        },
                                            "tipoSocDest",
                                            "Tipo società",
                                            controller
                                                .tiposocietaSelezionataDest),
                                      ),
                                      MyFlexItem(
                                        sizes: "md-6 sm-12",
                                        child: buildTextField(
                                            'Cod. Fiscale',
                                            "",
                                            controller.basicValidator
                                                .getController("codFiscDest"),
                                            controller.basicValidator
                                                .getValidation("codFiscDest"),
                                            true,
                                            16,
                                            TextInputType.text),
                                      ),
                                      MyFlexItem(
                                        sizes: "md-6 sm-12",
                                        child: buildTextField(
                                            'Partita Iva',
                                            "",
                                            controller.basicValidator
                                                .getController("partIvaDest"),
                                            controller.basicValidator
                                                .getValidation("partIvaDest"),
                                            !controller.isCheckedDest,
                                            11,
                                            TextInputType.text),
                                      ),
                                    ],
                                  ),
                                )),
                            MyFlexItem(
                                sizes: "md-6 sm-12",
                                child: Visibility(
                                  visible: controller.destDiversa,
                                  child: MyFlex(
                                    runSpacing: 8,
                                    children: [
                                      MyFlexItem(
                                        sizes: "md-6 sm-12",
                                        child: buildDropDownField<Nazionalita>(
                                            controller.nazionalita
                                                .map(
                                                  (naz) => DropdownMenuItem<
                                                      Nazionalita>(
                                                    value: naz,
                                                    child: MyText.labelMedium(
                                                      naz.descrizione ?? "",
                                                    ),
                                                  ),
                                                )
                                                .toList(), (value) {
                                          controller
                                                  .nazionalitaSelezionataDest =
                                              value;
                                          controller.update();
                                        },
                                            "nazionalitaDest",
                                            "Nazionalità",
                                            controller
                                                .nazionalitaSelezionataDest),
                                      ),
                                      MyFlexItem(
                                          sizes: "md-6 sm-12",
                                          child: searchChoise(
                                              "Paese",
                                              controller.basicValidator
                                                  .getController("paeseDest"),
                                              "PD",
                                              controller.basicValidator
                                                  .getValidation("paeseDest"))),
                                      MyFlexItem(
                                        sizes: "md-12 sm-12",
                                        child: buildTextField(
                                            'Indirizzo',
                                            "",
                                            controller.basicValidator
                                                .getController("indirizzoDest"),
                                            controller.basicValidator
                                                .getValidation("indirizzoDest"),
                                            true,
                                            48,
                                            TextInputType.text),
                                      ),
                                      MyFlexItem(
                                        sizes: "md-3 sm-12",
                                        child: buildTextField(
                                            'Cap',
                                            "",
                                            controller.basicValidator
                                                .getController("capDest"),
                                            controller.basicValidator
                                                .getValidation("capDest"),
                                            true,
                                            5,
                                            TextInputType.number),
                                      ),
                                      MyFlexItem(
                                          sizes: "md-7 sm-12",
                                          child: searchChoise(
                                              "Località",
                                              controller.basicValidator
                                                  .getController(
                                                      "localitaDest"),
                                              "LD",
                                              controller.basicValidator
                                                  .getValidation(
                                                      "localitaDest"))
                                          /*Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              MyText.labelMedium(
                                                "Località",
                                              ),
                                              MySpacing.height(4),
                                              DropDownSearchFormField(
                                                textFieldConfiguration:
                                                    TextFieldConfiguration(
                                                  decoration: InputDecoration(
                                                    hintText: "",
                                                    hintStyle:
                                                        MyTextStyle.bodySmall(
                                                            xMuted: true),
                                                    border: outlineInputBorder,
                                                    contentPadding:
                                                        MySpacing.all(12),
                                                    isCollapsed: true,
                                                    floatingLabelBehavior:
                                                        FloatingLabelBehavior
                                                            .never,
                                                    /*suffixIcon: InkWell(
                                                  onTap: () {
                                                    _dropdownSearchFieldController
                                                        .text = "";
                                                    setState(() {});
                                                  },
                                                  child:
                                                      Icon(Icons.cancel_outlined))*/
                                                  ),
                                                  controller: controller
                                                      .comuneDestTextController,
                                                ),
                                                suggestionsCallback: (pattern) {
                                                  return controller
                                                      .getComuni(pattern);
                                                },
                                                suggestionsBoxDecoration:
                                                    SuggestionsBoxDecoration(
                                                        color: contentTheme
                                                            .background),
                                                itemBuilder: (context,
                                                    Comuni suggestion) {
                                                  return ListTile(
                                                    title: MyText.labelMedium(
                                                      suggestion.localita ?? "",
                                                    ),
                                                  );
                                                },
                                                transitionBuilder: (context,
                                                    suggestionsBox,
                                                    controller) {
                                                  return suggestionsBox;
                                                },
                                                onSuggestionSelected:
                                                    (Comuni suggestion) {
                                                  controller
                                                      .comuneDestTextController
                                                      .text = suggestion
                                                          .localita ??
                                                      "";
                                                  controller
                                                          .comuneSelezionatoDest =
                                                      suggestion;
                                                  controller.basicValidator
                                                      .getController("capDest")
                                                      ?.text = suggestion
                                                          .cap ??
                                                      "";
                                                  controller.basicValidator
                                                          .getController(
                                                              "provinciaDest")
                                                          ?.text =
                                                      suggestion.provincia ??
                                                          "";
                                                },
                                                suggestionsBoxController:
                                                    controller
                                                        .basicValidator
                                                        .getController(
                                                            "localitaDest"),
                                                validator: controller
                                                    .basicValidator
                                                    .getValidation(
                                                        "localitaDest"),
                                                displayAllSuggestionWhenTap:
                                                    false,
                                              )
                                            ],
                                          )*/
                                          ),
                                      MyFlexItem(
                                        sizes: "md-2 sm-12",
                                        child: buildTextField(
                                            'Prov.',
                                            "",
                                            controller.basicValidator
                                                .getController("provinciaDest"),
                                            controller.basicValidator
                                                .getValidation("provinciaDest"),
                                            true,
                                            4,
                                            TextInputType.text),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                        MySpacing.height(12),
                        Padding(
                          padding: MySpacing.right(12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              MyContainer.bordered(
                                paddingAll: 8,
                                onTap: () {
                                  controller.pulisciCampi();
                                },
                                child: Row(
                                  children: [
                                    Icon(LucideIcons.x, size: 20),
                                    MySpacing.width(8),
                                    MyText.bodyMedium(
                                      "Cancella",
                                      fontWeight: 600,
                                    )
                                  ],
                                ),
                              ),
                              MySpacing.width(12),
                              MyButton.rounded(
                                onPressed: controller.inserisciCliente,
                                elevation: 0,
                                padding: MySpacing.xy(20, 18),
                                backgroundColor: contentTheme.primary,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    controller.loading
                                        ? SizedBox(
                                            height: 14,
                                            width: 14,
                                            child: CircularProgressIndicator(
                                              color:
                                                  theme.colorScheme.onPrimary,
                                              strokeWidth: 1.2,
                                            ),
                                          )
                                        : Container(),
                                    if (controller.loading) MySpacing.width(16),
                                    MyText.bodySmall(
                                      'Salva',
                                      color: contentTheme.onPrimary,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  searchChoise<T>(String titolo, TextEditingController controller, String tipo,
      String? Function(String?)? validator) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText.labelMedium(
          titolo,
        ),
        MySpacing.height(4),
        TextFormField(
          keyboardType: TextInputType.none,
          controller: controller,
          validator: validator,
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(builder: (context, setState) {
                    return AlertDialog(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: MyText.titleLarge("Seleziona")),
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.cancel_outlined,
                                size: 30,
                              ))
                        ],
                      ),
                      content: tipo == "P"
                          ? paesiDialog(setState)
                          : tipo == "PD"
                              ? paesiDestDialog(setState)
                              : tipo == "L"
                                  ? localitaDialog(setState)
                                  : localitaDestDialog(setState),
                    );
                  });
                });
          },
          decoration: InputDecoration(
            suffixIcon: Icon(
              LucideIcons.chevronDown,
              size: 20,
            ),
            hintStyle: MyTextStyle.bodySmall(xMuted: true),
            border: outlineInputBorder,
            enabledBorder: outlineInputBorder,
            focusedBorder: focusedInputBorder,
            contentPadding: MySpacing.all(12),
            isCollapsed: true,
            floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
        ),
      ],
    );
  }

  Widget paesiDialog(void Function(void Function()) setState) {
    return Container(
      //height: 300.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(4),
                  ),
                ),
                prefixIcon: Icon(LucideIcons.search, size: 20),
                hintText: 'Cerca',
                contentPadding: MySpacing.xy(12, 8)),
            onChanged: (value) {
              controller.filtraPaesi(value);
              setState(() {});
            },
          ),
          MySpacing.height(8),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: controller.paesiFiltrati.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: MyText.labelLarge(
                    '${controller.paesiFiltrati[index].descrizione}',
                  ),
                  onTap: () {
                    controller.paeseSelezionato =
                        controller.paesiFiltrati[index];
                    controller.basicValidator.getController("paese").text =
                        controller.paeseSelezionato?.descrizione ?? "";
                    Navigator.pop(context);
                    controller.filtraPaesi("");
                    controller.update();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget paesiDestDialog(void Function(void Function()) setState) {
    return Container(
      //height: 300.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(4),
                  ),
                ),
                prefixIcon: Icon(LucideIcons.search, size: 20),
                hintText: 'Cerca',
                contentPadding: MySpacing.xy(12, 8)),
            onChanged: (value) {
              controller.filtraPaesi(value);
              setState(() {});
            },
          ),
          MySpacing.height(8),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: controller.paesiDestFiltrati.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: MyText.labelLarge(
                    '${controller.paesiDestFiltrati[index].descrizione}',
                  ),
                  onTap: () {
                    controller.paeseSelezionatoDest =
                        controller.paesiDestFiltrati[index];
                    controller.basicValidator.getController("paeseDest").text =
                        controller.paeseSelezionatoDest?.descrizione ?? "";
                    Navigator.pop(context);
                    controller.filtraPaesiDest("");
                    controller.update();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget localitaDialog(void Function(void Function()) setState) {
    return Container(
      //height: 300.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(4),
                  ),
                ),
                prefixIcon: Icon(LucideIcons.search, size: 20),
                hintText: 'Cerca',
                contentPadding: MySpacing.xy(12, 8)),
            onChanged: (value) {
              controller.filtraComuni(value);
              setState(() {});
            },
          ),
          MySpacing.height(8),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: controller.comuniFiltrati.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: MyText.labelLarge(
                    '${controller.comuniFiltrati[index].localita}',
                  ),
                  onTap: () {
                    controller.comuneSelezionato =
                        controller.comuniFiltrati[index];
                    controller.basicValidator.getController("localita").text =
                        controller.comuneSelezionato?.localita ?? "";
                    controller.basicValidator.getController("cap")?.text =
                        controller.comuneSelezionato?.cap ?? "";
                    controller.basicValidator.getController("provincia")?.text =
                        controller.comuneSelezionato?.provincia ?? "";
                    Navigator.pop(context);
                    controller.filtraComuni("");
                    controller.update();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget localitaDestDialog(void Function(void Function()) setState) {
    return Container(
      //height: 300.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(4),
                  ),
                ),
                prefixIcon: Icon(LucideIcons.search, size: 20),
                hintText: 'Cerca',
                contentPadding: MySpacing.xy(12, 8)),
            onChanged: (value) {
              controller.filtraComuniDest(value);
              setState(() {});
            },
          ),
          MySpacing.height(8),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: controller.comuniDestFiltrati.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: MyText.labelLarge(
                    '${controller.comuniDestFiltrati[index].localita}',
                  ),
                  onTap: () {
                    controller.comuneSelezionatoDest =
                        controller.comuniDestFiltrati[index];
                    controller.basicValidator
                            .getController("localitaDest")
                            .text =
                        controller.comuneSelezionatoDest?.localita ?? "";
                    controller.basicValidator.getController("capDest")?.text =
                        controller.comuneSelezionatoDest?.cap ?? "";
                    controller.basicValidator
                            .getController("provinciaDest")
                            ?.text =
                        controller.comuneSelezionatoDest?.provincia ?? "";
                    Navigator.pop(context);
                    controller.filtraComuniDest("");
                    controller.update();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  buildDropDownField<T>(
      List<DropdownMenuItem<T>> items,
      Function(T? value) onChanged,
      String validation,
      String title,
      T? valoreSelezionato) {
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
            contentPadding: MySpacing.all(12),
            isCollapsed: true,
            floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
          validator: controller.basicValidator.getValidation(validation),
          value: valoreSelezionato,
          onChanged: (value) {
            onChanged(value);
          },
        )
      ],
    );
  }

  buildTextField(
      String fieldTitle,
      String hintText,
      TextEditingController? controller,
      String? Function(String?)? validator,
      bool enabled,
      int maxLength,
      TextInputType keyboaardType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText.labelMedium(
          fieldTitle,
        ),
        MySpacing.height(4),
        TextFormField(
          keyboardType: keyboaardType,
          maxLength: maxLength,
          enabled: enabled,
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
            counterStyle: TextStyle(
              height: double.minPositive,
            ),
            counterText: "",
            hintText: hintText,
            hintStyle: MyTextStyle.bodySmall(xMuted: true),
            border: outlineInputBorder,
            contentPadding: MySpacing.all(14),
            isCollapsed: true,
            floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
        ),
      ],
    );
  }
}
