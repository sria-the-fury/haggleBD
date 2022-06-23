import 'package:flutter/material.dart';
import 'package:haggle/modals/AddItemModal.dart';
import 'package:haggle/routes/AuctionAds.dart';
import 'package:haggle/routes/MyGranary.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedPage = 0;

  final _pageOptions = [
     const AuctionAds(),
    const MyGranary()
  ];



  void _onItemTapped(int index) {
    setState(() {
      selectedPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Center(
        child: _pageOptions[selectedPage],
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          //Add your onPressed code here!
          Navigator.of(context).push( MaterialPageRoute<void>(
              builder: (BuildContext context) {
                return const AddItemModal();
              },
              fullscreenDialog: true
          ));
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Colors.blue,
        child: IconTheme(
          data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[

              selectedPage == 0 ?
              GestureDetector(
                child: Container(
                    margin: const EdgeInsets.only(left: 15.0),
                    height: 36.0,
                    padding: const EdgeInsets.only(right: 5.0, left: 5.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 1.0),
                        borderRadius: BorderRadius.circular(20.0)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        Icon(Icons.gavel, size: 25.0,
                          color: selectedPage == 0 ? Colors.white : Colors.white70,),
                        const SizedBox(width: 5.0,),
                        const Text('Auction',  style: TextStyle(color: Colors.white, fontSize: 16.0))
                      ],
                    )
                ),
                onTap: (){_onItemTapped(0);},
              ) : IconButton(onPressed: (){ _onItemTapped(0);},
                  icon: const Icon(Icons.gavel, size: 25.0,
                    color: Colors.white70,)),

              selectedPage == 1 ?
              GestureDetector(
                child: Container(
                    margin: const EdgeInsets.only(right: 15.0),
                    height: 36.0,
                    padding: const EdgeInsets.only(right: 5.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 1.0),
                        borderRadius: BorderRadius.circular(20.0)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        Icon(Icons.store, size: 25.0,
                          color: selectedPage == 1 ? Colors.white : Colors.white70,),
                        const SizedBox(width: 5.0,),
                        const Text('Granary',  style: TextStyle(color: Colors.white, fontSize: 16.0))
                      ],
                    )
                ),
                onTap: (){_onItemTapped(1);},
              ) : IconButton(onPressed: (){ _onItemTapped(1);},
                  icon: const Icon(Icons.store, size: 25.0,
                    color: Colors.white70,)),
            ],
          ),
        ),
      ),
    );
  }
}
