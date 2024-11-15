import 'package:attendance/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Details extends StatefulWidget {
  const Details({super.key});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  String? username = '';
  DateTime? checkin;
  DateTime? checkout;
  Duration duration = const Duration();
  bool ischeckedin = false;
  bool isRecorded = false;

  @override
  void initState() {
    super.initState();
    _getUsername();
  }

  Future<void> _getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    String? storedUsername = prefs.getString('name');
    setState(() {
      username = storedUsername;
    });
  }

  void _toggleCheckInOut() {
    setState(() {
      if (ischeckedin) {
        checkout = DateTime.now();
        if (checkin != null) {
          duration = checkout!.difference(checkin!);
        }
        ischeckedin = false;
        isRecorded = true;
      } else {
        checkin = DateTime.now();
        ischeckedin = true;
        duration = const Duration();
        isRecorded = false;
      }
    });
  }

  String getFormattedDuration() {
    int hours = duration.inHours;
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60;
    return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String getFormattedTime(DateTime? time) {
    if (time == null) {
      return 'N/A';
    } else {
      return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    text: "",
                    style: TextStyle(fontSize: 30, color: Colors.white),
                    children: <TextSpan>[
                      TextSpan(
                        text: "W",
                        style: TextStyle(
                          fontSize: 40,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: "elcome",
                        style: TextStyle(fontSize: 30, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Text(
                  " $username",
                  style: const TextStyle(fontSize: 30, color: Colors.white),
                ),
              ],
            ),
            const Spacer(),
            IconButton(
              onPressed: () async {
               final SharedPreferences prefs = await SharedPreferences.getInstance();
               await prefs.remove('name');
                await prefs.remove('isLoggedIn');
                
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              },
              icon: const Icon(
                Icons.logout_outlined,
                color: Colors.red,
                size: 40,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          SizedBox(
            height: 130,
            width: 350,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                shadowColor: Colors.black,
                elevation: 15,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          const Text(
                            "Check In ",
                            style: TextStyle(fontSize: 25),
                          ),
                          Text(
                            getFormattedTime(checkin),
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          const Text(
                            "Check Out ",
                            style: TextStyle(fontSize: 25),
                          ),
                          Text(
                            getFormattedTime(checkout),
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const SizedBox(height: 70),
          isRecorded
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    "Response has been recorded",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              : GestureDetector(
                  onTap: _toggleCheckInOut,
                  child: Container(
                    width: 120.0,
                    height: 120.0,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          ischeckedin
                              ? const Color.fromARGB(255, 27, 165, 73)
                                  .withOpacity(0.8)
                              : const Color.fromARGB(255, 81, 149, 221),
                          ischeckedin
                              ? const Color.fromARGB(255, 26, 179, 95)
                                  .withOpacity(0.6)
                              : const Color.fromARGB(255, 198, 210, 223)
                        ],
                        begin: Alignment.centerRight,
                        end: Alignment.topLeft,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black,
                          offset: Offset(4, 4),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        ischeckedin ? "Check Out" : "Check In",
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
          const SizedBox(height: 20),
          Text("Duration: ${getFormattedDuration()}",
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const Spacer(),
          const SizedBox(
            height: 70,
            width: 300,
            child: Card(
              color: Colors.black,
              child: Center(
                  child: Text("Register",
                      style: TextStyle(color: Colors.white, fontSize: 30))),
            ),
          ),
        ],
      ),
    );
  }
}
