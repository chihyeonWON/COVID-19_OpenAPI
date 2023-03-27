import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '코로나 현황',
      theme: ThemeData(
        primaryColor: Colors.yellow,
        primaryColorDark: Colors.black,
        primaryColorLight: Colors.white,
      ),
      home: MainPage(),
    );
  }
}

class CovidItem {
  String? decideCnt;
  String? deathCnt;
  String? stateDt;

  CovidItem({
    this.deathCnt,
    this.decideCnt,
    this.stateDt,
  });
}

class MainPage extends StatefulWidget {
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  DateTime now = DateTime.now();

  XmlDocument? CovidStatusXML;
  CovidItem covidItem = new CovidItem();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("코로나 현황"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.sync),
            onPressed: () async {
              var formatNow = DateFormat('yyyyMMdd').format(now);

              String url =
                  "http://openapi.data.go.kr/openapi/service/rest/Covid19/getCovid19InfStateJson?ServiceKey=%2Bq9x0o3JKslktVZYJMi%2FTrYW9IuJxIVueR07WYc84pWlM3OvnmhzshQpfTNJkcZHIQIgi%2FpKjS0kbMBYx8vqvA%3D%3D&pageNo=1&numOfRows=10&startCreateDt=${formatNow}&endCreateDt=${formatNow}";

              var response = await http.get(Uri.parse(url));

              // print(response.body);
              CovidStatusXML = XmlDocument.parse(response.body);
              // print(response.body);
              final items = CovidStatusXML!.findAllElements('item');
              print(items);

              items.forEach((element) {
                covidItem = CovidItem(
                  deathCnt: element.getElement('deathCnt')?.text,
                  decideCnt: element.getElement('decideCnt')?.text,
                  stateDt: element.getElement('stateDt')?.text,
                );
              });
            },
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomRight,
              stops: [
                0.8,
                0.99,
              ],
              colors: [
                Theme.of(context).primaryColorLight,
                Colors.white,
              ]),
        ),
        child: Container(
          margin: EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: _CovidItemPanel(
                      title: "확진자",
                      value: covidItem.decideCnt ?? "",
                      textStyle: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: _CovidItemPanel(
                      title: "사망자",
                      value: covidItem.deathCnt ?? "",
                      textStyle: TextStyle(
                        fontSize: 36,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: _CovidItemPanel(
                      title: "등록일",
                      value: covidItem.stateDt ?? "",
                      textStyle: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CovidItemPanel extends StatefulWidget {
  _CovidItemPanel({Key? key, this.title, this.value, this.textStyle})
      : super(key: key);

  String? title;
  String? value;
  TextStyle? textStyle;

  @override
  _CovidItemPanelState createState() => _CovidItemPanelState();
}

class _CovidItemPanelState extends State<_CovidItemPanel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4),
      padding: EdgeInsets.all(16),
      height: 110,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.7, 0.9],
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withAlpha(180),
              ],
              tileMode: TileMode.repeated),
          boxShadow: [
            BoxShadow(
                offset: const Offset(5, 5), blurRadius: 5, spreadRadius: 1),
          ]),
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              widget.title.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ),
          Text(
            widget.value.toString(),
            style: widget.textStyle,
          )
        ],
      ),
    );
  }
}
