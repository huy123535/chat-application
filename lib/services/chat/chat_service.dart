import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled2/models/message.dart';
import 'package:untitled2/services/database/database_service.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firestore.collection("users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        // go through each individual user
        final user = doc.data();

        return user;
      }).toList();
    });
  }

  Future<void> sendMessage(String receiverID, String message) async {
    //get current user
    final String currentUserID = _auth.currentUser!.uid;

    //fetch current user's username
    final currentUserName = await DatabaseService(uid: currentUserID).getUserData();
    final String CurrentUserName = currentUserName['username'];

    //fetch receiver's username
    final receiverUserName = await DatabaseService(uid: receiverID).getUserData();
    final String receiverName = receiverUserName['username'];

    final Timestamp timestamp = Timestamp.now();

    // create a new message
    Message newMessage = Message(
      senderID: currentUserID,
      senderName: CurrentUserName,
      receiverID: receiverID,
      receiverName: receiverName,
      message: message,
      timestamp: timestamp,
    );

    // construct a chat room
    List<String> ids = [currentUserID, receiverID];
    ids.sort(); // sort the ids (chatroomID is the same for 2 users)
    String chatRoomID = ids.join("_");

    // add new message to database
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());

  }
  // get messages
  Stream<QuerySnapshot> getMessages(String userID, String otherUserID) {
    // construct a chat room
    List<String> ids = [userID, otherUserID];
    ids.sort(); // sort the ids (chatroomID is the same for 2 users)
    String chatRoomID = ids.join("_");
    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
