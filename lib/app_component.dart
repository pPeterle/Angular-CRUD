import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_app/route_paths.dart';
import 'package:angular_app/routes.dart';
import 'package:angular_app/src/firebase_service.dart';
import 'package:angular_router/angular_router.dart';
import 'route_paths.dart';

@Component(
    selector: 'my-app',
    template: '''
    <router-outlet [routes]="Routes.all"></router-outlet>
    ''',
    directives: [routerDirectives],
    providers: [FirebaseService],
    exports: [RoutePaths, Routes])
class AppComponent implements OnInit , OnDestroy{

  final FirebaseService service;
  final Router router;
  Stream<bool> userAutenticated;

  AppComponent(this.service, this.router);

  @override
  ngOnInit() {
    service.init();
    userAutenticated = service.userAutenticated;
    userAutenticated.listen((isLogin) {
      if(isLogin)
        router.navigate(RoutePaths.tasks.toUrl());
      else
        router.navigate(RoutePaths.login.toUrl());
    });
  }

  @override
  void ngOnDestroy() {
    service.dispose();
  }
}
