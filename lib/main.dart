import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: const GamePage());
  }
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  bool isComputer = false;
  bool isActive = true;
  int time = 60;
  int player = 1;
  int computer = 2;
  List listOfGame = List.filled(9, 0);
  String status = "Your Turn";
  Timer? _timer;
  bool isPause = false;

  void pauseHandler() {
    if (_timer!.isActive) {
      _timer?.cancel();
    }
  }

  Future runComputerPlayer() async {
    return Future.delayed(Duration(milliseconds: 500), () {
      int? winning;
      int? blocking;
      int? normal;

      for (var i = 0; i < 9; i++) {
        var val = listOfGame[i];
        if (val > 0) {
          continue; // Skip squares that are already occupied.
        }

     
      }
    });
  }

  bool isWinning(int who, List<int> games) {
    return games[0] == who && games[1] == who && games[2] == who ||
        games[3] == who && games[4] == who && games[5] == who ||
        games[6] == who && games[7] == who && games[8] == who ||
        games[0] == who && games[3] == who && games[6] == who ||
        games[1] == who && games[4] == who && games[7] == who ||
        games[2] == who && games[5] == who && games[8] == who ||
        games[0] == who && games[4] == who && games[8] == who ||
        games[2] == who && games[4] == who && games[5] == who;
  }

  void startTiming() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (time > 0) {
        setState(() {
          time--;
        });
      } else {
        _timer?.cancel();
        setState(() {
          status = "Game Over!";
          isActive = false;
        });
      }
    });
  }

  @override
  void initState() {
    startTiming();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Born To Win",
          style: TextStyle(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: () {
                  _timer?.cancel();
                  setState(() {
                    time = 60;
                    listOfGame = List.filled(9, 0);
                    status = "Your Turn";
                  });
                  startTiming();
                },
                icon: const Icon(
                  Icons.restart_alt_rounded,
                  color: Colors.amber,
                  size: 30,
                )),
          )
        ],
        centerTitle: true,
        leading: Center(
          child: Text(
            time.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 60,
            ),
            Container(
              height: 400,
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.amber,
                ),
              ),
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  for (var i = 0; i < listOfGame.length; i++)
                    GestureDetector(
                      onTap: () async {
                        if (time < 1) {
                          setState(() {
                            status = "Guy the Game is Over, \nYou can Restart";
                          });
                        } else if (listOfGame[i] == 0) {
                          setState(() {
                            listOfGame[i] = player;
                            isComputer = true;
                            status = "Your Opponent turn";
                          });
                          await runComputerPlayer();
                          setState(() {
                            isComputer = false;
                            status = "Your Turn";
                          });
                        } else {
                          setState(() {
                            status = listOfGame[i] == computer
                                ? "It's Already picked by Opponent"
                                : listOfGame[i] == player
                                    ? "You've picked this already "
                                    : "Your Turn";
                          });
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: listOfGame[i] == player
                              ? Colors.amberAccent
                              : listOfGame[i] == computer
                                  ? Colors.green
                                  : Colors.amber.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          listOfGame[i] == player
                              ? "X"
                              : listOfGame[i] == computer
                                  ? "O"
                                  : "",
                          style: const TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  status,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.amber,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            const Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.amber,
                  ),
                  onPressed: () {
                    pauseHandler();
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => AlertDialog(
                        title: Text("Paused"),
                        content: Text("You've Paused The Game"),
                        actions: [
                          Container(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                startTiming();
                              },
                              child: Text("Play"),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                  child: const Text(
                    "Pause",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}
