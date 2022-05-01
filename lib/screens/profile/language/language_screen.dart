import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/config.dart';
import '../../../config/locale_utils/language.dart';
import '../../../config/locale_utils/locale.dart';
import '../../../blocs/language/language_bloc.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  LanguageBloc _languageBloc = new LanguageBloc();

  List<Locale> _listLanguage = AppLanguage.supportLanguage;
  Locale _languageSelected = AppLanguage.defaultLanguage;

  @override
  void initState() {
    _languageBloc = BlocProvider.of<LanguageBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Translate.of(context).translate('language')
            //  'Language'
            ),
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Container(
              child: Column(
                children: List.generate(_listLanguage.length, (index) {
                  final item = _listLanguage[index];
                  final trailing = item == _languageSelected
                      ? Icon(
                          Icons.check,
                          color: Theme.of(context).primaryColor,
                        )
                      : null;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _languageSelected = item;
                      });
                      _languageBloc.add(ChangeLanguage(_languageSelected));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                              UtilLanguage.getGlobalLanguageName(
                                item.languageCode,
                              ),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          trailing ?? Container()
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
