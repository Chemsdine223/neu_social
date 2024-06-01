import 'package:neu_social/Constants/constants.dart';
import 'package:neu_social/Data/Models/community.dart';
import 'package:neu_social/Data/Models/event.dart';
import 'package:neu_social/Data/Models/user.dart';
import 'package:neu_social/Data/Models/post.dart';

// Define more dummy users
final List<UserModel> users = [
  UserModel(
    firstname: "Jimmy",
    lastname: 'Kimmel',
    email: 'jimmy.kimmel@example.com',
    dob: DateTime.parse("1995-06-12"),
  ),
  UserModel(
    firstname: "John",
    lastname: 'Lennon',
    email: 'john.lennon@example.com',
    dob: DateTime.parse("1997-03-11"),
  ),
  UserModel(
    firstname: "Jane",
    lastname: 'Doe',
    email: 'jane.doe@example.com',
    dob: DateTime.parse("1998-01-15"),
  ),
  UserModel(
    firstname: "Alice",
    lastname: 'Smith',
    email: 'alice.smith@example.com',
    dob: DateTime.parse("1992-07-24"),
  ),
  UserModel(
    firstname: "Bob",
    lastname: 'Johnson',
    email: 'bob.johnson@example.com',
    dob: DateTime.parse("1990-11-05"),
  ),
  UserModel(
    firstname: "Eve",
    lastname: 'Adams',
    email: 'eve.adams@example.com',
    dob: DateTime.parse("1985-04-20"),
  ),
  UserModel(
    firstname: "James",
    lastname: 'Stevenson',
    email: 'james.stevenson@example.com',
    dob: DateTime.parse("1995-06-12"),
  ),
  UserModel(
    firstname: "Amy",
    lastname: 'Brown',
    email: 'amy.brown@example.com',
    dob: DateTime.parse("1997-03-11"),
  ),
];

// Define dummy posts
final List<Post> posts = [
  Post(user: users[0], post: 'This is a post by Jimmy Kimmel.'),
  Post(user: users[1], post: 'John Lennon shares his thoughts.'),
  Post(user: users[2], post: 'Jane Doe writes about her day.'),
  Post(user: users[3], post: 'Alice Smith discusses her latest project.'),
  Post(user: users[4], post: 'Bob Johnson posts a funny meme.'),
  Post(user: users[5], post: 'Eve Adams shares a beautiful photo.'),
  Post(user: users[6], post: 'James Stevenson talks about his new startup.'),
  Post(user: users[7], post: 'Amy Brown shares a recipe for a healthy meal.'),
];

List<EventModel> dummyEvents = [
  EventModel(
    time: '00:22',
    name: 'Tech Expo 2024',
    date: DateTime(2024, 6, 15),
    description:
        'A grand expo showcasing the latest advancements in technology and innovation. Keynotes, workshops, and networking sessions with industry leaders.',
    creator: users[2],
    location: 'San Francisco Convention Center',
  ),
  EventModel(
    time: '12:25',
    name: 'Healthy Living Workshop',
    date: DateTime(2024, 7, 10),
    description:
        'A workshop focused on healthy living, featuring yoga sessions, diet plans, and talks from health experts.',
    creator: users[3],
    location: 'Community Wellness Center',
  ),
  EventModel(
    time: '20;30',
    name: 'Summer Music Festival',
    date: DateTime(2024, 8, 5),
    description:
        'Join us for a weekend of live music, food trucks, and entertainment. Featuring performances by top bands and artists.',
    creator: users[6],
    location: 'City Park Amphitheater',
  ),
  EventModel(
    time: '21:00',
    name: 'Gourmet Cooking Class',
    date: DateTime(2024, 6, 20),
    description:
        'Learn to cook gourmet meals with professional chefs. Hands-on sessions and tasting included.',
    creator: users[5],
    location: 'Culinary Arts School',
  ),
  EventModel(
    time: '22;00',
    name: 'Adventure Hiking Trip',
    date: DateTime(2024, 7, 25),
    description:
        'A guided hiking trip through scenic trails. Suitable for all skill levels. Bring your own gear and be prepared for an adventure.',
    creator: users[0],
    location: 'Mountain Ridge National Park',
  ),
  EventModel(
    time: '23:00',
    name: 'Investment Strategies Seminar',
    date: DateTime(2024, 9, 15),
    description:
        'An in-depth seminar on modern investment strategies and financial planning. Presented by top financial advisors.',
    creator: users[2],
    location: 'Downtown Business Center',
  ),
  EventModel(
    time: '08:45',
    name: 'Wellness Retreat',
    date: DateTime(2024, 10, 5),
    description:
        'A weekend retreat focusing on mental and physical wellness. Includes meditation, fitness classes, and spa treatments.',
    creator: users[3],
    location: 'Lakeside Resort',
  ),
  EventModel(
    time: '12:00',
    name: 'Jazz Night',
    date: DateTime(2024, 11, 10),
    description:
        'An evening of smooth jazz performances by local artists. Enjoy great music and fine dining.',
    creator: users[6],
    location: 'Jazz Lounge',
  ),
  EventModel(
    time: '15:00',
    name: 'International Food Festival',
    date: DateTime(2024, 9, 30),
    description:
        'A festival celebrating culinary traditions from around the world. Sample dishes from different cultures and enjoy cooking demonstrations.',
    creator: users[5],
    location: 'Central Plaza',
  ),
  EventModel(
    time: '18:00',
    name: 'Photography Expedition',
    date: DateTime(2024, 12, 12),
    description:
        'A photography expedition led by professional photographers. Explore picturesque locations and improve your photography skills.',
    creator: users[0],
    location: 'Scenic Valley',
  ),
];

// Define dummy communities
List<Community> dummyCommunities = [
  Community(
    events: [dummyEvents[0], dummyEvents[1]],
    creator: users[2],
    type: 'paid',
    id: 1,
    image: 'Img/investment.png',
    name: 'Tech Enthusiasts',
    interests: ['Technology', 'Science'],
    description:
        'A community for people passionate about the latest in tech, gadgets, and software development.',
    users: [users[0], users[1], users[2], users[3]],
    posts: [posts[0], posts[3], posts[6]],
  ),
  Community(
    events: [dummyEvents[2], dummyEvents[3]],
    creator: users[3],
    type: 'event-based',
    id: 2,
    image: 'Img/better-health.png',
    name: 'Health & Wellness',
    interests: ['Health', 'Lifestyle'],
    description:
        'A community focused on health, wellness, and fitness. Share tips, articles, and personal stories.',
    users: [users[4], users[5], users[6], users[7]],
    posts: [posts[1], posts[2], posts[7]],
  ),
  Community(
    events: [dummyEvents[6], dummyEvents[7]],
    creator: users[6],
    type: 'invitation-based',
    id: 3,
    image: 'Img/love-song.png',
    name: 'Music Lovers',
    interests: ['Music'],
    description:
        'Join fellow music enthusiasts to discuss your favorite bands, share playlists, and talk about the latest releases.',
    users: [users[0], users[1], users[5]],
    posts: [posts[1], posts[5]],
  ),
  Community(
    events: [dummyEvents[9], dummyEvents[4]],
    creator: users[5],
    id: 4,
    type: 'public',
    image: 'Img/catering.png',
    name: 'Foodies United',
    interests: ['Food', 'Cooking'],
    description:
        'A place for food lovers to share recipes, cooking tips, and restaurant reviews.',
    users: [users[2], users[3], users[7]],
    posts: [posts[3], posts[7]],
  ),
  Community(
    events: [dummyEvents[6], dummyEvents[9]],
    creator: users[0],
    type: 'private',
    id: 5,
    image: 'Img/business-trip.png',
    name: 'Travel Buffs',
    interests: ['Traveling', 'Adventure'],
    description:
        'Share your travel experiences, photos, and tips. Find travel buddies and plan your next adventure.',
    users: [users[4], users[5], users[6]],
    posts: [posts[4], posts[6]],
  ),
];
