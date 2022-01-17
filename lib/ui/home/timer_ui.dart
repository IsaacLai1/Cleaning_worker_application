import 'dart:async';
import 'package:flutter/material.dart';

class TimerService extends ChangeNotifier {
  Stopwatch _watch;
  Timer _timer;
  Duration get currentDuration => _currentDuration;
  Duration _currentDuration = Duration.zero;
  bool get isRunning => _timer != null;

  TimerService() {
    _watch = Stopwatch();
  }

  void _onTick(Timer timer) {
    _currentDuration = _watch.elapsed;
    notifyListeners();
  }

  void start() {
    if (_timer != null) return;
    _timer = Timer.periodic(Duration(seconds: 1), _onTick);
    _watch.start();
    notifyListeners();
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _watch.stop();
    _currentDuration = _watch.elapsed;
    notifyListeners();
  }

  void reset() {
    stop();
    _watch.reset();
    _currentDuration = Duration.zero;
    notifyListeners();
  }

  static TimerService of(BuildContext context) {
    var provider = context.inheritFromWidgetOfExactType(TimerServiceProvider) as TimerServiceProvider;
    return provider.service;
  }
}

class TimerServiceProvider extends InheritedWidget {
  const TimerServiceProvider({Key key, this.service, Widget child}) : super(key: key, child: child);
  final TimerService service;
  @override
  bool updateShouldNotify(TimerServiceProvider old) => service != old.service;
}

class TimerCounter extends StatefulWidget {
  @override
  _TimerState createState() => _TimerState();
}

class _TimerState extends State<TimerCounter> {
  @override
  Widget build(BuildContext context) {
    var timerService = TimerService.of(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: AnimatedBuilder(
            animation: timerService,
            builder: (context, child) {
              return Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Align(
                          alignment: Alignment(0.0, 1.0),
                          child: Text(
                            '${timerService.currentDuration.toString().split('.').first.padLeft(8, "0")}',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 70.0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          child: Padding(
                            padding:
                                EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                            child: Expanded(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    RaisedButton(
                                      onPressed: !timerService.isRunning ? timerService.start : timerService.stop,
                                      color: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(70.0),
                                      ),
                                      child: SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.25,
                                        height: MediaQuery.of(context).size.height*0.08,
                                        child: Center(
                                          child: Text(!timerService.isRunning ? 'START' : 'RESUME',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    RaisedButton(
                                      onPressed: timerService.reset,
                                      color: Colors.blue,
                                      shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(70.0),
                                      ),
                                      child: SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.25,
                                        height: MediaQuery.of(context).size.height*0.08,
                                        child: Center(
                                          child: Text('FINISH',
                                           textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ]),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
            },
          ),
        ),
      ),
    );
  }
}

