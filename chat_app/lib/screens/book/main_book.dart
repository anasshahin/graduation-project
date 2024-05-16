import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/provider_management.dart';
import '../../widgets/color_gradient.dart';
import '../users_screen.dart';
import 'advertisements.dart';
import 'create_book_advertisement.dart';
import 'main_book_screen_view.dart';
class MainBooksScreen extends StatefulWidget {
  const MainBooksScreen({super.key});
  @override
  State<MainBooksScreen> createState() => _MainBooksScreenState();
}
class _MainBooksScreenState extends State<MainBooksScreen> {
 List<Widget> mainScreens =[
   const MainBookScreenView(),
    const CreateBookAdvertisement(),
    Advertisements(favourite: false),
   Advertisements(favourite: true),
    const UsersScreen()

 ];
  int selectedIndex = 0;
  void viewer(int index){
    setState(() {
      selectedIndex=index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(

        //appBar: AppBar(title: ,bottom: ),
        body: mainScreens[Provider.of<AdvertisementProvider>(context, listen: true).selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.yellowAccent,
          selectedItemColor: Colors.green.shade900,
          unselectedItemColor: Colors.black26,
          currentIndex: Provider.of<AdvertisementProvider>(context, listen: false).selectedIndex,
          selectedFontSize: 17,
          unselectedFontSize: 10,
          type: BottomNavigationBarType.shifting,// by default it is BottomNavigationBarType.fixed . try it
          onTap: Provider.of<AdvertisementProvider>(context, listen: true).viewer,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.local_library,
                ),
                label: 'main'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.menu_book,
                ),
                label: 'create advertisement'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.library_books_outlined,
                ),
                label: 'your advertisement'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.favorite,
                ),
                label: 'favourite advertisement'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.chat,
                ),
                label: 'chat'),
          ],
        ),
      ),
    );
  }
}


