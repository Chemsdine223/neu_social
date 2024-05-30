import 'package:neu_social/Data/Models/community.dart';
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

// Define dummy communities
List<Community> dummyCommunities = [
  Community(
    creator: users[2],
    type: 'paid',
    id: 1,
    image: 'Img/investment.png',
    name: 'Tech Enthusiasts',
    interests: ['Technology', 'Networking'],
    description:
        'A community for people passionate about the latest in tech, gadgets, and software development.',
    users: [users[0], users[1], users[2], users[3]],
    posts: [posts[0], posts[3], posts[6]],
  ),
  Community(
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
    creator: users[6],
    type: 'invitation-based',
    id: 3,
    image: 'Img/love-song.png',
    name: 'Music Lovers',
    interests: ['Music', 'Entertainment'],
    description:
        'Join fellow music enthusiasts to discuss your favorite bands, share playlists, and talk about the latest releases.',
    users: [users[0], users[1], users[5]],
    posts: [posts[1], posts[5]],
  ),
  Community(
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
    creator: users[0],
    type: 'private',
    id: 5,
    image: 'Img/business-trip.png',
    name: 'Travel Buffs',
    interests: ['Travel', 'Adventure'],
    description:
        'Share your travel experiences, photos, and tips. Find travel buddies and plan your next adventure.',
    users: [users[4], users[5], users[6]],
    posts: [posts[4], posts[6]],
  ),
];
