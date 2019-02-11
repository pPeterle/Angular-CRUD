import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_app/route_paths.dart';
import 'package:angular_app/src/firebase_service.dart';
import 'package:angular_app/src/model/note.dart';
import 'package:angular_app/src/model/tag.dart';
import 'package:angular_app/src/note/note_component.dart';
import 'package:angular_app/src/tag/tag_component.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_components/angular_components.dart';

@Component(
  selector: 'my-tasks',
  templateUrl: 'note_list_component.html',
  styleUrls: [
    'note_list_component.css',
    'package:angular_components/app_layout/layout.scss.css'
  ],
  providers: [popupBindings],
  directives: [
    formDirectives,
    coreDirectives,
    materialInputDirectives,
    MaterialButtonComponent,
    MaterialIconComponent,
    MaterialInputComponent,
    MaterialMultilineInputComponent,
    PopupSourceDirective,
    MaterialPopupComponent,
    NoteComponent,
    TagComponent,
  ],
)
class NoteListComponent implements OnInit, OnDestroy {
  final FirebaseService service;
  final Router router;
  final List<StreamSubscription> _streamSubscriptionList = List();

  List<Tag> tags;
  Note note = Note();
  bool isEditing = false;

  File imageFile;
  List<Note> notes;

  NoteListComponent(this.service, this.router);

  @override
  void ngOnInit() async {
    if (!service.isLoggin()) {
      router.navigate(RoutePaths.login.toUrl());
      return;
    }

    final subscription = service.noteList.listen((data) {
      notes = data;
    });

    final subscription1 = service.tagList.listen((tagList) {
      if (tagList.length > 0)
        this.tags = tagList;
      else
        this.tags = null;
    });

    _streamSubscriptionList..add(subscription)..add(subscription1);
  }

  imageChanged(Event e) {
    final reader = FileReader();
    imageFile = (e.target as FileUploadInputElement).files[0];

    reader.onLoadEnd.listen((e) => note.imageUrl = reader.result);

    reader.readAsDataUrl(imageFile);
  }

  signOut() {
    service.signOut();
  }

  onSubmit() {
     
    if (isEditing) {
      service.updateNote(note, image: imageFile);
      isEditing = false;
    } else {
      service.postNote(note, image: imageFile);
    }
    note = Note();
  }

  editNote(Note note) {
    isEditing = true;
    this.note = note;
  }

  cancelEdit() {
    isEditing = false;
    note = Note();
  }

  @override
  void ngOnDestroy() {
    _streamSubscriptionList.forEach((item) {
      item.cancel();
    });
  }
}
