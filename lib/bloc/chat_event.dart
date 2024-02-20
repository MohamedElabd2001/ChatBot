part of 'chat_bloc.dart';

@immutable
abstract class ChatEvent {}

class ChatGenerateNewTextMessageEvent extends ChatEvent{
  final String inputMessage;

  ChatGenerateNewTextMessageEvent({required this.inputMessage});
}