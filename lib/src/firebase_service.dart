import 'dart:html';
import 'package:angular_app/src/model/tag.dart';
import 'package:angular_app/src/model/user.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart' as fs;

import '../src/model/note.dart';

const String colletionNotes = "notes";
const String colletionTags = "tags";
const String colletionUsers = "user";

const String storageNotes = "notes";

class FirebaseService {
  final fb.Auth _auth;
  final fb.StorageReference _storageRef;
  final fs.CollectionReference _collectionUserRef;

  final List<Note> notes = [];
  User user;
  bool loading = false;

  final _userAutenticated = BehaviorSubject<bool>();
  Stream<bool> get userAutenticated => _userAutenticated.stream;

  Stream<List<Note>> get noteList => _collectionUserRef
      .doc(_auth.currentUser.uid)
      .collection(colletionNotes)
      .onSnapshot
      .map((snapshot) =>
          snapshot.docs.map((doc) => Note.fromMap(doc.data())).toList());

  Stream<List<Tag>> get tagList => _collectionUserRef
      .doc(_auth.currentUser.uid)
      .collection(colletionTags)
      .onSnapshot
      .map((snapshot) =>
          snapshot.docs.map((doc) => Tag.fromMap(doc.data())).toList());

  FirebaseService()
      : _auth = fb.auth(),
        _collectionUserRef = fb.firestore().collection(colletionUsers),
        _storageRef = fb.storage().ref(storageNotes);

  init() {
    _auth.onIdTokenChanged.listen((e) {
      if (e != null) {
        getUserData(e.uid);
        _userAutenticated.sink.add(true);
      }
    });
  }

  bool isLoggin() => _auth.currentUser != null;

  createUserWithEmail(User user, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(user.email, password);
      user.id = _auth.currentUser.uid;
      await _collectionUserRef.doc(_auth.currentUser.uid).set(user.toMap());
      _userAutenticated.sink.add(true);
    } catch (e) {
      print("Erro in create user $e");
    }
  }

  singInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email, password);
    } catch (e) {
      print("erro no sigin $e");
    }
  }

  signInWithGoogle() async {
    if (user != null) {
      print("usuario logado");
      return;
    }

    var provider = fb.GoogleAuthProvider();
    try {
      await _auth.signInWithPopup(provider);
    } catch (e) {
      print("Error in sign in with Google: $e");
    }
  }

  signOut() async {
    await _auth.signOut();
    _userAutenticated.sink.add(false);
  }

  getUserData(String uid) async {
    final snapshot = await _collectionUserRef.doc(uid).get();
    user = User.fromMap(snapshot.data());
  }

  Stream<List<Tag>> getSeletectedTags(Note note) => _collectionUserRef
      .doc(user.id)
      .collection(colletionNotes)
      .doc(note.key)
      .collection("tags")
      .onSnapshot
      .map((snapshot) =>
          snapshot.docs.map((doc) => Tag.fromMap(doc.data())).toList());

  postTag(Tag tag) async {
    try {
      final ref =
          _collectionUserRef.doc(user.id).collection(colletionTags).doc();
      tag.id = ref.id;
      await _collectionUserRef
          .doc(user.id)
          .collection(colletionTags)
          .doc(tag.id)
          .set(tag.toMap());
    } catch (e) {
      print("Error in saving tag: $e");
    }
  }

  postNote(Note note, {File image}) async {
    try {
      if (image != null) {
        String url = await postNoteImage(image);
        note.imageUrl = url;
      }
      final ref =
          _collectionUserRef.doc(user.id).collection(colletionNotes).doc();
      note.key = ref.id;
      await _collectionUserRef
          .doc(user.id)
          .collection(colletionNotes)
          .doc(note.key)
          .set(note.toMap());
    } catch (e) {
      print("Error in writing to database: $e");
    }
  }

  void updateNote(Note note, {File image}) async {
    if (image != null) {
      final snapshot = await _collectionUserRef
          .doc(user.id)
          .collection(colletionNotes)
          .doc(note.key)
          .get();

      final depreceatedNote = Note.fromMap(snapshot.data());
      removeNoteImage(depreceatedNote.imageUrl);
      String url = await postNoteImage(image);
      note.imageUrl = url;
    }
    await _collectionUserRef
        .doc(user.id)
        .collection(colletionNotes)
        .doc(note.key)
        .update(data: note.toMap());
  }

  removeNote(Note item) async {
    try {
      removeNoteImage(item.imageUrl);
      await _collectionUserRef
          .doc(user.id)
          .collection(colletionNotes)
          .doc(item.key)
          .delete();
    } catch (e) {
      print("Error in deleting ${item.key}: $e");
    }
  }

  removeTag(Tag tag) async {
    try {
      await _collectionUserRef
          .doc(user.id)
          .collection(colletionTags)
          .doc(tag.id)
          .delete();
      await _collectionUserRef
          .doc(user.id)
          .collection(colletionNotes)
          .get()
          .then((snapshot) {
        snapshot.docs.forEach((doc) {
          _collectionUserRef
              .doc(user.id)
              .collection(colletionNotes)
              .doc(doc.id)
              .collection("tags")
              .where("id", "==", tag.id)
              .get()
              .then((snapshot) => snapshot.forEach((doc) => doc.ref.delete()));
        });
      });
    } catch (e) {
      print("error in deleting tag $e");
    }
  }

  postNoteImage(File file) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch;
      var task = _storageRef.child(id.toString()).put(file);
      task.onStateChanged
          .listen((_) => loading = true, onDone: () => loading = false);

      var snapshot = await task.future;
      final url = await snapshot.ref.getDownloadURL();

      return url.toString();
    } catch (e) {
      print("Error in uploading to storage: $e");
    }
  }

  removeNoteImage(String imageUrl) async {
    try {
      var imageRef = fb.storage().refFromURL(imageUrl);
      await imageRef.delete();
    } catch (e) {
      print("Error in deleting image url-:$imageUrl ERRO-> $e");
    }
  }

  Future<List<Note>> getNoteList() async {
    final querySnapshot =
        await _collectionUserRef.doc(user.id).collection(colletionNotes).get();
    List<Note> list =
        querySnapshot.docs.map((doc) => Note.fromMap(doc.data())).toList();
    print("lista retornada: ${list.length}");
    return list;
  }

  void saveNoteTag(Note note, Tag tag) async {
    try {
      await _collectionUserRef
          .doc(user.id)
          .collection(colletionNotes)
          .doc(note.key)
          .collection("tags")
          .add(tag.toMap());
    } catch (e) {
      print("error in saving note tag $e");
    }
  }

  void removeNoteTag(Note note, Tag tag) async {
    try {
      await _collectionUserRef
          .doc(user.id)
          .collection(colletionNotes)
          .doc(note.key)
          .collection("tags")
          .where("id", "==", tag.id)
          .get()
          .then((snapshot) => snapshot.forEach((doc) => doc.ref.delete()));
    } catch (e) {
      print("error in saving note tag $e");
    }
  }

  dispose() {
    _userAutenticated.close();
  }
}
