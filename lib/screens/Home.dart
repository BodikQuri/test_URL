import 'package:flutter/material.dart';
import 'package:test_http_code/domain/Website.dart';
import 'package:test_http_code/screens/inputDialog.dart';
import 'package:http/http.dart' as http;
import 'package:favicon/favicon.dart' as ficon;

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();
  List<String> _domains = new List<String>();
  List<Website> _websites = new List<Website>();
  TextEditingController _controller = new TextEditingController();

  Future<int> _checkCode(checkurl) async {
    try {
      final url = checkurl;
      final client = http.Client();
      final request = new http.Request('GET', Uri.parse(url))
        ..followRedirects = false;
      final response = await client.send(request);
      return response.statusCode.toInt();
    } catch (e) {
      return -1;
    }
  }

  Future _checkIcon(checkurl) async {
    try {
      ficon.Icon icon = await ficon.Favicon.getBest(checkurl);
      return icon.url;
    } catch (e) {
      return null;
    }
  }

  void refreshAll() async {
    for (int i = 0; i < _websites.length; i++) {
      setState(() {
        _websites[i].inProgress = true;
      });
      int checkHTTPCode = await _checkCode(_websites[i].url);
      _websites[i].httpStatus = checkHTTPCode.toString();
      _websites[i].isAvailable = checkHTTPCode >= 200 && checkHTTPCode <= 400;
      _websites[i].lastUpdate = DateTime.now();
      //_websites[i].icon = await _checkIcon(_websites[i].url);
      setState(() {
        _websites[i].inProgress = false;
      });
    }
    setState(() {});
  }

  Widget refreshBg() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20.0),
      color: Theme.of(context).primaryColor,
      child: const Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }

  showSnackBarDeleted(context, deletedWebsite, index) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${deletedWebsite.url} deleted'),
      action: SnackBarAction(
        label: "UNDO",
        onPressed: () {
          _websites.insert(index, deletedWebsite);
          setState(() {
            _domains.insert(index, deletedWebsite.url);
          });
        },
      ),
    ));
  }

  showSnackBarAdded(context, addedWebsite, index) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${addedWebsite.url} added'),
      action: SnackBarAction(
        label: "UNDO",
        onPressed: () {
          _websites.removeAt(index);
          setState(() {
            _domains.removeAt(index);
          });
        },
      ),
    ));
  }

  showSnackBar(context, textTitle) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
      content: Text(textTitle),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Container(
          child: Text(
            'Web-sites availability check',
            style: Theme.of(context).textTheme.headline1,
            maxLines: 1,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                refreshAll();
              },
              icon: Icon(Icons.refresh))
        ],
      ),
      body: RefreshIndicator(
        key: refreshKey,
        onRefresh: () async {
          refreshAll();
        },
        child: ListView.builder(
            itemCount: _domains.length,
            itemBuilder: (context, index) => Dismissible(
                  key: Key(_domains[index]),
                  onDismissed: (direction) {
                    Website deletedWebsite = _websites[index];
                    _websites.removeAt(index);
                    setState(() {
                      _domains.removeAt(index);
                    });
                    showSnackBarDeleted(context, deletedWebsite, index);
                  },
                  background: refreshBg(),
                  child: Card(
                    child: ListTile(
                      enabled: _websites[index].available,
                      leading: _websites[index].favicon,
                      title: Container(
                        child: Text(_websites[index].url),
                      ),
                      subtitle: Container(
                        child: Text(_websites[index].httpStatus),
                      ),
                      trailing: Container(
                        child: Text(_websites[index].updatedAt),
                      ),
                    ),
                  ),
                )),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await inputDialog(context, _controller,
                    mainTitle: "Add new website",
                    lableText: "write URL",
                    textHint: "https://something.domain")
                .then((_) async {
              if (!_domains.contains(_controller.text)) {
                //check dublicate
                int checkHTTPCode = await _checkCode(_controller.text.trim());
                if (checkHTTPCode == -1) {
                  //check the completed connection
                  showSnackBar(context, 'Not conection, check URL');
                } else {
                  _domains.add(_controller.text);
                  Website newWebSite = new Website(
                      url: _controller.text,
                      httpStatus: checkHTTPCode.toString(),
                      isAvailable: checkHTTPCode >= 200 && checkHTTPCode <= 400,
                      icon: Image.network(
                        await _checkIcon(_controller.text),
                        height: 24,
                        width: 24,
                      ));
                  setState(() {
                    _websites.add(newWebSite);
                  });
                  showSnackBarAdded(context, newWebSite, _domains.length - 1);
                }
              } else {
                showSnackBar(context, '${_controller.text} contain');
              }
            });
            _controller.clear();
          },
          child: Icon(Icons.add)),
    );
  }
}
