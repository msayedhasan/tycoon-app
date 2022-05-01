import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../blocs/blocs.dart';
import '../../config/config.dart';

part 'application_event.dart';
part 'application_state.dart';

class ApplicationBloc extends Bloc<ApplicationEvent, ApplicationState> {
  final LanguageBloc languageBloc;
  ApplicationBloc(
    this.languageBloc,
  ) : super(ApplicationStarting()) {
    on<StartApp>((StartApp event, emit) async {
      emit(ApplicationStarting());
      try {
        ///Setup SharedPreferences
        // SharedPreferences.setMockInitialValues({});
        SharedPreferences prefs = await SharedPreferences.getInstance();

        // Setup Language //
        String? oldLanguage = prefs.getString(Globals.prefLanguage);
        if (oldLanguage != null) {
          languageBloc.add(
            ChangeLanguage(Locale(oldLanguage)),
          );
        }

        await Future.delayed(const Duration(seconds: 1));
        // _authBloc.add(CheckAuth());
        return emit(ApplicationStarted());
      } catch (err) {
        print(err);
      }
    });
  }

  Stream<ApplicationState> mapEventToState(
    ApplicationEvent event,
  ) async* {
    if (event is StartApp) {
      yield ApplicationStarting();

      try {
        ///Setup SharedPreferences
        // SharedPreferences.setMockInitialValues({});
        SharedPreferences prefs = await SharedPreferences.getInstance();

        // Setup Language //
        String? oldLanguage = prefs.getString(Globals.prefLanguage);
        languageBloc.add(
          ChangeLanguage(Locale(oldLanguage!)),
        );
        await Future.delayed(const Duration(seconds: 1));
        // _authBloc.add(CheckAuth());
        yield ApplicationStarted();
      } catch (err) {
        print(err);
      }
    }
  }
}
// No implementation found for method read on channel plugins.it_nomads.com/flutter_secure_storage
// No implementation found for method getAll on channel plugins.flutter.io/shared_preferences
