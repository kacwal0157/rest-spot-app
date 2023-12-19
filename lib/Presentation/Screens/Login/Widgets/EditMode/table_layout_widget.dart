import 'package:aws_cognito_app/app_manager.dart';
import 'package:flutter/material.dart';

class TableLayoutWidget extends StatefulWidget {
  const TableLayoutWidget({super.key});

  @override
  TableLayoutWidgetState createState() => TableLayoutWidgetState();
}

class TableLayoutWidgetState extends State<TableLayoutWidget> {
  List<List<Color>> _tableData = [];
  int _rows = AppManager.config.categoryLayout['numberInRow']!;
  int _cols = AppManager.config.categoryLayout['numberInCol']!;

  @override
  void initState() {
    super.initState();
    _initializeTableData();
  }

  void _initializeTableData() {
    _tableData = List.generate(5, (_) => List.filled(5, Colors.white));
    for (int row = 0; row <= _rows; row++) {
      for (int col = 0; col <= _cols; col++) {
        _tableData[row][col] = Colors.blue;
      }
    }
  }

  void _toggleCellColor(int row, int col) {
    setState(() {
      Color toggleColor = Colors.blue;
      _rows = row;
      _cols = col;

      _resetCellColor();

      for (var cellRow = 0; cellRow <= row; cellRow++) {
        for (var cellCol = 0; cellCol <= col; cellCol++) {
          _tableData[cellRow][cellCol] = toggleColor;
        }
      }
    });
  }

  void _resetCellColor() {
    Color defaultColor = Colors.white;
    for (var cellRow = 0; cellRow < _tableData.length; cellRow++) {
      for (var cellCol = 0; cellCol < _tableData[cellRow].length; cellCol++) {
        _tableData[cellRow][cellCol] = defaultColor;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edytor układu"),
      actions: [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  child: const Text('Zaakcpetuj'),
                  onPressed: () {
                    AppManager.configService.editCategoryLayout(_rows, _cols);
                    Navigator.of(context).pop();
                  },
                ),
              ),
              TextButton(
                child: const Text("Odrzuć"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ],
      content: SizedBox(
        height: 400,
        width: 600,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(7, 7),
                  ),
                ],
              ),
              child: Table(
                defaultColumnWidth: const FixedColumnWidth(100.0),
                border: TableBorder.all(),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: List.generate(5, (row) {
                  return TableRow(
                    children: List.generate(5, (col) {
                      return GestureDetector(
                        onTap: () => _toggleCellColor(row, col),
                        child: Container(
                          height: 80,
                          color: _tableData[row][col],
                        ),
                      );
                    }),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
