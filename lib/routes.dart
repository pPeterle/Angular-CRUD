import 'package:angular_router/angular_router.dart';
import 'route_paths.dart';
import 'src/login/login_component.template.dart' as login_template;
import 'src/note_list/note_list_component.template.dart' as note_list_template;
import 'src/register/register_component.template.dart' as register_template;
export 'route_paths.dart';

class Routes {
  
  static final login = RouteDefinition(
    routePath: RoutePaths.login,
    component: login_template.LoginComponentNgFactory,

  );

  static final tasks = RouteDefinition(
    routePath: RoutePaths.tasks,
    component: note_list_template.NoteListComponentNgFactory,
  );

  static final register = RouteDefinition(
    routePath: RoutePaths.register,
    component: register_template.RegisterComponentNgFactory,
  );

  static final all = <RouteDefinition>[
    login,
    tasks,
    register
  ];
}
