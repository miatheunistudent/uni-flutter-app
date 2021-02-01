import 'dart:convert';

import 'package:flutter/services.dart';

class UniName {
  String uai;
  String uo_lib;
  String nom_court;
  String sigle;
  String type_d_etablissement;
  String typologie_d_universites_et_assimiles;
  String secteur_d_etablissement;
  String vague_contractuelle;
  String localisation;
  String url;
  String coordonnees;
  String identifiant_interne;
  String siret;
  String siren;
  String rna;
  String identifiant_wikidata;
  String element_wikidata;
  String identifiant_idref;
  String identifiant_eter;
  String identifiant_ror;
  String element_ror;
  String identifiant_grid;
  String element_grid;
  String identifiant_orgref;
  String identifiant_isni;
  String element_isni;
  String identifiant_funding_data;
  String element_fundref;
  String identifiant_dataesr;
  String anciens_codes_uai;
  String rattachement_identifiants;
  String rattachement;
  String association_identifiants;
  String association;
  String date_creation;
  String texte_de_ref_creation_lib;
  String texte_de_ref_creation;
  String date_fermeture;
  String texte_de_ref_fermeture_lib;
  String texte_de_ref_fermeture;
  String dernier_decret_legifrance_lib;
  String dernier_decret_legifrance;
  String com_code;
  String com_nom;
  String uucr_id;
  String uucr_nom;
  String dep_id;
  String dep_nom;
  String aca_id;
  String aca_nom;
  String reg_id;
  String reg_nom;
  String reg_id_old;
  String reg_nom_old;
  String mention_distribution;
  String adresse_uai;
  String lieu_dit_uai;
  String boite_postale_uai;
  String code_postal_uai;
  String localite_acheminement_uai;
  String pays_etranger_acheminement;
  String numero_telephone_uai;
  String statut_juridique_court;
  String statut_juridique_long;
  String qualification_court;
  String qualification_long;
  String compte_facebook;
  String compte_twitter;
  String compte_instagram;
  String compte_flickr;
  String compte_pinterest;
  String flux_rss;
  String compte_linkedin;
  String compte_viadeo;
  String compte_france_culture;
  String compte_scribd;
  String compte_scoopit;
  String compte_tumblr;
  String compte_youtube;
  String compte_vimeo;
  String compte_dailymotion;
  String autres;
  String compte_github;
  String wikipedia;
  String wikipedia_en;
  String scanr;
  String hal;
  String mooc;
  String article;
  String uo_lib_officiel;
  String uo_lib_en;
  String url_en;
  String url_cn;
  String url_es;
  String url_de;
  String url_it;
  String inscrits_2010;
  String inscrits_2011;
  String inscrits_2012;
  String inscrits_2013;
  String inscrits_2014;
  String inscrits_2015;
  String inscrits_2016;
  String inscrits_2017;
  String uai_rgp_loi_esr_2013;
  String universites_fusionnees;
  String etablissement_experimental;
  String implantations;
  String identifiant_programmes_lolf;
  String statut_operateur_lolf;
  String libelle_missions_lolf;
  String libelle_programmes_lolf;
  String libelle_programme_lolf_chef_de_file;
  String identifiants_autres_programmes_lolf;
  String libelles_autres_programmes_lolf;
  String identifiant_programme_lolf_chef_de_file;
  String libelle_mission_chef_de_file;
  String compte_googleplus;

  UniName({
    this.uai,
    this.uo_lib,
    this.nom_court,
    this.sigle,
    this.type_d_etablissement,
    this.typologie_d_universites_et_assimiles,
    this.secteur_d_etablissement,
    this.vague_contractuelle,
    this.localisation,
    this.url,
    this.coordonnees,
    this.identifiant_interne,
    this.siret,
    this.siren,
    this.rna,
    this.identifiant_wikidata,
    this.element_wikidata,
    this.identifiant_idref,
    this.identifiant_eter,
    this.identifiant_ror,
    this.element_ror,
    this.identifiant_grid,
    this.element_grid,
    this.identifiant_orgref,
    this.identifiant_isni,
    this.element_isni,
    this.identifiant_funding_data,
    this.element_fundref,
    this.identifiant_dataesr,
    this.anciens_codes_uai,
    this.rattachement_identifiants,
    this.rattachement,
    this.association_identifiants,
    this.association,
    this.date_creation,
    this.texte_de_ref_creation_lib,
    this.texte_de_ref_creation,
    this.date_fermeture,
    this.texte_de_ref_fermeture_lib,
    this.texte_de_ref_fermeture,
    this.dernier_decret_legifrance_lib,
    this.dernier_decret_legifrance,
    this.com_code,
    this.com_nom,
    this.uucr_id,
    this.uucr_nom,
    this.dep_id,
    this.dep_nom,
    this.aca_id,
    this.aca_nom,
    this.reg_id,
    this.reg_nom,
    this.reg_id_old,
    this.reg_nom_old,
    this.mention_distribution,
    this.adresse_uai,
    this.lieu_dit_uai,
    this.boite_postale_uai,
    this.code_postal_uai,
    this.localite_acheminement_uai,
    this.pays_etranger_acheminement,
    this.numero_telephone_uai,
    this.statut_juridique_court,
    this.statut_juridique_long,
    this.qualification_court,
    this.qualification_long,
    this.compte_facebook,
    this.compte_twitter,
    this.compte_instagram,
    this.compte_flickr,
    this.compte_pinterest,
    this.flux_rss,
    this.compte_linkedin,
    this.compte_viadeo,
    this.compte_france_culture,
    this.compte_scribd,
    this.compte_scoopit,
    this.compte_tumblr,
    this.compte_youtube,
    this.compte_vimeo,
    this.compte_dailymotion,
    this.autres,
    this.compte_github,
    this.wikipedia,
    this.wikipedia_en,
    this.scanr,
    this.hal,
    this.mooc,
    this.article,
    this.uo_lib_officiel,
    this.uo_lib_en,
    this.url_en,
    this.url_cn,
    this.url_es,
    this.url_de,
    this.url_it,
    this.inscrits_2010,
    this.inscrits_2011,
    this.inscrits_2012,
    this.inscrits_2013,
    this.inscrits_2014,
    this.inscrits_2015,
    this.inscrits_2016,
    this.inscrits_2017,
    this.uai_rgp_loi_esr_2013,
    this.universites_fusionnees,
    this.etablissement_experimental,
    this.implantations,
    this.identifiant_programmes_lolf,
    this.statut_operateur_lolf,
    this.libelle_missions_lolf,
    this.libelle_programmes_lolf,
    this.libelle_programme_lolf_chef_de_file,
    this.identifiants_autres_programmes_lolf,
    this.libelles_autres_programmes_lolf,
    this.identifiant_programme_lolf_chef_de_file,
    this.libelle_mission_chef_de_file,
    this.compte_googleplus,
  });

  factory UniName.fromJson(Map<String, dynamic> parsedJson) {
    return UniName(
      uai:parsedJson['uai'] as String,
      uo_lib:parsedJson['uo_lib'] as String,
      nom_court:parsedJson['nom_court'] as String,
      sigle:parsedJson['sigle'] as String,
      type_d_etablissement:parsedJson['type_d_etablissement'] as String,
      typologie_d_universites_et_assimiles:parsedJson['typologie_d_universites_et_assimiles'] as String,
      secteur_d_etablissement:parsedJson['secteur_d_etablissement'] as String,
      vague_contractuelle:parsedJson['vague_contractuelle'] as String,
      localisation:parsedJson['localisation'] as String,
      url:parsedJson['url'] as String,
      coordonnees:parsedJson['coordonnees'] as String,
      identifiant_interne:parsedJson['identifiant_interne'] as String,
      siret:parsedJson['siret'] as String,
      siren:parsedJson['siren'] as String,
      rna:parsedJson['rna'] as String,
      identifiant_wikidata:parsedJson['identifiant_wikidata'] as String,
      element_wikidata:parsedJson['element_wikidata'] as String,
      identifiant_idref:parsedJson['identifiant_idref'] as String,
      identifiant_eter:parsedJson['identifiant_eter'] as String,
      identifiant_ror:parsedJson['identifiant_ror'] as String,
      element_ror:parsedJson['element_ror'] as String,
      identifiant_grid:parsedJson['identifiant_grid'] as String,
      element_grid:parsedJson['element_grid'] as String,
      identifiant_orgref:parsedJson['identifiant_orgref'] as String,
      identifiant_isni:parsedJson['identifiant_isni'] as String,
      element_isni:parsedJson['element_isni'] as String,
      identifiant_funding_data:parsedJson['identifiant_funding_data'] as String,
      element_fundref:parsedJson['element_fundref'] as String,
      identifiant_dataesr:parsedJson['identifiant_dataesr'] as String,
      anciens_codes_uai:parsedJson['anciens_codes_uai'] as String,
      rattachement_identifiants:parsedJson['rattachement_identifiants'] as String,
      rattachement:parsedJson['rattachement'] as String,
      association_identifiants:parsedJson['association_identifiants'] as String,
      association:parsedJson['association'] as String,
      date_creation:parsedJson['date_creation'] as String,
      texte_de_ref_creation_lib:parsedJson['texte_de_ref_creation_lib'] as String,
      texte_de_ref_creation:parsedJson['texte_de_ref_creation'] as String,
      date_fermeture:parsedJson['date_fermeture'] as String,
      texte_de_ref_fermeture_lib:parsedJson['texte_de_ref_fermeture_lib'] as String,
      texte_de_ref_fermeture:parsedJson['texte_de_ref_fermeture'] as String,
      dernier_decret_legifrance_lib:parsedJson['dernier_decret_legifrance_lib'] as String,
      dernier_decret_legifrance:parsedJson['dernier_decret_legifrance'] as String,
      com_code:parsedJson['com_code'] as String,
      com_nom:parsedJson['com_nom'] as String,
      uucr_id:parsedJson['uucr_id'] as String,
      uucr_nom:parsedJson['uucr_nom'] as String,
      dep_id:parsedJson['dep_id'] as String,
      dep_nom:parsedJson['dep_nom'] as String,
      aca_id:parsedJson['aca_id'] as String,
      aca_nom:parsedJson['aca_nom'] as String,
      reg_id:parsedJson['reg_id'] as String,
      reg_nom:parsedJson['reg_nom'] as String,
      reg_id_old:parsedJson['reg_id_old'] as String,
      reg_nom_old:parsedJson['reg_nom_old'] as String,
      mention_distribution:parsedJson['mention_distribution'] as String,
      adresse_uai:parsedJson['adresse_uai'] as String,
      lieu_dit_uai:parsedJson['lieu_dit_uai'] as String,
      boite_postale_uai:parsedJson['boite_postale_uai'] as String,
      code_postal_uai:parsedJson['code_postal_uai'] as String,
      localite_acheminement_uai:parsedJson['localite_acheminement_uai'] as String,
      pays_etranger_acheminement:parsedJson['pays_etranger_acheminement'] as String,
      numero_telephone_uai:parsedJson['numero_telephone_uai'] as String,
      statut_juridique_court:parsedJson['statut_juridique_court'] as String,
      statut_juridique_long:parsedJson['statut_juridique_long'] as String,
      qualification_court:parsedJson['qualification_court'] as String,
      qualification_long:parsedJson['qualification_long'] as String,
      compte_facebook:parsedJson['compte_facebook'] as String,
      compte_twitter:parsedJson['compte_twitter'] as String,
      compte_instagram:parsedJson['compte_instagram'] as String,
      compte_flickr:parsedJson['compte_flickr'] as String,
      compte_pinterest:parsedJson['compte_pinterest'] as String,
      flux_rss:parsedJson['flux_rss'] as String,
      compte_linkedin:parsedJson['compte_linkedin'] as String,
      compte_viadeo:parsedJson['compte_viadeo'] as String,
      compte_france_culture:parsedJson['compte_france_culture'] as String,
      compte_scribd:parsedJson['compte_scribd'] as String,
      compte_scoopit:parsedJson['compte_scoopit'] as String,
      compte_tumblr:parsedJson['compte_tumblr'] as String,
      compte_youtube:parsedJson['compte_youtube'] as String,
      compte_vimeo:parsedJson['compte_vimeo'] as String,
      compte_dailymotion:parsedJson['compte_dailymotion'] as String,
      autres:parsedJson['autres'] as String,
      compte_github:parsedJson['compte_github'] as String,
      wikipedia:parsedJson['wikipedia'] as String,
      wikipedia_en:parsedJson['wikipedia_en'] as String,
      scanr:parsedJson['scanr'] as String,
      hal:parsedJson['hal'] as String,
      mooc:parsedJson['mooc'] as String,
      article:parsedJson['article'] as String,
      uo_lib_officiel:parsedJson['uo_lib_officiel'] as String,
      uo_lib_en:parsedJson['uo_lib_en'] as String,
      url_en:parsedJson['url_en'] as String,
      url_cn:parsedJson['url_cn'] as String,
      url_es:parsedJson['url_es'] as String,
      url_de:parsedJson['url_de'] as String,
      url_it:parsedJson['url_it'] as String,
      inscrits_2010:parsedJson['inscrits_2010'] as String,
      inscrits_2011:parsedJson['inscrits_2011'] as String,
      inscrits_2012:parsedJson['inscrits_2012'] as String,
      inscrits_2013:parsedJson['inscrits_2013'] as String,
      inscrits_2014:parsedJson['inscrits_2014'] as String,
      inscrits_2015:parsedJson['inscrits_2015'] as String,
      inscrits_2016:parsedJson['inscrits_2016'] as String,
      inscrits_2017:parsedJson['inscrits_2017'] as String,
      uai_rgp_loi_esr_2013:parsedJson['uai_rgp_loi_esr_2013'] as String,
      universites_fusionnees:parsedJson['universites_fusionnees'] as String,
      etablissement_experimental:parsedJson['etablissement_experimental'] as String,
      implantations:parsedJson['implantations'] as String,
      identifiant_programmes_lolf:parsedJson['identifiant_programmes_lolf'] as String,
      statut_operateur_lolf:parsedJson['statut_operateur_lolf'] as String,
      libelle_missions_lolf:parsedJson['libelle_missions_lolf'] as String,
      libelle_programmes_lolf:parsedJson['libelle_programmes_lolf'] as String,
      libelle_programme_lolf_chef_de_file:parsedJson['libelle_programme_lolf_chef_de_file'] as String,
      identifiants_autres_programmes_lolf:parsedJson['identifiants_autres_programmes_lolf'] as String,
      libelles_autres_programmes_lolf:parsedJson['libelles_autres_programmes_lolf'] as String,
      identifiant_programme_lolf_chef_de_file:parsedJson['identifiant_programme_lolf_chef_de_file'] as String,
      libelle_mission_chef_de_file:parsedJson['libelle_mission_chef_de_file'] as String,
      compte_googleplus:parsedJson['compte_googleplus'] as String,
    );
  }
}

  class UniViewModel {
  static List<UniName> uni;

  static Future loadUni() async {
  try {
  uni = new List<UniName>();
  String jsonString = await rootBundle.loadString('assets/uninames.json');
  Map parsedJson = json.decode(jsonString);
  var categoryJson = parsedJson['uni'] as List;
  for (int i = 0; i < categoryJson.length; i++) {
  uni.add(new UniName.fromJson(categoryJson[i]));
  }
  } catch (e) {
  print(e);
  }
  }
  }

