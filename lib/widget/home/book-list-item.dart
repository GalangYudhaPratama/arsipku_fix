import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:arsipku/screens/book-input.dart';

class BookListItem extends StatelessWidget {
  @required
  final String apiHost;
  @required
  final String id;
  @required
  final String title;
  @required
  final String imagePath;

  BookListItem(
      {required this.apiHost,
      required this.id,
      required this.title,
      required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Image.network(
        "${this.apiHost}/perpus-api/${this.imagePath}",
        width: 80,
        height: 80,
        fit: BoxFit.cover,
      ),
      header: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            splashColor: Colors.orange[100],
            color: Colors.deepOrangeAccent,
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).pushNamed(
                BookInputScreen.routeName,
                arguments: BookInputScreenArguments(
                    id: this.id, title: this.title, imagePath: this.imagePath),
              );
            },
          ),
          IconButton(
            color: Colors.redAccent,
            icon: Icon(Icons.delete),
            onPressed: () {},
          ),
        ],
      ),
      footer: GridTileBar(
        backgroundColor: Colors.black54,
        title: Text(this.title),
        trailing: IconButton(
          splashColor: Colors.red[400],
          icon: Icon(Icons.favorite),
          onPressed: () {},
        ),
      ),
    );
  }
}
