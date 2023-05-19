import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xfff4f4f4),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            surfaceTintColor: Color(0xfff4f4f4),
              backgroundColor: Color(0xfff4f4f4),
              elevation: 0,
              centerTitle: true,
              // floating: true,
              // snap: true,
              leading: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.menu, color: Colors.black)),
              expandedHeight: 300,
              stretch: true,
              bottom: AppBar(
                surfaceTintColor: Color(0xfff4f4f4),
                elevation: 0,
                backgroundColor: Color(0xfff4f4f4),
              ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Color(0xfff4f4f4),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: deviceHeight * 0.6,
                    color: Colors.tealAccent,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Color(0xfff4f4f4),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: deviceHeight * 0.6,
                    color: Colors.tealAccent,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
