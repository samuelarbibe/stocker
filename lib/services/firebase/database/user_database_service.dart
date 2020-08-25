import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stocker/models/user.dart';
import 'package:stocker/services/alpaca/alpaca_config.dart';

class UserDatabaseService {
  final String uid;

  UserDatabaseService({this.uid});

  final CollectionReference userCollection =
      Firestore.instance.collection('users');

  Future updateUserData(String firstName, String lastName, String email) async {
    return await userCollection.document(uid).setData({
      'firstname': firstName,
      'lastname': lastName,
      'email': email,
      'alpacaid': APCA_API_KEY_ID,
      'alpacakey': APCA_API_SECRET_KEY
    });
  }

  Future<DocumentSnapshot> _getUserData() async {
    return await userCollection.document(uid).get();
  }

  User _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return User(
      uid: uid,
      firstName: snapshot.data['firstname'],
      lastName: snapshot.data['lastname'],
      email: snapshot.data['email'],
      alpacaId: snapshot.data['alpacaid'],
      alpacaKey: snapshot.data['alpacakey'],
      image: snapshot.data['image'] ??
          'https://www.florensia-online.com/assets/camaleon_cms/image-not-found-4a963b95bf081c3ea02923dceaeb3f8085e1a654fc54840aac61a57a60903fef.png',
    );
  }

  Future<User> get userData async {
    DocumentSnapshot snapshot = await _getUserData();
    return _userDataFromSnapshot(snapshot);
  }
}
