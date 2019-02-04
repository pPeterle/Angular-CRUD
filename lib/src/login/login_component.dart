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
    directives: [coreDirectives, routerDirectives, formDirectives, MaterialButtonComponent])
class LoginComponent implements OnInit{

  String email;
  String password;
  final Router router;
  final FirebaseService service;
  
  LoginComponent(this.service,this.router);

  String registerUrl() => RoutePaths.register.toUrl();

  void onSubmit() {
    service.singInWithEmailAndPassword(email, password);
  }

  @override
  void ngOnInit() {
    service.userAutenticated.listen((isLoggin) {
      if(isLoggin)
      router.navigate(RoutePaths.tasks.toUrl());
    });
  }

}