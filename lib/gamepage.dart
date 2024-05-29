import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage>
    with SingleTickerProviderStateMixin {
  int winningCount = 0;
  int coins = 0;
  bool isComputer = false;
  bool isActive = true;
  int time = 60;
  int player = 1;
  int computer = 2;
  List<int> listOfGame = List.filled(9, 0);
  String status = "Your Turn";
  Timer? _timer;
  bool isPause = false;

  void pauseHandler() {
    if (_timer!.isActive) {
      _timer?.cancel();
    }
  }

  Future runComputerPlayer() async {
    // if (isWinning(player, listOfGame)) {}

    if (listOfGame.every((element) => element != 0) && time > 2) {
      setState(() {
        listOfGame = List.filled(9, 0);
      });
    }

    if (isWinning(player, listOfGame)) {
      setState(() {
        winningCount++;
        coins += 30;
        listOfGame = List.filled(9, 0);
      });

      if (winningCount == 5) {
        _timer?.cancel();
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                "You Won!",
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              content: SizedBox(
                height: 198,
                child: Column(
                  children: [
                    Image.asset(
                      "images/money.png",
                      height: 100,
                    ),
                    Text(
                      "$coins",
                      style: const TextStyle(
                        color: Colors.amber,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                        ),
                        onPressed: () {
                          setState(() {
                            listOfGame = List.filled(9, 0);
                            status = "Your Turn";
                            time = 60;
                          });

                          Navigator.pop(context);
                          startTiming();
                        },
                        child: const Text(
                          "Restart",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      }
    } else {
      return Future.delayed(const Duration(milliseconds: 500), () {
        int? winning;
        int? blocking;
        List<int> availableMoves = [];

        for (var i = 0; i < 9; i++) {
          var val = listOfGame[i];
          if (val > 0) {
            continue; // Skip squares that are already occupied.
          }

          var newList = [...listOfGame];
          newList[i] = computer;
          // sumulating cumputer
          if (isWinning(computer, newList)) {
            winning = i;
          }

          ////
          newList[i] = player;
          if (isWinning(player, newList)) {
            blocking = i;
          }
          //normal =;
          availableMoves.add(i);
        }

        //  var move = winning ?? blocking ?? normal;

        // if (move != null) {
        //   setState(() {
        //     listOfGame[move] = computer;
        //   });
        // }

        if (winning != null) {
          // Take winning move if available
          makeMove(winning);
        } else if (blocking != null) {
          // Take blocking move if available
          makeMove(blocking);
        } else {
          if (availableMoves.isNotEmpty) {
            var random = Random();
            var randomIndex = random.nextInt(availableMoves.length);
            var randomMove = availableMoves[randomIndex];
            makeMove(randomMove);
          }
        }

        if (isWinning(computer, listOfGame)) {
          _timer?.cancel();

          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text(
                  "You Lost Try Again !",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                content: SizedBox(
                  height: 198,
                  child: Column(
                    children: [
                      Image.asset(
                        "images/money.png",
                        height: 100,
                      ),
                      Text(
                        "$coins",
                        style: const TextStyle(
                          color: Colors.amber,
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                          ),
                          onPressed: () {
                            setState(() {
                              coins = 0;
                              winningCount = 0;
                              listOfGame = List.filled(9, 0);
                              status = "Your Turn";
                              time = 60;
                            });

                            Navigator.pop(context);
                            startTiming();
                          },
                          child: const Text(
                            "Restart",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        }
      });
    }
  }

  void makeMove(int move) {
    setState(() {
      listOfGame[move] = computer;
    });
    if (listOfGame.every((element) => element != 0) && time > 2) {
      setState(() {
        listOfGame = List.filled(9, 0);
      });
    }
  }

  bool isWinning(int who, List<int> games) {
    return games[0] == who && games[1] == who && games[2] == who || // row
        games[3] == who && games[4] == who && games[5] == who || // row
        games[6] == who && games[7] == who && games[8] == who || // row
        games[0] == who && games[3] == who && games[6] == who || // colunm
        games[1] == who && games[4] == who && games[7] == who || //colunm
        games[2] == who && games[5] == who && games[8] == who || //colum
        games[0] == who && games[4] == who && games[8] == who || // diaganal
        games[2] == who && games[4] == who && games[6] == who; //
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
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                "Time Over !",
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              content: SizedBox(
                height: 198,
                child: Column(
                  children: [
                    Image.asset(
                      "images/money.png",
                      height: 100,
                    ),
                    Text(
                      "$coins",
                      style: const TextStyle(
                        color: Colors.amber,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                        ),
                        onPressed: () {
                          setState(() {
                            listOfGame = List.filled(9, 0);
                            status = "Your Turn";
                            time = 60;
                            coins = 0;
                            winningCount = 0;
                          });

                          Navigator.pop(context);
                          startTiming();
                        },
                        child: const Text(
                          "Restart",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
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
    final width = MediaQuery.of(context).size.width;
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
          Row(
            children: [
              Image.asset(
                "images/money.png",
                height: 30,
              ),
              Text(
                "$coins",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.amber),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: () {
                  _timer?.cancel();

                  setState(() {
                    time = 60;
                    coins = 0;
                    winningCount = 0;
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
        leadingWidth: 70,
        leading: Row(
          children: [
            Center(
              child: Text(
                time.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Row(
              children: [
                Text(
                  '$winningCount',
                  style: TextStyle(
                    color: winningCount > 1 ? Colors.amber : Colors.grey,
                    fontSize: 20,
                  ),
                ),
                Text(
                  '/',
                  style: TextStyle(
                    color: winningCount > 1 ? Colors.amber : Colors.grey,
                    fontSize: 20,
                  ),
                ),
                const Text(
                  '5',
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 20,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      body: Stack(
        children: [
          Center(
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
                                status =
                                    "Guy the Game is Over, \nYou can Restart";
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
                const SizedBox(
                  height: 30,
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: GestureDetector(
                    // onTap: _animateWidget,
                    child: Image.asset(
                      "images/money.png",
                      height: 70,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
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
                            title: const Text("Paused"),
                            content: const Text("You've Paused The Game"),
                            actions: [
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.amber,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    startTiming();
                                  },
                                  child: const Text("Play"),
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
                const SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
