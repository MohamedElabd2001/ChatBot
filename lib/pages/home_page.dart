import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemini_api/bloc/chat_bloc.dart';
import 'package:gemini_api/models/chat_message_model.dart';
import 'package:lottie/lottie.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:avatar_glow/avatar_glow.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ChatBloc chatBloc = ChatBloc();
  TextEditingController textEditingController = TextEditingController();
  stt.SpeechToText _speech = stt.SpeechToText();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ChatBloc, ChatState>(
        bloc: chatBloc,
        listener: (context, state) {},
        builder: (context, state) {
          switch (state.runtimeType) {
            case ChatSuccessState:
              List<ChatMessageModel> messages =
                  (state as ChatSuccessState).messages;
              return Container(
                width: double.maxFinite,
                height: double.maxFinite,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    opacity: 0.3,
                    image: AssetImage("assets/images/background.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: 100,
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            "Abood",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          IconButton(
                            onPressed: (){},
                           icon: const Icon(Icons.image_search),
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8,),
                    Expanded(
                      child: ListView.builder(
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(
                                bottom: 12,
                                left: 16,
                                right: 16,
                              ),
                              padding: const EdgeInsets.all(
                                16,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  16,
                                ),
                                // color: Colors.amber.withOpacity(0.1),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    messages[index].role == 'user'
                                        ? 'User'
                                        : 'AI',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: messages[index].role == "user"
                                            ? Colors.amber
                                            : Colors.purple.shade200),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Text(
                                    messages[index].parts.first.text,
                                    style: const TextStyle(
                                      height: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
                    if (chatBloc.generating)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              height: 100,
                              width: 100,
                              child:
                                  Lottie.asset("assets/lottie/loading.json")),
                          const SizedBox(
                            width: 20,
                          ),
                          const Text("Loading..."),
                        ],
                      ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 30,
                        horizontal: 16,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: textEditingController,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              cursorColor: Theme.of(context).primaryColor,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    100,
                                  ),
                                ),
                                fillColor: Colors.white,
                                hintText: "Ask me anything...",
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade400),
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    100,
                                  ),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.mic),
                            onPressed: () {
                              _startListening();
                            },
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          InkWell(
                            onTap: () {
                              if (textEditingController.text.isNotEmpty) {
                                String text = textEditingController.text;
                                textEditingController.clear();
                                chatBloc.add(
                                  ChatGenerateNewTextMessageEvent(
                                      inputMessage: text),
                                );
                              }
                            },
                            child: CircleAvatar(
                              radius: 33,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: Theme.of(context).primaryColor,
                                child: const Center(
                                  child: Icon(
                                    Icons.send,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              );

            default:
              return const SizedBox();
          }
        },
      ),
    );
  }
  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) {
        print('Speech recognition status: $status');
      },
      onError: (error) {
        print('Speech recognition error: $error');
      },
    );

    if (available) {
      _speech.listen(
        onResult: (result) {
          if (result.finalResult) {
            // Update the text field with the recognized speech
            setState(() {
              textEditingController.text = result.recognizedWords;
            });
          }
        },
      );
    } else {
      print("Speech recognition not available");
    }
  }
}
