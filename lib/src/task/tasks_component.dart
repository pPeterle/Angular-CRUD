import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_app/route_paths.dart';
import 'package:angular_app/src/firebase_service.dart';
import 'package:angular_app/src/model/note.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_components/angular_components.dart';

@Component(
  selector: 'my-tasks',
  templateUrl: 'tasks_component.html',
  styleUrls: [
    'package:angular_components/css/mdc_web/card/mdc-card.scss.css',
    'tasks_component.css',
    'card_style.css'
  ],
  directives: [
    formDirectives,
    coreDirectives,
    MaterialButtonComponent,
    MaterialIconComponent,
  ],
)
class TasksComponent implements OnInit {
  final FirebaseService service;
  final Location location;
  final Router router;
  Note note = Note();
  File imageFile;
  List<Note> notes;

  TasksComponent(this.service, this.location, this.router);

  @override
  void ngOnInit() async {
    if (!service.isLoggin()) {
      router.navigate(RoutePaths.login.toUrl());
    }


    service.noteList.listen((data) {
      notes = data;
    });

    notes = await service.getNoteList();
  }

  imageChanged(dynamic e) {
    final reader = FileReader();
    imageFile = (e.target as FileUploadInputElement).files[0];

    reader.onLoadEnd.listen((e) => note.imageUrl = reader.result);

    reader.readAsDataUrl(imageFile);
  }

  signOut() {
    service.signOut();
  }

  onSubmit() {
    service.postItem(note, image: imageFile);
    note = Note();
  }

  editNote(Note note) {
    this.note = note;
    deleteNote(note);
  }

  deleteNote(Note deletedNote) {
    service.removeItem(deletedNote);
  }
}
