import 'package:clariss/global/global_color.dart';
import 'package:clariss/global/global_styling.dart';
import 'package:clariss/localization/app_localizations.dart';
import 'package:clariss/model/user_notification.dart';
import 'package:clariss/services/sharedpreferences_service.dart';
import 'package:clariss/services/user_notification_service.dart';
import 'package:clariss/util/global.dart';
import 'package:clariss/util/notification.dart';
import 'package:clariss/util/size_config.dart';
import 'package:clariss/util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../validator/form_validator.dart';

class ContactForm extends StatefulWidget {
  ContactForm(BuildContext context);

  @override
  ContactFormState createState() => new ContactFormState();
}

class ContactFormState extends State<ContactForm> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  UserNotification _userNotification = new UserNotification();
  UserNotificationService _notificationService = new UserNotificationService();
  SharedPreferenceService _sharedPreferenceService =
      new SharedPreferenceService();

  FormValidator formValidator = new FormValidator();
  FocusNode _subjectFocusNode;
  FocusNode _messageFocusNode;

  @override
  void initState() {
    super.initState();
    _subjectFocusNode = FocusNode();
    _messageFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    _subjectFocusNode.dispose();
    _messageFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    GlobalStyling().init(context);

    return Form(
      key: _formKey,
      autovalidate: false,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.blockSizeHorizontal * 2),
        child: Column(
          children: <Widget>[
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              style: GlobalStyling.styleFormGrey,
              textInputAction: TextInputAction.next,
              focusNode: _subjectFocusNode,
              onFieldSubmitted: (term) {
                Util.fieldFocusChange(
                    context, _subjectFocusNode, _messageFocusNode);
              },
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context).translate('give_title'),
                labelText: AppLocalizations.of(context).translate('title'),
                labelStyle: GlobalStyling.styleFormBlack,
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(30),
              ],
              onSaved: (val) => _userNotification.title = val,
            ),
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              style: GlobalStyling.styleFormGrey,
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
              focusNode: _messageFocusNode,
              onFieldSubmitted: (value) {
                _messageFocusNode.unfocus();
                _submitForm();
              },
              maxLines: 10,
              decoration: InputDecoration(
                hintText:
                    AppLocalizations.of(context).translate('give_your_message'),
                labelText: AppLocalizations.of(context).translate('message'),
                labelStyle: GlobalStyling.styleFormBlack,
              ),
              inputFormatters: [
                LengthLimitingTextInputFormatter(500),
              ],
              validator: (val) => formValidator.isEmptyText(val)
                  ? AppLocalizations.of(context).translate('give_your_message')
                  : null,
              onSaved: (val) => _userNotification.message = val,
            ),
            Container(
              width: SizeConfig.screenWidth * 0.9,
              padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
              child: RaisedButton(
                shape: const StadiumBorder(),
                color: GlobalColor.colorDeepPurple400,
                child: Text(AppLocalizations.of(context).translate('send'),
                    style: GlobalStyling.styleButtonWhite),
                onPressed: _submitForm,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() async {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      MyNotification.showInfoFlushbar(
          context,
          AppLocalizations.of(context).translate('info'),
          AppLocalizations.of(context).translate('correct_form_errors'),
          Icon(
            Icons.info_outline,
            size: 28,
            color: Colors.red.shade300,
          ),
          Colors.red.shade300,
          2);
    } else {
      form.save();
      await _saveUserNotifikation().then((_) => showSuccessNotification());
    }
  }

  Future<void> _saveUserNotifikation() async {
    String userEmail = await _sharedPreferenceService.read(USER_EMAIL);
    if (userEmail != null) {
      _userNotification.created_at = DateTime.now();
      _userNotification.useremail = userEmail;

      Map<String, dynamic> userNotificationParams =
      _userNotification.toMap(_userNotification);
      await _notificationService.save(userNotificationParams);
      await _notificationService.sendNotificationAsEmail(_userNotification);
    }
    else{
      MyNotification.showInfoFlushbar(
          context,
          AppLocalizations.of(context).translate('info'),
          AppLocalizations.of(context).translate('connect_to_send_notification'),
          Icon(
            Icons.info_outline,
            size: 28,
            color: Colors.blue.shade300,
          ),
          Colors.blue.shade300,
          2);
    }
  }

  void showSuccessNotification(){
    MyNotification.showInfoFlushbar(
        context,
        AppLocalizations.of(context).translate('info'),
        AppLocalizations.of(context).translate('thanks_for_your_message'),
        Icon(
          Icons.info_outline,
          size: 28,
          color: Colors.blue.shade300,
        ),
        Colors.blue.shade300,
        10);

    clearForm();
  }

  clearForm() {
    _formKey.currentState?.reset();
    setState(() {});
  }
}
