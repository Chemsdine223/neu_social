import 'package:neu_social/Logic/AuthCubit/auth_cubit.dart';
import 'package:neu_social/Logic/ChatCubit/websocket_cubit.dart';

// const String socketUrl = 'http://192.168.100.30:3000';
// const String baseUrl = 'http://192.168.100.30:3000/api';
const String baseUrl = 'http://172.20.10.5:3000/api';
const String socketUrl = 'http://172.20.10.5:3000';
// const String baseUrl = 'http://192.168.0.107:3000/api';
// const String socketUrl = 'http://192.168.0.107:3000';
// const String baseUrl = 'http://192.168.1.212:3000/api';
// const String socketUrl = 'http://192.168.1.212:3000';
// 192.168.1.212
final webSocketCubit = WebSocketCubit();
final authCubit = AuthCubit();

// ? Api endpoints ? //
const String loginUser = '$baseUrl/login';
const String getUser = '$baseUrl/user';
const String registerUser = '$baseUrl/register';
const String userConversations = '$baseUrl/conversations';

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



// {
//     "content":"",
//     "senderId":"666ae301ed5c24e4261c1c0a",
//     "receiverId":"666ae3aeed5c24e4261c1c0e",
//     "roomId":"6672e5da11cfb899cbda80d8"
// }