import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_app/src/firebase_service.dart';
import 'package:angular_app/src/model/user.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';

@Component(
    selector: 'my-register',
    templateUrl: 'register_component.html',
    styleUrls: [
      'register_component.css',
    ],
    directives: [
      coreDirectives,
      formDirectives,
      MaterialButtonComponent,
      MaterialButtonComponent,
      MaterialIconComponent,
      MaterialInputComponent,
      materialInputDirectives,
    ])
class RegisterComponent {
  final Location location;
  final FirebaseService service;

  User user = User();
  String _password;

  String passwordError;
  String emailError;
  String firebaseError;

  String get password => _password;
  void set password(String text) {
    _password = text;
    checkPassword();
  }

  String get email => user.email;
  void set email(String text) {
    user.email = text;
    checkEmail();
  }

  RegisterComponent(this.location, this.service);

  onSubmit() async {
    firebaseError = await service.createUserWithEmail(user, password);
  }

  goBack() {
    location.back();
  }

  void checkEmail() {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(p);
    final result = regExp.hasMatch(user.email);
    if (!result)
      emailError = "Invalid Email";
    else
      emailError = null;
  }

  void checkPassword() {
    if (_password.length < 6)
      passwordError = "Password is too small";
    else
      passwordError = null;
  }
}
