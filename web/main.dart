import 'package:angular/angular.dart';
import 'package:angular_app/app_component.template.dart' as ng;
import 'package:angular_router/angular_router.dart';
import 'package:firebase/firebase.dart';
import 'main.template.dart' as self;

@GenerateInjector(
  routerProvidersHash,
)
final InjectorFactory injector = self.injector$Injector;
void main() {
  initializeApp(
      apiKey: "AIzaSyDv0IXd8U6gj9aEkNm6p4Gnde8WDmRSxSk",
      authDomain: "lista-tarefas-17877.firebaseapp.com",
      databaseURL: "https://lista-tarefas-17877.firebaseio.com",
      projectId: "lista-tarefas-17877",
      storageBucket: "lista-tarefas-17877.appspot.com",
      messagingSenderId: "641883828384");
  runApp(ng.AppComponentNgFactory, createInjector: injector);
}
