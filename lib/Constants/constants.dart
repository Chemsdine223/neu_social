const String socketUrl = 'http://192.168.100.30:3000';
const String baseUrl = 'http://192.168.100.30:3000/api';
// const String baseUrl = 'http://172.20.10.5:3000/api';
// const String socketUrl = 'http://172.20.10.5:3000';
// const String baseUrl = 'http://192.168.0.115:3000/api';
// const String socketUrl = 'http://192.168.0.115:3000';
// const String baseUrl = 'http://192.168.1.212:3000/api';
// const String socketUrl = 'http://192.168.1.212:3000';
// 192.168.1.212
// ! provide the room id from the sender for a new conversation
// ! if the user does not exist remove that conversation from the conversation list

// ? Api endpoints ? //

const String loginUser = '$baseUrl/login';
const String getUser = '$baseUrl/user';
const String registerUser = '$baseUrl/register';
const String userConversations = '$baseUrl/conversations';
const String searchUsersUrl = '$baseUrl/search';

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

// conversation creation
// Have a friends list.


// {
//     "content":"",
//     "senderId":"666ae301ed5c24e4261c1c0a",
//     "receiverId":"666ae3aeed5c24e4261c1c0e",
//     "roomId":"6672e5da11cfb899cbda80d8"
// }

// A very simple example will be to show the checkmark or cross according
// to the user input along with the validation message. For this, we are 
// using FormField class from Flutter. If you look at the source code of the default form field 
// widgets available in the Flutter like TextFormField, DropdownButtonFormField,
// all of them extend this class. So, to create our custom form field we will be using this class as well.
// In this example, I will show you a simple example to create a custom TextFormField.