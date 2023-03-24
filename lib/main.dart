import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '코로나 현황',
      theme: ThemeData(
          primaryColor: const Color(0xFF264653),
          primaryColorDark: const Color(0xFF2A9D8F),
          primaryColorLight: const Color(0xFFE9C46A),
      ),
      home: MainPage(),
    );
  }
}

class CovidItem {
  String ? accDefRate;
  String ? accExamCnt;
  String ? accExamCompCnt;
  String ? careCnt;
  String ? clearCnt;
  String ? deathCnt;
  String ? decideCnt;
  String ? examCnt;
  String ? resutlNegCnt;
  String ? seq;
  String ? stateDt;
  String ? stateTime;
  String ? updateDt;
  String ? createDt;

  CovidItem(
      {this.accDefRate,
        this.accExamCnt,
        this.accExamCompCnt,
        this.careCnt,
        this.clearCnt,
        this.deathCnt,
        this.decideCnt,
        this.examCnt,
        this.resutlNegCnt,
        this.seq,
        this.stateDt,
        this.stateTime,
        this.updateDt,
        this.createDt});
}

class MainPage extends StatefulWidget {
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
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
              const url =
                  "http://openapi.data.go.kr/openapi/service/rest/Covid19/getCovid19InfStateJson?ServiceKey=%2Bq9x0o3JKslktVZYJMi%2FTrYW9IuJxIVueR07WYc84pWlM3OvnmhzshQpfTNJkcZHIQIgi%2FpKjS0kbMBYx8vqvA%3D%3D&pageNo=1&numOfRows=10&startCreateDt=20210117&endCreateDt=20210117";
              var response = await http.get(Uri.parse(url));

              // print(response.body);
              CovidStatusXML = XmlDocument.parse(response.body);
              // print(response.body);
              final items = CovidStatusXML!.findAllElements('item');
              print(items);

              items.forEach((element) {
                covidItem = CovidItem(
                  accDefRate: element.getElement('accDefRate')!.text,
                  accExamCnt: element.getElement('accExamCnt')!.text,
                  accExamCompCnt: element.getElement('accExamCompCnt')!.text,
                  careCnt: element.getElement('careCnt')!.text,
                  clearCnt: element.getElement('clearCnt')!.text,
                  deathCnt: element.getElement('deathCnt')!.text,
                  decideCnt: element.getElement('decideCnt')!.text,
                  examCnt: element.getElement('examCnt')!.text,
                  resutlNegCnt: element.getElement('resutlNegCnt')!.text,
                  seq: element.getElement('seq')!.text,
                  stateDt: element.getElement('stateDt')!.text,
                  stateTime: element.getElement('stateTime')!.text,
                  updateDt: element.getElement('updateDt')!.text,
                  createDt: element.getElement('createDt')!.text,
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
                Theme.of(context).backgroundColor,
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
                        fontSize: 36,
                      ),
                    ),
                  ),
                  Expanded(
                    child: _CovidItemPanel(
                      title: "격리해제",
                      value: covidItem.clearCnt.toString(),
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
                      title: "검사진행",
                      value: covidItem.examCnt.toString(),
                      textStyle: TextStyle(
                        fontSize: 36,
                      ),
                    ),
                  ),
                  Expanded(
                    child: _CovidItemPanel(
                      title: "사망자",
                      value: covidItem.deathCnt.toString(),
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
                      title: "치료중인 환자",
                      value: covidItem.careCnt.toString(),
                      textStyle: TextStyle(
                        fontSize: 36,
                      ),
                    ),
                  ),
                  Expanded(
                    child: _CovidItemPanel(
                      title: "결과 음성",
                      value: covidItem.resutlNegCnt.toString(),
                      textStyle: TextStyle(
                        fontSize: 32,
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
                      title: "누적검사",
                      value: covidItem.accExamCnt.toString(),
                      textStyle: TextStyle(
                        fontSize: 32,
                      ),
                    ),
                  ),
                  Expanded(
                    child: _CovidItemPanel(
                      title: "누적 검사 완료",
                      value: covidItem.accExamCompCnt.toString(),
                      textStyle: TextStyle(
                        fontSize: 32,
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
                      title: "누적 환진률",
                      textStyle: TextStyle(
                        fontSize: 36,
                      ),
                    ),
                  ),
                  Expanded(
                    child: _CovidItemPanel(
                      title: "등록일",
                      value: covidItem.createDt.toString(),
                      textStyle: TextStyle(
                        fontSize: 36,
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
  _CovidItemPanel({Key? key, this.title, this.value, this.textStyle}): super(key: key);

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
                offset: const Offset(5, 5),
                blurRadius: 5,
                spreadRadius: 1),
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
                fontSize: 18,
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