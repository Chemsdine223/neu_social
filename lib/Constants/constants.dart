import 'package:neu_social/Logic/ChatCubit/websocket_cubit.dart';

const String socketUrl = 'http://192.168.100.30:3000';
const String baseUrl = 'http://192.168.100.30:3000/api';
// const String baseUrl = 'http://172.20.10.5:3000/api';
// const String socketUrl = 'http://172.20.10.5:3000';
final webSocketCubit = WebSocketCubit();

// ? Api endpoints
const String loginUser = '$baseUrl/login';
const String getUser = '$baseUrl/user';
const String registerUser = '$baseUrl/register';

List<String> defaultInterests = [
  'Reading',
  'Traveling',
  'Cooking',
  'Sports',
  'Music',
  'Movies',
  'Photography',
  'Technology',
  'Gaming',
  'Fitness',
  'Health',
  'Art',
  'Lifestyle',
  'Food',
  'Adventure',
  'Gardening',
  'Writing',
  'Fashion',
  'Science',
  'History',
  'Crafting',
  'Hiking',
  'Dancing',
  'Yoga'
];

List<String> months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];

List<String> types = [
  "Private",
  "Event-based",
  "Invitation-based",
  "Paid",
  "Public",
];
