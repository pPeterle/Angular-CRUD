import 'package:angular/angular.dart';
import 'package:angular_app/src/firebase_service.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import '../../route_paths.dart';
import 'package:angular_components/angular_components.dart';

@Component(
  selector: 'my-login',
  templateUrl: 'login_component.html',
  styleUrls: ['login_component.css'],
  directives: [
    coreDirectives,
    routerDirectives,
    formDirectives,
    MaterialButtonComponent,
    MaterialButtonComponent,
    MaterialInputComponent,
    materialInputDirectives,
  ],
)
class LoginComponent {
  
  String email;
  String password;
  String firebaseError;

  final FirebaseService service;

  LoginComponent(this.service);

  String registerUrl() => RoutePaths.register.toUrl();

  void onSubmit() async {
    if (email != null || password != null)
      firebaseError = await service.singInWithEmailAndPassword(email, password);
  }
}
