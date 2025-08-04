import 'package:disaster_relief_coordination/src/helpers/SvgHelpers.dart';
import 'package:disaster_relief_coordination/src/widgets/CustomButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../bloc/PersonBloc.dart';
import '../helpers/ColorHelpers.dart';
import '../widgets/CustomText.dart';

class MyStatusView extends StatefulWidget {
  const MyStatusView({super.key});


  @override
  StateView createState() => StateView();

}

  class StateView extends State<MyStatusView> {

  @override
  void initState(){
    super.initState();

    context.read<PersonBloc>().add(const LoadPersons());
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const CustomText(
          text: 'My Status',
          fontFamily: 'GoogleSansCode',
          fontSize: 30,
          color: Colors.black ,
          fontWeight: FontWeight.w700,
          textAlign: TextAlign.center,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: ColorHelpers.safeColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              width: screenWidth,
              height: screenHeight * 0.3,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: screenWidth * 0.8,
                      height: screenHeight * 0.2,
                      child: Center(
                        child: SvgPicture.asset(
                          SvgHelpers.safe, // Replace with your SVG asset path
                          width: screenWidth * 0.1,
                          height: screenHeight * 0.1,
                          colorFilter: ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                    const CustomText(
                      text: 'I am safe',
                      fontFamily: 'GoogleSansCode',
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    const CustomText(
                      text: 'Last updated: 2023-10-01',
                      fontFamily: 'GoogleSansCode',
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: screenWidth,
              height: screenHeight * 0.7,
              color: Colors.white,
              child: Center(
                child: Column(
                  children: [
                    Expanded(
                      child: BlocBuilder<PersonBloc, PersonState>(
                        builder: (context, state) {
                          return ListView.builder(
                            itemCount: state.people.length,
                            itemBuilder: (context, index) {
                              final person = state.people[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                child: ListTile(
                                  title: Text(person.name),
                                  subtitle: Text('Status: ${person.status}'),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    CustomButton(hintText: 'Update Status', fontFamily: 'GoogleSansCode', fontSize: 20, fontWeight: FontWeight.w700, onPressed: (){

                    }, width: screenWidth * 0.8, height: screenHeight * 0.07,),
                    SizedBox(height: screenHeight * 0.09,)
                  ],
                ),
              )
            ),
          ),
        ],
      ),
    );
  }
}