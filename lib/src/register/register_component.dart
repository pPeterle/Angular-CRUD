import 'package:angular/angular.dart';
import 'package:angular_app/src/firebase_service.dart';
import 'package:angular_app/src/model/user.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';


@Component(
  selector: 'my-register',
  templateUrl: 'register_component.html',
  styleUrls: ['register_component.css'],
  directives: [coreDirectives, formDirectives]
)
class RegisterComponent {

  final Location location;
  final FirebaseService service;
  
  User user = User();
  String password;

  RegisterComponent(this.location, this.service);

  onSubmit(){
    service.createUserWithEmail(user, password);
  }

}