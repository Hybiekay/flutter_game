import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newgame/extensions.dart';
import 'package:newgame/gamepage.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseFirestore = FirebaseFirestore.instance;

  Map<String, dynamic>? userDetail;

  Future<Map<String, dynamic>?> getCurentUserDetails() async {
    try {
      var document = await firebaseFirestore
          .collection("users")
          .doc(firebaseAuth.currentUser?.uid)
          .get();
      var user = document.data();
      return (user);
    } on FirebaseException catch (err) {
    }
    return null;
  }

  Future logOut() async {
    try {
      await firebaseAuth.signOut();
      setState(() {
        userDetail = null;
      });
    } on FirebaseException catch (error) {
      print(error.message);
    }
  }

  Future login() async {
    if (firebaseAuth.currentUser != null) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("Already Register"),
                actions: [
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                          await logOut();
                        },
                        child: const Text(
                          "Log Out",
                          style: TextStyle(color: Colors.black),
                        )),
                  )
                ],
              ));
    } else {
      try {
        var cred = await firebaseAuth.signInWithProvider(GoogleAuthProvider());
        var document = await firebaseFirestore
            .collection("users")
            .doc(cred.user?.uid)
            .get();
        try {
          var cred =
              await firebaseAuth.signInWithProvider(GoogleAuthProvider());
          var document = await firebaseFirestore
              .collection("users")
              .doc(cred.user?.uid)
              .get();
          var user = document.data();
          if (user == null) {
            Map<String, dynamic> userData = {
              "name": cred.user?.email?.toUsername() ?? "User",
              "email": cred.user?.email,
              "profile": cred.additionalUserInfo?.profile?["picture"],
              "coin": 0,
              "uid": cred.user?.uid
            };
            await firebaseFirestore
                .collection("users")
                .doc(cred.user?.uid)
                .set(userData);
            setState(() {
              userDetail = userData;
            });
          } else {
            setState(() {
              userDetail = user;
            });
          }
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("You have succesfully login"),
            backgroundColor: Colors.green,
          ));
        } on FirebaseAuthException catch (error) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("${error.message}"),
            backgroundColor: Colors.red,
          ));
        }
        var user = document.data();
        if (user == null) {
          Map<String, dynamic> userData = {
            "name": cred.user?.email?.toUsername() ?? "User",
            "email": cred.user?.email,
            "profile": cred.additionalUserInfo?.profile?["picture"],
            "coin": 0,
            "uid": cred.user?.uid
          };
          await firebaseFirestore
              .collection("users")
              .doc(cred.user?.uid)
              .set(userData);
          setState(() {
            userDetail = userData;
          });
        } else {
          setState(() {
            userDetail = user;
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("You have succesfully login"),
          backgroundColor: Colors.green,
        ));
      } on FirebaseAuthException catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${error.message}"),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  @override
  void initState() {
    getCurentUserDetails().then((value) {
      setState(() {
        userDetail = value;
      });
      print("object");
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const CircleAvatar(),
            const SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: login,
              child: Text(
                userDetail != null ? userDetail!["name"] : "Log In",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        centerTitle: false,
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: MediaQuery.sizeOf(context).width / 2,
                  width: MediaQuery.sizeOf(context).width / 2 - 20,
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  height: MediaQuery.sizeOf(context).width / 2,
                  width: MediaQuery.sizeOf(context).width / 2 - 20,
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      userDetail != null ? userDetail!["coin"].toString() : "0",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15).copyWith(
                top: 20,
              ),
              child: const Divider(
                thickness: 1,
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const GamePage()));
                },
                child: const Text(
                  "Play with computer",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                ),
                onPressed: () {
                  if (firebaseAuth.currentUser != null) {
                    showDialog(
                      context: context,
                      builder: (context) => ShowOtherUSer(
                        userDetail: userDetail!,
                      ),
                    );
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                            title: const Text(
                              "Kindly Log In",
                              textAlign: TextAlign.center,
                            ),
                            alignment: Alignment.center,
                            content: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber,
                                ),
                                onPressed: firebaseAuth.currentUser == null
                                    ? () {}
                                    : null,
                                child: Text(firebaseAuth.currentUser == null
                                    ? " Login With gmail"
                                    : ""),
                              ),
                            )));
                  }
                },
                child: const Text(
                  "Play with other user",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15).copyWith(
                top: 20,
              ),
              child: const Divider(
                thickness: 1,
              ),
            ),
            const Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Top Users",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
                child: StreamBuilder(
              stream: firebaseFirestore.collection("users").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    child: const Column(
                      children: [
                        Icon(
                          Icons.no_accounts,
                          size: 150,
                          color: Colors.amber,
                        ),
                        Text(
                          "Waiting",
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        )
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Container(
                    child: const Column(
                      children: [
                        Icon(
                          Icons.not_interested,
                          size: 150,
                          color: Colors.amber,
                        ),
                        Text(
                          "Check your internet connection",
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        )
                      ],
                    ),
                  );
                } else if (snapshot.hasData) {
                  var rawdata = snapshot.data;
                  var listOfData = rawdata!.docs;

                  return ListView.builder(
                      itemCount: listOfData.length,
                      itemBuilder: (context, index) {
                        listOfData.sort(
                            (high, low) => low["coin"].compareTo(high["coin"]));
                        var data = listOfData[index].data();

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              data["profile"],
                            ),
                          ),
                          title: Text(data["name"]),
                          trailing: Text(data["coin"].toString()),
                        );
                      });
                } else {
                  return Container(
                    child: const Column(
                      children: [
                        Icon(
                          Icons.no_accounts,
                          size: 150,
                          color: Colors.amber,
                        ),
                        Text(
                          "error",
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        )
                      ],
                    ),
                  );
                }
              },
            )),
          ],
        ),
      ),
    );
  }
}

class ShowOtherUSer extends StatefulWidget {
  final Map userDetail;
  const ShowOtherUSer({
    super.key,
    required this.userDetail,
  });

  @override
  State<ShowOtherUSer> createState() => _ShowOtherUSerState();
}

class _ShowOtherUSerState extends State<ShowOtherUSer> {
  TextEditingController searchController = TextEditingController();
  final firestore = FirebaseFirestore.instance;

  bool isSearch = false;

  initialiseGame(opponent) async {
    var docs = await firestore
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("games")
        .doc(opponent["uid"])
        .get();
    var opponentData = docs.data();
    if (opponentData == null) {
      var docs = await firestore
          .collection("users")
          .doc(opponent['uid'])
          .collection("games")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get();

      var myData = docs.data();

      if (myData == null) {
        var gameData = {
          "name": widget.userDetail["name"],
          "winingCount": 0,
          "coin": 0,
          "uid": widget.userDetail["uid"],
          "opponentName": opponent["name"],
          "opponentWiningCount": 0,
          "opponentcoin": 0,
          "opponentUid": opponent["uid"]
        };
        await firestore
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection("games")
            .doc(opponent["uid"])
            .set(gameData);

        await firestore
            .collection("users")
            .doc(opponent["uid"])
            .collection("games")
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .set(gameData);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 500,
        width: double.infinity,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 10,
              ),
              child: TextField(
                controller: searchController,
                onChanged: (v) {
                  if (v != '') {
                    setState(() {
                      isSearch = true;
                    });
                    print("you are seaching $v");
                  } else {
                    setState(() {
                      isSearch = false;
                    });
                    print("you stop seaching $v");
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: "Search your opponent",
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  suffixIcon: const Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
                child: isSearch
                    ? StreamBuilder(
                        stream: firestore
                            .collection("users")
                            .where(
                              "name",
                              isGreaterThanOrEqualTo: searchController.text,
                            )
                            .snapshots(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(child: Text("Searching......"));
                          } else if (snapshot.hasData) {
                            List rawData = snapshot.data?.docs;
                            if (rawData.isEmpty) {
                              return Container(
                                child: const Column(
                                  children: [
                                    Icon(
                                      Icons.not_interested,
                                      size: 150,
                                      color: Colors.amber,
                                    ),
                                    Text(
                                      "No One Found",
                                      style: TextStyle(
                                        fontSize: 25,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            } else {
                              return ListView.builder(
                                  itemCount: rawData.length,
                                  itemBuilder: (context, index) {
                                    var user = rawData[index].data();
                                    print(user);
                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(user["profile"]),
                                      ),
                                      title: Text(user["name"]),
                                    );
                                  });
                            }
                          } else {
                            return Container(
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.not_interested,
                                    size: 150,
                                    color: Colors.amber,
                                  ),
                                  Text(
                                    "Check your internet connection",
                                    style: TextStyle(
                                      fontSize: 25,
                                    ),
                                  )
                                ],
                              ),
                            );
                          }
                        },
                      )
                    : FutureBuilder(
                        future: firestore.collection("users").get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.amber,
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return const Center(
                              child: Text("Check your Internet connection"),
                            );
                          } else if (snapshot.hasData &&
                              snapshot.data!.docs.isEmpty) {
                            return Container(
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.not_interested,
                                    size: 150,
                                    color: Colors.amber,
                                  ),
                                  Text(
                                    "No One Found",
                                    style: TextStyle(
                                      fontSize: 25,
                                    ),
                                  )
                                ],
                              ),
                            );
                          } else {
                            var rawdata = snapshot.data?.docs;

                            return ListView.builder(
                                itemCount: rawdata?.length ?? 0,
                                itemBuilder: (context, index) {
                                  var user = rawdata![index].data();
                                  return GestureDetector(
                                    onTap: () async {
                                      print("start");
                                      await initialiseGame(user);
                                      print("end");
                                    },
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(user["profile"]),
                                      ),
                                      title: Text("${user["name"]}"),
                                    ),
                                  );
                                });
                          }
                        },
                      ))
          ],
        ),
      ),
    );
  }
}
