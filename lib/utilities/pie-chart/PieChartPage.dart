import 'package:fl_chart/fl_chart.dart';
import 'package:haggle/utilities/pie-chart/ChartWidget/LegendWidget.dart';
import 'package:haggle/utilities/pie-chart/ChartWidget/PieChartSections.dart';
import 'package:flutter/material.dart';

class PieChartPage extends StatefulWidget {
  final  List myProducts;
  const PieChartPage({Key? key, required this.myProducts}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PieChartState();
}

class PieChartState extends State<PieChartPage> {




  @override
  Widget build(BuildContext context){
    final Iterable completed = widget.myProducts.where((product) => product.isCompleted == true && product.lastBidPrice > product.minBidPrice);
    final Iterable notCompleted = widget.myProducts.where((product) => product.isCompleted == true && DateTime.now().millisecondsSinceEpoch > product.lastBidTime.seconds * 1000 && product.lastBidPrice == 0 );
    final Iterable onGoing = widget.myProducts.where((product) => product.isCompleted == false && DateTime.now().millisecondsSinceEpoch < product.lastBidTime.seconds * 1000 );


    getPercentage(type, com, inCom, onGoing){

      return ((type.toList().length/(com.toList().length + inCom.toList().length + onGoing.toList().length)) * 100);

    }


    List<Data> data = [
      Data(name: 'Ongoing - ${onGoing.toList().isEmpty ? 0 : onGoing.toList().length }',
          percent: onGoing.toList().isEmpty ? 0 :
          double.parse(getPercentage(onGoing, completed, notCompleted, onGoing).toStringAsFixed(2)), color: const Color(0xff0293ee)),
      Data(name: 'Not Completed - ${notCompleted.toList().isEmpty ? 0 : notCompleted.toList().length}',
          percent: notCompleted.toList().isEmpty ? 0 :
          double.parse(getPercentage(notCompleted, completed, notCompleted, onGoing).toStringAsFixed(2)), color: Colors.red),
      Data(name: 'Completed - ${completed.toList().isEmpty ? 0 :
      completed.toList().length}',
          percent: completed.toList().isEmpty ? 0 :  double.parse(getPercentage(completed, completed, notCompleted, onGoing).toStringAsFixed(2)), color: const Color(0xff13d38e)),
    ];




    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 160,
          width: 160,
          child: PieChart(
            PieChartData(
              borderData: FlBorderData(show: false),
              sectionsSpace: 0,
              centerSpaceRadius: 0,
              sections: getSections(data),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Container(
            alignment: Alignment.center,
            child: LegendWidget(productData: data,),
          ),
        )
      ],
    );
  }
}


class Data {
  final String name;

  final double percent;

  final Color color;

  Data({required this.name, required this.percent, required this.color});
}
