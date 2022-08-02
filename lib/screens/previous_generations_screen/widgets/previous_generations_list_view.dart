import 'package:flutter/material.dart';

class PreviousGenerationsListView extends StatefulWidget {
  final List<String> data;
  final Future<void> Function(String) itemTapped;
  final void Function(String) onItemRemoved;
  const PreviousGenerationsListView(
      {Key? key,
      required this.data,
      required this.itemTapped,
      required this.onItemRemoved})
      : super(key: key);

  @override
  State<PreviousGenerationsListView> createState() =>
      _PreviousGenerationsListViewState();
}

class _PreviousGenerationsListViewState
    extends State<PreviousGenerationsListView> {
  @override
  Widget build(BuildContext context) {
    var data = widget.data;
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: widget.data.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () async {
              await widget.itemTapped(data[index]);
            },
            child: Dismissible(
              key: Key(data[index]),
              onDismissed: (direction) {
                setState(() {
                  widget.onItemRemoved(data[index]);
                  data.removeAt(index);
                });
              },
              child: Card(
                key: Key("${data[index]}-ListViewItem"),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          data[index],
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        key: Key('${data[index]}-DeleteButton'),
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            widget.onItemRemoved(data[index]);
                            data.removeAt(index);
                          });
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
