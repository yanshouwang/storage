import 'package:clover/clover.dart';
import 'package:flutter/material.dart';
import 'package:storage_example/view_models.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = ViewModel.of<HomeViewModel>(context);
    final volumes = viewModel.volumes;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Storage Example'),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        child: TableView.list(
          pinnedColumnCount: 1,
          columnBuilder: (index) {
            final extent = index == 0
                ? FractionalSpanExtent(0.7)
                : FractionalSpanExtent(0.3);
            return TableSpan(
              extent: extent,
              backgroundDecoration: SpanDecoration(
                border: SpanBorder(
                  leading: index == 0 ? BorderSide() : BorderSide.none,
                  trailing: BorderSide(),
                ),
              ),
            );
          },
          rowBuilder: (index) {
            return TableSpan(
              extent: FixedSpanExtent(40.0),
              backgroundDecoration: SpanDecoration(
                border: TableSpanBorder(
                  leading: index == 0 ? BorderSide() : BorderSide.none,
                  trailing: BorderSide(),
                ),
              ),
            );
          },
          cells: [
            [
              TableViewCell(
                child: Text('Path'),
              ),
              TableViewCell(
                child: Text('State'),
              ),
              TableViewCell(
                child: Text('IsEmulated'),
              ),
              TableViewCell(
                child: Text('IsPrimary'),
              ),
              TableViewCell(
                child: Text('IsRemovable'),
              ),
            ],
            ...volumes.map((volume) {
              return [
                TableViewCell(
                  child: Text(volume.path),
                ),
                TableViewCell(
                  child: Text(volume.state.name),
                ),
                TableViewCell(
                  child: Text('${volume.isEmulated}'),
                ),
                TableViewCell(
                  child: Text('${volume.isPrimary}'),
                ),
                TableViewCell(
                  child: Text('${volume.isRemovable}'),
                ),
              ];
            })
          ],
        ),
      ),
    );
  }
}
