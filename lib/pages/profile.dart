import 'package:amarboi/pages/signin.dart';
import 'package:amarboi/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  static const routName = '/profile';
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _UserScreenState();
}

class _UserScreenState extends State<Profile> {
  double top = 0;
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height * 0.3,
              flexibleSpace: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    'https://wallpaperaccess.com/full/3133075.jpg',
                  ),
                )),
                child: Stack(children: [
                  Positioned(
                      right: 10,
                      child: IconButton(
                        onPressed: () {
                          final provider =
                              Provider.of<GoogleAuth>(context, listen: false);
                          provider.logout();
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          MaterialIcons.logout,
                          color: Colors.white,
                          size: 30,
                        ),
                      )),
                  Container(
                    padding: const EdgeInsets.only(top: 30),
                    child: Align(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(user!.photoURL!),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Text(
                            user!.displayName!,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ]),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ListView(
                  primary: false,
                  shrinkWrap: true,
                  children: [
                    // const _userTileText(
                    //   text: 'User Bag',
                    // ),
                    // const _userTileHeightSpace(
                    //   height: 10.0,
                    // ),
                    //User
                    _userListTile(
                      onTap: () {},
                      lIcon: Icons.favorite,
                      color: Colors.green,
                      title: 'আমার প্রিয় বইগুলি ',
                      tIcon: Icons.arrow_forward_ios,
                    ),
                    // _userListTile(
                    //   lIcon: Icons.shopping_cart,
                    //   color: Colors.deepPurpleAccent,
                    //   title: 'Cart',
                    //   tIcon: Icons.arrow_forward_ios,
                    // ),
                    const _userTileHeightSpace(height: 15),
                    const _userTileText(text: 'Additional Info.'),
                    const _userTileHeightSpace(height: 10),
                    //User Settings
                    Card(
                      child: SwitchListTile.adaptive(
                          secondary: Icon(
                            Icons.light_mode,
                            color: Colors.amber.shade700,
                          ),
                          title: const Text('Light Mode'),
                          value: false,
                          onChanged: (value) {}),
                    ),

                    // _userTileHeightSpace(height: 15),
                    // _userTileText(text: 'User Info.'),
                    // _userTileHeightSpace(height: 10),
                    //User Info
                    _userListTile(
                        lIcon: Icons.email,
                        color: Colors.yellow.shade800,
                        title: 'Email',
                        tIcon: Icons.arrow_forward_ios,
                        subtitile: user!.email,
                        onTap: () {}),
                    // _userListTile(
                    //     lIcon: Icons.call,
                    //     color: Colors.green,
                    //     title: 'Phone Number',
                    //     tIcon: Icons.arrow_forward_ios,
                    //     subtitile: user!.phoneNumber,
                    //     onTap: () {}),

                    // _userListTile(
                    //     lIcon: Icons.local_shipping,
                    //     color: Colors.indigo,
                    //     title: 'Adress',
                    //     tIcon: Icons.arrow_forward_ios,
                    //     subtitile: 'Lalmonirhat Sadar, Lalmonirhat',
                    //     onTap: () {}),

                    // _userListTile(
                    //     lIcon: Icons.watch_later,
                    //     color: Colors.redAccent,
                    //     title: user!.,
                    //     tIcon: Icons.arrow_forward_ios,
                    //     subtitile: '17/02/2022',
                    //     onTap: () {}),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFab() {
    double defaultMargin = 250.0;
    double scrollStart = 230;
    double scrollEnd = scrollStart / 2;

    double top = defaultMargin;
    double scale = 1.0;

    if (_scrollController.hasClients) {
      double offset = _scrollController.offset;
      top -= offset;

      if (offset < defaultMargin - scrollStart) {
        scale = 1;
      } else if (offset < defaultMargin - scrollEnd) {
        scale = (defaultMargin - scrollEnd - offset) / scrollEnd;
      } else {
        scale = 0;
      }
    }

    return Positioned(
      top: top,
      right: 20,
      child: Transform(
        transform: Matrix4.identity()..scale(scale),
        child: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.camera),
        ),
      ),
    );
  }
}

class _userListTile extends StatelessWidget {
  final IconData lIcon;
  final Color color;
  final String title;
  final IconData? tIcon;
  final String? subtitile;
  final VoidCallback? tIconCallBack;
  final VoidCallback? onTap;

  _userListTile({
    this.tIcon,
    this.subtitile,
    this.tIconCallBack,
    this.onTap,
    Key? key,
    required this.lIcon,
    required this.color,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        subtitle: subtitile == null ? null : Text(subtitile!),
        onTap: onTap,
        leading: Icon(
          lIcon,
          color: color,
        ),
        title: Text(title),
        trailing: Icon(tIcon),
      ),
    );
  }
}

class _userTileHeightSpace extends StatelessWidget {
  final double height;
  const _userTileHeightSpace({
    Key? key,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}

class _userTileText extends StatelessWidget {
  final String text;
  const _userTileText({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      ' $text',
      style: const TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
