import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_unity_widget_example/models/athlete.dart';
import 'package:flutter_unity_widget_example/models/user.dart';

class DatabaseService {

  final String uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference athleteCollection = Firestore.instance.collection('athletes');
  final CollectionReference coachCollection = Firestore.instance.collection('trainers');

  Future updateUserData(String name) async {
    return await athleteCollection.document(uid).setData({
      'name': name,
      'players' : FieldValue.arrayUnion([]),
    });
  }

  // test function
  Future addNewAthlete(List playersList) async {
    //return await coachCollection.document(uid).collection('athletes').document(name).setData({
    return await athleteCollection.document(uid).updateData({'players' : FieldValue.arrayUnion(playersList)});
  }

  // add new entry with user defined key values (just need to make the value an array of strings)
  Future addNewData(String key, List dataList) async {
    return await athleteCollection.document(uid).updateData({
      key : FieldValue.arrayUnion(dataList),
    });
  }

  // // athlete list from snapshot
  // List<Athlete> _athleteListFromSnapshot(QuerySnapshot snapshot) {
  //   return snapshot.documents.map((doc){
  //     return Athlete(
  //       name: doc.data['name'] ?? '',
  //       sport: doc.data['sport'] ?? '',
  //       age: doc.data['age'] ?? '',
  //       players: doc.data['players'] ?? '',
  //     );
  //   }).toList();
  // }

  // athlete list from snapshot
  Athlete _athleteListFromSnapshot(DocumentSnapshot snapshot) {
    return Athlete(
      name: snapshot.data['name'] ?? '',
      players: snapshot.data['players'] ?? '',
    );
  }

  // user data from snapshot
  UserData _userDataFromSnapShot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data['name'] ?? '',
      sport: snapshot.data['sport'] ?? '',
    );
  }

  // get database stream
  Stream<Athlete> get athletes {
    return athleteCollection.document(uid).snapshots().map(_athleteListFromSnapshot);
  }

  // get user doc stream
  Stream<UserData> get userData {
    return athleteCollection.document(uid).snapshots().map(_userDataFromSnapShot);
  }

}


