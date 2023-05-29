import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_dudes/UI/Widgets/SettingPage/SettingBox.dart';
import 'package:student_dudes/UI/Widgets/SettingPage/SettingType.dart';

import '../../../Util/Cubits/AnimationHelper/animationHelperCubit.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    ScrollController _sliverScrollController =
        ScrollController(initialScrollOffset: 240);
    BlocProvider.of<SliverScrolled>(context).Add();
    _sliverScrollController.addListener(() {
      if (_sliverScrollController.offset >= 100 &&
          !_sliverScrollController.position.outOfRange) {
        BlocProvider.of<SliverScrolled>(context).Add();
      } else {
        BlocProvider.of<SliverScrolled>(context).clear();
      }
    });

    return Scaffold(
      body: CustomScrollView(
        controller: _sliverScrollController,
        slivers: [
          SliverAppBar(
            leading: Container(),
            pinned: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            expandedHeight: 300,
            bottom: PreferredSize(
              preferredSize: Size(deviceWidth, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back_ios_rounded)),
                  BlocBuilder<SliverScrolled, bool>(
                      builder: (context, state) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: AnimatedOpacity(
                                opacity: state ? 1.0 : 0.0,
                                duration: Duration(milliseconds: 100),
                                child: Text("App Setting",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall)),
                          )),
                ],
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Center(child: BlocBuilder<SliverScrolled, bool>(
                builder: (context, state) {
                  return AnimatedOpacity(
                    opacity: state ? 0.0 : 1.0,
                    duration: Duration(milliseconds: 100),
                    child: Text(
                      "App Setting",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  );
                },
              )),
            ),
          ),
          const SettingBox(
            title: "Setting",
            children: [
              SettingTile(title: "test"),
              Divider(indent: 20, endIndent: 20),
              SettingTile(title: "test 2")
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                    child: Text("Information",
                        style: Theme.of(context).textTheme.labelSmall),
                  ),
                  Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Container(
                        height: deviceHeight * 0.6,
                        color: Theme.of(context).backgroundColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                    child: Text("Information",
                        style: Theme.of(context).textTheme.labelSmall),
                  ),
                  Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Container(
                        height: deviceHeight * 0.6,
                        color: Theme.of(context).backgroundColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                    child: Text("Information",
                        style: Theme.of(context).textTheme.labelSmall),
                  ),
                  Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Container(
                        height: deviceHeight * 0.6,
                        color: Theme.of(context).backgroundColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
