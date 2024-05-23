import 'dart:convert';
import 'dart:typed_data';

class Ordine {
  int? ocnum;
  int? ocser;
  String? ocsig;
  String? ocspePro;
  String? occliLoc;
  String? ocdat;
  String? occli;
  int? ocpag;
  String? occliDesc;
  double? octdp;
  String? occliPro;
  String? ocspe;
  double? ocabb;
  String? ocpagDesc;
  String? ocspeDesc;
  String? ocspeLoc;
  double? octdo;
  List<RigaDettaglio> rigaDettaglio = [];

  Ordine(
      {this.ocnum,
      this.ocser,
      this.ocsig,
      this.ocspePro,
      this.occliLoc,
      this.ocdat,
      this.occli,
      this.ocpag,
      this.occliDesc,
      this.octdp,
      this.occliPro,
      this.ocspe,
      this.ocabb,
      this.ocpagDesc,
      this.ocspeDesc,
      this.ocspeLoc,
      this.octdo,
      required this.rigaDettaglio});

  Ordine.fromJson(Map<String, dynamic> json) {
    ocnum = json['ocnum'];
    ocser = json['ocser'];
    ocsig = json['ocsig'];
    ocspePro = json['ocspe_pro'];
    occliLoc = json['occli_loc'];
    ocdat = json['ocdat'];
    occli = json['occli'];
    ocpag = json['ocpag'];
    occliDesc = json['occli_desc'];
    octdp = json['octdp'];
    occliPro = json['occli_pro'];
    ocspe = json['ocspe'];
    ocabb = json['ocabb'];
    ocpagDesc = json['ocpag_desc'];
    ocspeDesc = json['ocspe_desc'];
    ocspeLoc = json['ocspe_loc'];
    octdo = json['octdo'];
    if (json['riga_dettaglio'] != null) {
      rigaDettaglio = <RigaDettaglio>[];
      json['riga_dettaglio'].forEach((v) {
        rigaDettaglio.add(new RigaDettaglio.fromJson(v));
      });
    }
  }

  static List<Ordine> listFromJSON(List<dynamic> list) {
    return list.map((e) => Ordine.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ocnum'] = ocnum;
    data['ocser'] = ocser;
    data['ocsig'] = ocsig;
    data['ocspe_pro'] = ocspePro;
    data['occli_loc'] = occliLoc;
    data['ocdat'] = ocdat;
    data['occli'] = occli;
    data['ocpag'] = ocpag;
    data['occli_desc'] = occliDesc;
    data['octdp'] = octdp;
    data['occli_pro'] = occliPro;
    data['ocspe'] = ocspe;
    data['ocabb'] = ocabb;
    data['ocpag_desc'] = ocpagDesc;
    data['ocspe_desc'] = ocspeDesc;
    data['ocspe_loc'] = ocspeLoc;
    data['octdo'] = octdo;
    data['riga_dettaglio'] = rigaDettaglio.map((v) => v.toJson()).toList();
    return data;
  }
}

class RigaDettaglio {
  String? ocdsc;
  double? ocpro;
  int? ocord;
  int? occol;
  int? rigo;
  Uint8List? arime;
  double? ocruv;
  double? ocqta;
  String? ocart;
  String? arum;
  List<dynamic>? arice;
  double? ocprz;
  String? ocali;
  String? ocsco;
  List<dynamic>? arcae;

  RigaDettaglio(
      {this.ocdsc,
      this.ocpro,
      this.ocord,
      this.occol,
      this.rigo,
      this.arime,
      this.ocruv,
      this.ocqta,
      this.ocart,
      this.arum,
      this.arice,
      this.ocprz,
      this.ocali,
      this.ocsco,
      this.arcae});

  RigaDettaglio.fromJson(Map<String, dynamic> json) {
    ocdsc = json['ocdsc'];
    ocpro = json['ocpro'];
    ocord = json['ocord'];
    occol = json['occol'];
    rigo = json['rigo'];
    arime = getImmagineArticolo(json['arime']);
    ocruv = json['ocruv'];
    ocqta = json['ocqta'];
    ocart = json['ocart'];
    arum = json['arum'];
    arice = getImmagineArticolo(json['arice']);
    ocprz = json['ocprz'];
    ocali = json['ocali'];
    ocsco = json['ocsco'];
    arcae = getImmagineArticolo(json['arcae']);
  }

  Uint8List? getImmagineArticolo(List<dynamic>? result) {
    String img = "";
    if (result != null) {
      if (result.isNotEmpty) {
        for (String element in result) {
          img += element;
        }
        return base64
            .decode(img.replaceAll(RegExp(r'\s+'), '').replaceAll("[", ""));
      }
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ocdsc'] = ocdsc;
    data['ocpro'] = ocpro;
    data['ocord'] = ocord;
    data['occol'] = occol;
    data['rigo'] = rigo;
    data['arime'] = arime;
    data['ocruv'] = ocruv;
    data['ocqta'] = ocqta;
    data['ocart'] = ocart;
    data['arum'] = arum;
    data['arice'] = arice;
    data['ocprz'] = ocprz;
    data['ocali'] = ocali;
    data['ocsco'] = ocsco;
    data['arcae'] = arcae;
    return data;
  }
}
