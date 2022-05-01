import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/config.dart';
import '../../api/helpers/http_manager.dart';

part 'language_event.dart';
part 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(LanguageInitial()) {
    on<ChangeLanguage>(
      (event, emit) async {
        emit(LanguageUpdating());
        SharedPreferences prefs = await SharedPreferences.getInstance();

        // AppLanguage.defaultLanguage = event.locale;

        ///Preference save
        prefs.setString(
          Globals.prefLanguage,
          event.locale.languageCode,
        );

        Globals.oldLang = event.locale.languageCode;
        httpManager.baseOptions.headers["X-Oc-Merchant-Language"] =
            event.locale.languageCode;

        emit(LanguageUpdated(event.locale));
      },
    );

    on<GetLanguage>((event, emit) async {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        // Setup Language //
        final oldLanguage = prefs.getString(Globals.prefLanguage) ?? '';
        Globals.oldLang = oldLanguage;
        Globals.selectedLanguage = oldLanguage;
        // AppLanguage.defaultLanguage = Locale(oldLanguage);
        if (oldLanguage != '') {
          httpManager.baseOptions.headers["X-Oc-Merchant-Language"] =
              oldLanguage;
          emit(LanguageUpdated(Locale(oldLanguage)));
        }
      } catch (err) {
        print(err);
      }
    });
  }
}
