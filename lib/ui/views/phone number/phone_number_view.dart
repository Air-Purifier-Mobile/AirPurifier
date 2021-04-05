import 'package:air_purifier/ui/views/phone%20number/phone_number_viewModel.dart';
import 'package:air_purifier/ui/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:stacked/stacked.dart';

class PhoneNumberView extends StatelessWidget {
  const PhoneNumberView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ViewModelBuilder<PhoneNumberViewModel>.reactive(
      viewModelBuilder: () => PhoneNumberViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Color.fromRGBO(39, 35, 67, 1),
          body: KeyboardDismisser(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              height: height,
              width: width,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: height / 6,
                    ),
                    Container(
                      padding:
                          EdgeInsets.fromLTRB(0, height / 5, 0, height / 10),
                      height: height / 8,
                      width: width / 7,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/phone.png",
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height / 20,
                    ),
                    Text(
                      "Please enter your phone number",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: height / 32,
                        fontFamily: 'Noah',
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: height / 8,
                    ),
                    InputField(
                      placeholder: 'your number',
                      textAlign: TextAlign.left,
                      // prefixText: "+91  ",
                      prefix: Container(
                        child: Text("+91 "),
                      ),
                      textInputType: TextInputType.number,
                      controller: model.phoneNoController,
                    ),
                    SizedBox(
                      height: height / 6,
                    ),
                    Container(
                      height: height / 10,
                      width: height / 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(height / 12),
                        color: Colors.white,
                      ),
                      child: IconButton(
                          icon: Icon(
                            Icons.arrow_forward_rounded,
                            color: Color.fromRGBO(39, 35, 67, 1),
                            size: height / 23,
                          ),
                          onPressed: () {
                            model.goToOtpScreen();
                          }),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
