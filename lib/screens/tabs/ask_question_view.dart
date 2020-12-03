import 'package:advanced_skill_exam/controllers/chat_controller.dart';
import 'package:advanced_skill_exam/models/admin_model.dart';
import 'package:advanced_skill_exam/screens/chat/chat_tab.dart';
import 'package:advanced_skill_exam/screens/survey/screening_view.dart';
import 'package:advanced_skill_exam/widgets/button/confirm_orange_button.dart';
import 'package:advanced_skill_exam/widgets/inherited/inherited_widget.dart';
import 'package:advanced_skill_exam/widgets/painter/top_small_wave_painter.dart';
import 'package:advanced_skill_exam/widgets/theme/color_theme.dart';
import 'package:advanced_skill_exam/widgets/theme/h1_text.dart';
import 'package:advanced_skill_exam/widgets/transistion/route_transition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AskQuestionView extends StatefulWidget {
  AskQuestionView({Key key}) : super(key: key);

  @override
  _AskQuestionViewState createState() => _AskQuestionViewState();
}

class _AskQuestionViewState extends State<AskQuestionView> {
  final ChatController _chatController = ChatController();

  @override
  Widget build(BuildContext context) {
    final _userData = InheritedDataProvider.of(context);
    return SingleChildScrollView(
      child: Stack(
        children: [
          Hero(
            tag: 'background',
            child: CustomPaint(
              size: Size(MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height),
              painter: TopSmallWavePainter(
                color: ColorTheme.extraLightGreen,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 100),
                H1Text(text: "Komt in contact met experts"),
                //     SizedBox(height: 10),
                Text(

                    // ignore: lines_longer_than_80_chars
                    "Contact opnemen met een expert heeft verschillende voordelen. Als je onzeker bent over een gezondheidsrisico of als je nieuwschierig bent over hoe het advies van een expert je verder kan helpen, kan dat hier worden gedaan"),
                SizedBox(height: 40),
                SizedBox(height: 100),
                H1Text(text: "Een gepersonaliseerde health scan"),
                SizedBox(height: 10),
                Text(

                    // ignore: lines_longer_than_80_chars
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse finibus condimentum purus, eget pharetra sem ultricies sed. In hac habitasse platea dictumst. Aliquam erat volutpat. Aenean tristique tortor vitae mattis feugiat. Praesent in volutpat dolor. Phasellus finibus dictum viverra. Nunc hendrerit, est vitae accumsan bibendum, dolor tellus tempor felis, cursus fringilla odio nisi et arcu."),
                SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: ConfirmOrangeButton(
                    text: "Start scan",
                    onTap: () => {
                      Navigator.of(context).push(
                        createRoute(
                          ScreeningView(),
                        ),
                      ),
                    },
                  ),
                ),
                SizedBox(height: 75),
                H1Text(text: "Beschikbare experts"),
                FutureBuilder<List<AdminModel>>(
                  future: _chatController.getExperts(),
                  builder: (BuildContext context, snapshot) {
                    List<AdminModel> _adminList = snapshot.data;
                    if (!snapshot.hasData) {
                      return Center(child: Text("Geen data"));
                    } else {
                      return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _adminList.length,
                        itemBuilder: (BuildContext context, index) {
                          AdminModel _adminModel = _adminList[index];
                          return ExpertOptions(
                              adminModel: _adminModel,
                              email: _userData.data.email);
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ExpertOptions extends StatelessWidget {
  ExpertOptions({this.adminModel, this.email});

  final AdminModel adminModel;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: adminModel.medical
            ? const Color(0xFFEFFAF6)
            : const Color(0xFFFFF4E6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                // backgroundImage: NetworkImage(adminModel.image),
                child: Icon(Icons.person),
                backgroundColor: adminModel.medical
                    ? const Color(0xFFA1CFBE)
                    : const Color(0xFFFFDFB9),
              ),
              SizedBox(height: 15),
              Text(
                adminModel.name,
              ),
              Text(adminModel.profession),
            ],
          ),
          Spacer(),
          adminModel.medical
              ? ConfirmOrangeButton(
                  text: "Message",
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatTab(
                          model: adminModel,
                          email: email,
                        ),
                      ),
                    ),
                  },
                )
              : ConfirmOrangeButton(
                  text: "Message",
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatTab(
                          model: adminModel,
                          email: email,
                        ),
                      ),
                    ),
                  },
                ),
        ],
      ),
    );
  }
}
