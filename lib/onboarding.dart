import 'package:flutter/material.dart';
import 'package:tradlinc/screens/login_screen.dart';
import 'package:tradlinc/screens/signup_email.dart';
import 'package:tradlinc/utils/colors.dart';

class Start extends StatefulWidget {
  const Start({super.key});

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  int currentPage = 0;
  List<Map<String, String>> pageData = [
    {
      "title": "Cree tes tradlinc et partage tes produits",
      "text": "Welcome into \n my app",
      "image": "assets/3.png",
    },
    {
      "title": "Developpe ton business",
      "text": "Welcome into \n my app",
      "image": "assets/3.png",
    },
    {
      "title": "Gagne la confiance de tes clients",
      "text": "Welcome into \n my app",
      "image": "assets/3.png",
    },
    {
      "title": "Gagne beaucoup de temps",
      "text": "Welcome into \n my app",
      "image": "assets/3.png",
    },

  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor:blueColor,
      body: SafeArea(
        child: SizedBox(
         //   width: MediaQuery.of(context).size.width / 1,
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: PageView.builder(
                      onPageChanged: ((value) {
                        setState(() {
                          currentPage = value;
                        });
                      }),
                      itemCount: pageData.length,
                      itemBuilder: ((context, index) => Pages(
                            title: pageData[index]['title'],
                            text: pageData[index]['text'],
                            image: pageData[index]["image"],
                          ))),
                ),
                Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          const Spacer(
                            flex: 2,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(pageData.length,
                                (index) => animation(index = index)),
                          ),
                          const Spacer(
                              //  flex: 2,
                              ),
                          InkWell(
                            onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>  const Signup_email(),
                        ),
                      ),
                            child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              child: const Center(
                                child: Text(
                                  "Commencer",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: blueColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 22,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: const Text(
                                  'Compte existant ?',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(width: 7),
                              GestureDetector(
                                onTap:() => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>  const LoginScreen(),
                        ),
                      ),
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  child: const Text(
                                    'Se connecter',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                        ],
                      ),
                    ))
              ],
            )),
      ),
    );
  }

  AnimatedContainer animation(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 10),
      margin: const EdgeInsets.only(right: 5),
      height: 7,
      width: 7,
      decoration: BoxDecoration(
          color: currentPage == index ? Colors.white : Colors.grey[500],
          borderRadius: BorderRadius.circular(3)),
    );
  }
}

class Pages extends StatelessWidget {
  const Pages({
    Key? key,
    required this.title,
    required this.text,
    required this.image,
  }) : super(key: key);
  final String? title, text, image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Spacer(),
        Image.asset(
          image!,
          height: 150,
          width: 150,
        ),
        const SizedBox(
          height: 35,
        ),
        Text(
          title!,
          style: const TextStyle(
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(text!,
            style: const TextStyle(fontSize: 15, color: Colors.white),
            textAlign: TextAlign.center),
      ],
    );
  }
}
