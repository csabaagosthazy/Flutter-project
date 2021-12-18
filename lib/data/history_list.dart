import 'package:flutter/material.dart';
import 'package:flutter_group2_tshirt_project/data/tshirt_data.dart';

class HistoryList extends StatefulWidget {
  final List<TshirtData> historyItems;

  HistoryList(this.historyItems);

  @override
  _HistoryListState createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.historyItems.length,
      itemBuilder: (context, index) {
        var item = widget.historyItems[index];
        return Card(
            child: Row(children: <Widget>[
          Expanded(
              child: ListTile(
                  title: Text(item.toString())))
        ]));
      },
    );
  }
}
