import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WheatIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xfff47039),
        ),
        child: Stack(children: [
          Positioned(
              bottom: 9.5,
              right: 7,
              child: FaIcon(FontAwesomeIcons.breadSlice, color: Theme.of(context).primaryColor,size:18))]),

      ),
    );
  }
}

class EggIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xfff68d2f),
        ),
        child: Stack(children: [
          Positioned(
              bottom: 9,
              right: 11,
              child: FaIcon(FontAwesomeIcons.egg, color: Theme.of(context).primaryColor,size:18))]),

      ),
    );
  }
}

class NutsIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xff9a8e6c),
        ),
        child: Stack(children: [
          Positioned(
              bottom: 7.5,
              right: 8.5,
              child: FaIcon(FontAwesomeIcons.nutritionix ,color: Theme.of(context).primaryColor,size:22))]),

      ),
    );
  }
}

class MilkIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blueGrey,
        ),
        child: Stack(children: [
          Positioned(
              bottom: 6.5,
              right: 7,
              child: FaIcon(FontAwesomeIcons.wineBottle ,color: Theme.of(context).primaryColor,size:22))]),

      ),
    );
  }
}
