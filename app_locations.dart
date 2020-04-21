import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_locations_delegate.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  // Metodo de ayuda para mantener el codigo concistente en los widgets
  // Se hace uso del InheritedWidget: "of" para acceder a las localizaciones
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  // Un atributo estatico para tener un acceso rapido al delegate desde el MaterialApp
  static  LocalizationsDelegate<AppLocalizations> delegate(List<String> submodulos){
      return AppLocalizationsDelegate(submodulos: submodulos, locale: Locale('es'));
}

  Map<String, dynamic> _localizedStrings;



  Future<bool> load([String nombreSubmodulo = '']) async {
    bool tieneSubmodulo = nombreSubmodulo != '';
    String rutaInt = 'i18n/${locale.languageCode}.json';
    // Si cargamos desde los archivos o comunes o desde un submodulo
    if (tieneSubmodulo) {
      rutaInt = 'i18n/$nombreSubmodulo/${locale.languageCode}.json';
    }
    // Cargar el archivo JSON desde la carpeta 'i18n' y desde el submodulo necesario
    String rutaIntGenerada = await rootBundle.loadString(rutaInt);
    Map<String, dynamic> jsonMap = json.decode(rutaIntGenerada);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  Future<bool> cargarMasivo(
    List<String> nombresSubmodulos,
  ) async {
    List<String> listaRutasTraduccion =
        this._obtenerRutasInternacionalizacion(nombresSubmodulos);
    _localizedStrings = {};
    for (String rutaTraduccion in listaRutasTraduccion) {
      Map<String, dynamic> diccionarioTraduccion =
          await this._generarDiccionarioTraduccion(rutaTraduccion);
      _localizedStrings.addAll(diccionarioTraduccion);
    }
    return true;
  }

  List<String> _obtenerRutasInternacionalizacion(
      List<String> nombresSubmodulos) {
    return nombresSubmodulos.map(
      (
        String nombreSubmodulo,
      ) {
        String rutaInt = 'assets/i18n/${locale.languageCode}.json';
        bool tieneSubmodulo = nombreSubmodulo != '';
        if (tieneSubmodulo) {
          rutaInt = 'assets/i18n/$nombreSubmodulo/${locale.languageCode}.json';
        }
        return rutaInt;
      },
    ).toList();
  }

  Future<Map<String, dynamic>> _generarDiccionarioTraduccion(
    String rutaTraduccion,
  ) async {
    String rutaIntGenerada = await rootBundle.loadString(rutaTraduccion);
    Map<String, dynamic> jsonMap = json.decode(rutaIntGenerada);
    Map<String, dynamic> diccionarioTraduccion = jsonMap.map(
      (key, value) {
        return MapEntry(key, value);
      },
    );
    return diccionarioTraduccion;
  }

  // Metodo que sera llamado desde cada widget que necesita traducir texto
  String translate(String key) {
    return _localizedStrings[key];
  }
  // traducir texto dada una ruta de traduccion, retorna el texto traducido
  // si no encuentra nada retornara la ruta de traduccion
  String translateText(String translationsPath){
    List<String> keys = translationsPath.split('.');
    Map<String, dynamic> diccionarioActual = _localizedStrings;
    String textoTraducido = translationsPath;
    int contador = 0;
    int totalLista = keys.length - 1;
    for(String key in keys){
      var valorActual = diccionarioActual[key];
      if (valorActual is Map<String, dynamic>){
        diccionarioActual = diccionarioActual[key] as Map<String, dynamic>;
      } else {
        if (valorActual == null){
          break;
        }
        bool esUltimoElementoLista = contador >= totalLista;
        if (esUltimoElementoLista){
          if (valorActual != null){
            textoTraducido = valorActual;
          }
        }
        break;
      }
      contador ++;
    }
    // por defecto se retornara el path de traduccion si no encuentra nada
    return textoTraducido;
  }
  // traducir un objeto entero
  // por defecto se retornara un objeto vacio => {} si no encuentra nada
  Map<String, dynamic> translateObjet(String translationsPath){
    // todas las llaves para llegar el objeto estan en una lista
    List<String> keys = translationsPath.split('.');
    // cargamos el diccionario localmente
    Map<String, dynamic> diccionarioActual = _localizedStrings;
    Map<String, dynamic> objetoTraducidio = {};
    int contador = 0;
    int totalLista = keys.length - 1;
    for(String key in keys){
      var valorActual = diccionarioActual[key];
      if (valorActual is Map<String, dynamic>){ // si sigue siendo otro subdiccionario
        diccionarioActual = diccionarioActual[key] as Map<String, dynamic>;
        bool esUltimoElementoLista = contador >= totalLista;
        if (esUltimoElementoLista){ // si es el ultimo elemento
          objetoTraducidio = diccionarioActual;
        }
      } else { // si no es un subdiccionario rompera el bucle
        break;
      }
      contador ++;
    }
    return objetoTraducidio;

  }
}
