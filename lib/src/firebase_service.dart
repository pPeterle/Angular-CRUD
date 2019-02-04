import 'dart:html';
import 'package:angular_app/src/model/user.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart' as fs;

import '../src/model/note.dart';

class FirebaseService {
  final fb.Auth _auth;
  final fb.StorageReference _storageRef;
  final fs.CollectionReference _collectionUserRef;

  final List<Note> notes = [];
  User user;
  bool loading = false;

  final _userAutenticated = BehaviorSubject<bool>(seedValue: false);
  Stream<bool> get userAutenticated => _userAutenticated.stream;

  Stream<List<Note>> get noteList =>
      _collectionUserRef.doc(_auth.currentUser.uid).collection("notes").onSnapshot.map((snapshot) =>
          snapshot.docs.map((doc) => Note.fromMap(doc.data())).toList());

  FirebaseService()
      : _auth = fb.auth(),
        _collectionUserRef = fb.firestore().collection("user"),
        _storageRef = fb.storage().ref("notes");

  init() {
    _auth.onIdTokenChanged.listen((e) {
      if (e != null) {
        getUserData(e.uid);
        _userAutenticated.sink.add(true);
      }
    });
  }

  bool isLoggin() => _auth.currentUser != null;

  getUserData(String uid) async {
    final snapshot = await _collectionUserRef.doc(uid).get();
    user = User.fromMap(snapshot.data());
  }

  postItem(Note item, {File image}) async {
    try {
      if (image != null) {
        String url = await postItemImage(image);
        item.imageUrl = url;
      }
      final ref = _collectionUserRef.doc(_auth.currentUser.uid).collection("notes").doc();
      item.key = ref.id;
      await _collectionUserRef.doc(_auth.currentUser.uid).collection("notes").doc(item.key).set(item.toMap());
    } catch (e) {
      print("Error in writing to database: $e");
    }
  }

  removeItem(Note item) async {
    try {
      removeItemImage(item.imageUrl);
      await _collectionUserRef.doc(_auth.currentUser.uid).collection("notes").doc(item.key).delete();
    } catch (e) {
      print("Error in deleting ${item.key}: $e");
    }
  }

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

  postItemImage(File file) async {
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

  removeItemImage(String imageUrl) async {
    try {
      var imageRef = fb.storage().refFromURL(imageUrl);
      await imageRef.delete();
    } catch (e) {
      print("Error in deleting $imageUrl: $e");
    }
  }

  Future<List<Note>> getNoteList() async {
    final querySnapshot = await _collectionUserRef.doc(_auth.currentUser.uid).collection("notes").get();
    List<Note> list =
        querySnapshot.docs.map((doc) => Note.fromMap(doc.data())).toList();
    print("lista retornada: ${list.length}");
    return list;
  }

  dispose() {
    _userAutenticated.close();
  }
}
