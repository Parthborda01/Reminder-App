import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:student_dudes/Util/Cubits/AnimationHelper/animationHelperCubit.dart';

import '../../Widgets/HomePage/DrawerWidget.dart';

class ConstructorPage extends StatefulWidget {
  const ConstructorPage({Key? key}) : super(key: key);

  @override
  State<ConstructorPage> createState() => _ConstructorPageState();
}

class _ConstructorPageState extends State<ConstructorPage> {

  @override
  Widget build(BuildContext context) {

    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    ScrollController _sliverScrollController = ScrollController();
    _sliverScrollController.addListener(() {
      if (_sliverScrollController.offset >= 100 &&
          !_sliverScrollController.position.outOfRange) {
        BlocProvider.of<SliverScrolled>(context).Add();
      } else {
        BlocProvider.of<SliverScrolled>(context).clear();
      }
    });

    return Scaffold(
        body: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  spreadRadius: 1,
                  color: Theme.of(context).scaffoldBackgroundColor)
            ]),
            child: CustomScrollView(
                controller: _sliverScrollController,
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    backgroundColor:
                        Theme.of(context).scaffoldBackgroundColor,
                    surfaceTintColor:
                        Theme.of(context).scaffoldBackgroundColor,
                    elevation: 0,
                    expandedHeight: 300,
                    leading: IconButton(
                        onPressed: () {

                        },
                        highlightColor: Colors.transparent,
                        icon: Icon(
                          Icons.menu,
                          color: Theme.of(context).iconTheme.color,
                        )),
                    bottom: PreferredSize(
                      preferredSize: Size(deviceWidth, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          BlocBuilder<SliverScrolled, bool>(
                              builder: (context, state) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: AnimatedOpacity(
                                        opacity: state ? 1.0 : 0.0,
                                        duration:
                                            Duration(milliseconds: 200),
                                        child: Text("Tasks",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall)),
                                  )),
                          Spacer(),
                          IconButton(
                              onPressed: () {}, icon: Icon(Icons.add)),
                        ],
                      ),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background:
                          Center(child: BlocBuilder<SliverScrolled, bool>(
                        builder: (context, state) {
                          return AnimatedOpacity(
                            opacity: state ? 0.0 : 1.0,
                            duration: Duration(milliseconds: 100),
                            child: Text(
                              "Reminder",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          );
                        },
                      )),
                    ),
                  ),
                ]
            )
        )
    );
  }
}
