import 'package:angular/angular.dart';
import 'package:angular_app/src/firebase_service.dart';
import 'package:angular_app/src/model/note.dart';
import 'package:angular_app/src/model/tag.dart';
import 'package:angular_components/angular_components.dart';
import 'dart:async';

@Component(
  selector: 'my-note',
  templateUrl: 'note_component.html',
  styleUrls: [
    'card_style.css',
    'note_component.css',
    'package:angular_components/css/mdc_web/card/mdc-card.scss.css'
  ],
  directives: [
    coreDirectives,
    MaterialButtonComponent,
    MaterialIconComponent,
    PopupSourceDirective,
    MaterialPopupComponent,
    MaterialCheckboxComponent,
  ],
)
class NoteComponent implements OnInit, OnDestroy {
  final FirebaseService service;
  final _controller = StreamController<Note>();

  bool popupVisible = false;
  List<Tag> selectedTags = List();
  List<Tag> alteredTags = List();
  StreamSubscription stream;

  @Input()
  Note note;
  @Input()
  List<Tag> tags;

  @Output()
  Stream<Note> get edit => _controller.stream;

  NoteComponent(this.service);

  deleteNote() {
    service.removeNote(note);
  }

  editNote() {
    _controller.sink.add(note);
  }

  checkedChange(int i) {
    if (popupVisible == true) {
      final tag = tags[i];
      if (!alteredTags.remove(tag)) alteredTags.add(tag);
    }
  }

  save() {
    alteredTags.forEach((tag) {
      if (!selectedTags.contains(tag)) {
        service.saveNoteTag(note, tag);
      } else {
        service.removeNoteTag(note, tag);
      }
    });
    alteredTags.clear();
    popupVisible = false;
  }

  @override
  void ngOnInit() {
    stream = service.getSeletectedTags(note).listen((tags) {
      selectedTags = tags;
    });
  }

  @override
  void ngOnDestroy() {
    stream.cancel();
    _controller.close();
  }
}
