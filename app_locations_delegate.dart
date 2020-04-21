import 'package:open_market_movil/src/constantes/lenguajes_soportados.dart';

import 'app_locations.dart';
import 'package:flutter/material.dart';

class AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  final List<String> submodulos;
  final Locale locale;
  // La instancia del delegador nunca podra cambiar incluso si no tiene atributos
  // Se proporciona un constructor constante
  const AppLocalizationsDelegate({@required this.submodulos, @required this.locale});

  @override
  bool isSupported(Locale locale) {
    // Incluir todos los legnuages soportados aqui
    return LENGUAJES_SOPORTADOS.contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    // La clase AppLocations es donde la carga de los archivos se ejecuta
    AppLocalizations localizations = new AppLocalizations(locale);
//    await localizations.load();
    print('el codigo ' + locale.languageCode);
    await localizations.cargarMasivo(this.submodulos);
    return localizations;
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => false;
}