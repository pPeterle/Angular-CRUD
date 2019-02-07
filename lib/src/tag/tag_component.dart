import 'package:angular/angular.dart';
import 'package:angular_app/src/firebase_service.dart';
import 'package:angular_app/src/model/tag.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';


@Component(
  selector: 'my-tag',
  templateUrl: 'tag_component.html',
  styleUrls: ['tag_component.css'],
  directives: [
    coreDirectives,
    formDirectives,
    MaterialButtonComponent,
    MaterialIconComponent
  ]
)
class TagComponent implements OnInit{
  final FirebaseService service;
  Tag tag = Tag();

  @Input() List<Tag> tags;


  TagComponent(this.service);

  @override
  void ngOnInit() {
    
  }

  createTag() {
    if (tag.color == null) tag.color = "#000";
    service.postTag(tag);
    tag = Tag();
  }

  deleteTag(Tag tag) {
    service.removeTag(tag);
  }

}