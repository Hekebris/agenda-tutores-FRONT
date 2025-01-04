import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Tutoapp/providers/userProvider.dart';
import '../SolicitudesBack.dart';
import '../widgets/customOutputs.dart';
import 'home.dart';
import 'Settings.dart';
import 'PreguntasFrecuentes.dart';
import 'Perfil.dart';
import 'Citas.dart';
import 'CitasTutores.dart';

class AppNavigator extends StatefulWidget {
  @override
  _AppNavigatorState createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  int _selectedIndex = 0;

  List<Map<String, dynamic>> avi = [];
  List<Map<String, dynamic>> qas = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = [
      HomeScreen(
        avi: avi,
        uploadingAvisos: (data) {
          avi = data;
        },
      ),
      _CitasScreen(),
      QAScreen(
        qas: qas,
        uploadingQas: (data) {
          qas = data;
        },
      )
    ];
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 82, 113, 255),
          title: const Text('TutoApp'),
          titleTextStyle: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.settings,
                size: 30,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  AntiqueiPhonePageRoute(widget: const SettingsScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.account_circle_sharp,
                size: 35,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  AntiqueiPhonePageRoute(widget: const ProfileScreen()),
                );
              },
            ),
          ],
        ),
        body: widgetOptions[_selectedIndex],
        bottomNavigationBar: ClipRRect(
          /*borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40.0),
            topRight: Radius.circular(40.0),
            bottomLeft: Radius.circular(40.0),
            bottomRight: Radius.circular(40.0),
          ),*/
          child: Container(
            //margin: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: const BoxDecoration(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BottomNavigationBar(
                  //backgroundColor: Colors.transparent,
                  selectedItemColor: const Color.fromARGB(255, 82, 113, 255),
                  unselectedItemColor: Colors.grey[900],
                  currentIndex: _selectedIndex,
                  onTap: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home_filled),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.calendar_today_outlined),
                      label: 'Citas',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.question_mark),
                      label: 'QAs',
                    ),
                  ],
                ),
                //const SizedBox(height: 8.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }
}

class _CitasScreen extends StatefulWidget {
  @override
  _CitasScreenState createState() => _CitasScreenState();
}

class _CitasScreenState extends State<_CitasScreen> {
  @override
  Widget build(BuildContext context) {
    if (context.read<UserProvider>().getIsTutor()) {
      return const CitasTScreen();
    } else if (context.read<UserProvider>().hasTutor()) {
      return CitasScreen();
    } else {
      return NeedaTutor(
        onRefresh: () {
          getUserInfo().then((value) => {
                if (value.containsKey('Error'))
                  {showMsg(context, value['Error'], Colors.red)}
                else
                  {
                    setState(() {
                      context.read<UserProvider>().setTutor(value['Tutor']);
                    })
                  }
              });
        },
      );
    }
  }
}

class NeedaTutor extends StatefulWidget {
  final VoidCallback onRefresh;

  const NeedaTutor({Key? key, required this.onRefresh}) : super(key: key);

  @override
  _NeedaTutorState createState() => _NeedaTutorState();
}

class _NeedaTutorState extends State<NeedaTutor> {
  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 2));
    widget.onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView(
        children: const [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Icon(Icons.sentiment_dissatisfied, size: 70),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Parece que tu Coordinador aún no te ha asignado un tutor, dale un poco de tiempo para que seas asignado.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}

class AntiqueiPhonePageRoute extends PageRouteBuilder {
  final Widget widget;

  AntiqueiPhonePageRoute({required this.widget})
      : super(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return widget;
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: offsetAnimation,
                child: child,
              ),
            );
          },
        );
}

class LoadingWidgetInfo extends StatelessWidget {
  const LoadingWidgetInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
