import 'package:flutter/material.dart';
import 'package:arsipku/providers/booklist_provider.dart';
import 'package:arsipku/screens/book-input.dart';
import 'package:arsipku/widgets/home/book-list.dart';
import 'package:arsipku/widgets/home/header.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key}) : super(key: key);

  _newBook(BuildContext addButtonContext) async {
    final result = await Navigator.of(addButtonContext).pushNamed(
      BookInputScreen.routeName,
    );

    if (result == 200) {
      Scaffold.of(addButtonContext)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text("Berhasil menambah buku"),
            backgroundColor: Colors.greenAccent.shade700,
          ),
        );
      final bookListData = Provider.of<BookListProvider>(
        addButtonContext,
        listen: false,
      );
      bookListData.read(addButtonContext);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 30),
        child: Column(
          children: <Widget>[
            Header(),
            new Expanded(child: BookList()),
          ],
        ),
      ),
      floatingActionButton: Builder(
        builder: (BuildContext addButtonContext) {
          return FloatingActionButton(
            onPressed: () {
              this._newBook(addButtonContext);
            },
            tooltip: 'New Product',
            child: Icon(Icons.add),
          );
        },
      ),
    );
  }
}
