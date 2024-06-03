
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:social_media/main.dart';
import 'package:social_media/services/post_service.dart';
import 'package:social_media/services/storage_services.dart';

class PostWidget extends StatefulWidget {
  final String? description;
  final String? image;
  final String? user;
  final String? postid;
  final int? likes;
  PostWidget({super.key, this.description, this.image, this.user, this.postid,  this.likes});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  final _store = locator<StorageServices>();
  final _postService = locator<PostService>();
  bool _isLiked = false;
  int likeCounts = 0;

  final userId = FirebaseAuth.instance.currentUser!.uid;

  getLike() async {
    final likebool = await _postService.isliked(userId: userId, postId: widget.postid);
    _isLiked = likebool ? true : false;
    print(likebool);
  }

  getLikeCounts() async {
    setState(() {
      likeCounts = widget.likes!;
    });
  }

  @override
  initState() {
    super.initState();
    getLike();
    getLikeCounts();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _postService.getUserDetails(widget.user),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            height: 50,
                            width: 50,
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.grey,
                              backgroundImage:
                                  snapshot.data?['profileImage'] != null
                                      ? Image.network(
                                              snapshot.data?['profileImage']!)
                                          .image
                                      : null,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 15,
                              width: 15,
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                      color: Colors.white, width: 2)),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(snapshot.data?['name']!,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 5),
                          const Text('52 minute ago',
                              style: TextStyle(
                                  fontSize: 12, color: Color(0xff919191)))
                        ],
                      ),
                      const Spacer(),
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          side: MaterialStateProperty.all(
                              const BorderSide(color: Color(0xffEEEEEE))),
                        ),
                        onPressed: () {},
                        child: const Text("Following",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600)),
                      )
                    ],
                  ),
                  const SizedBox(height: 25),
                  Container(
                    height: 281,
                    width: 345,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: widget.image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(widget.image!, fit: BoxFit.fill))
                        : const Center(child: Text('No Image')),
                  ),
                  const SizedBox(height: 22),
                  Text(widget.description!,
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xff919191))),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      IconButton(
                        onPressed: (){},
                        icon: const Icon(
                          Icons.share_outlined,
                          color: Color(0xff0F393A)
                        ),
                      ),
                      const Text('36'),
                      const Spacer(),
                      IconButton(
                        onPressed: (){
                          print(widget.postid);
                          if(_isLiked){
                            _postService.unlikePost(userId: userId, postId: widget.postid);
                          } else {
                            _postService.likePost(userId: userId, postId: widget.postid);
                          }
                          // _store.getLikes(widget.postid);
                          setState(() {
                            print(_isLiked);
                            if(!_isLiked){
                              _isLiked = true;
                              likeCounts++;
                            } else {
                              _isLiked = false;
                              likeCounts--;
                            }
                          });
                        },
                        icon: _isLiked
                            ? const Icon(Icons.favorite, color: Colors.red)
                            : const Icon(Icons.favorite_border, color: Color(0xff0F393A)),
                      ),
                      // Text(likes as String),
                      GestureDetector(
                        onTap: () {
                          // _postService.getLikedUsers(widget.postid);
                          showModalBottomSheet(context: context, builder: (context) {
                            print('tedttsidc');
                            // final likeding = _store.getLikes(widget.postid);
                            return Container(
                              width: double.infinity,
                              // height: 200,
                              color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    const Text('Likes',style: TextStyle(fontSize: 20),),
                                    const SizedBox(height: 10),
                                    FutureBuilder(
                                      future: _postService.getLikedUsers(widget.postid),
                                      builder: (context,AsyncSnapshot<List> snapshot) {
                                        print(snapshot.data); 
                                        if (snapshot.hasData) {
                                          // return SizedBox();
                                          return ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: snapshot.data?.length,
                                            itemBuilder: (context, index) {
                                              return ListTile(
                                                leading: CircleAvatar(
                                                  radius: 20,
                                                  backgroundImage: snapshot.data![index]['profileImage'] != null
                                                      ? Image.network(snapshot.data![index]['profileImage']).image
                                                      : null,
                                                ),
                                                title: Text(snapshot.data![index]['name'])
                                              );
                                            },
                                          );
                                        } else {
                                          return const Center(child: CircularProgressIndicator());
                                        }
                                      },
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                        },
                        child: Text(likeCounts.toString())
                      ),
                      const SizedBox(width: 15),
                      IconButton(
                        onPressed: (){},
                        icon: SvgPicture.asset(
                          'assets/icons/CommentIcon.svg',
                          height: 19,
                        ),
                      ),
                      const Text('12'),
                    ],
                  ),
                ],
              ),
            );
          } else {
            return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          enabled: true,
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  children: [
                    Stack(
                      children: [
                        const SizedBox(
                          height: 50,
                          width: 50,
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.grey,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: 15,
                            width: 15,
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                    color: Colors.white, width: 2)),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 15,
                          width: 100,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 5),
                        Container(
                          height: 10,
                          width: 100,
                          color: Colors.grey,
                        )
                      ],
                    ),
                    // const Spacer(),
                    // Container(
                    //   height: 30,
                    //   width: 100,
                    //   color: Colors.grey,
                    // )
                  ],
                ),
                const SizedBox(height: 25),
                Container(
                  height: 281,
                  width: 345,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 22),
                Container(
                  height: 10,
                  width: 345,
                  color: Colors.grey,
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    const Icon(Icons.share_outlined, color: Color(0xff0F393A)),
                    const SizedBox(width: 8),
                    Container(
                      height: 10,
                      width: 20,
                      color: Colors.grey,
                    ),
                    const Spacer(),
                    const Icon(Icons.favorite_border, color: Color(0xff0F393A)),
                    const SizedBox(width: 8),
                    Container(
                      height: 10,
                      width: 20,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 20),
                    SvgPicture.asset(
                      'assets/icons/CommentIcon.svg',
                      height: 19,
                    ),
                    const SizedBox(width: 8),
                    Container(
                      height: 10,
                      width: 20,
                      color: Colors.grey,
                    ),
              ],
            ),
          ])));
          }
        });
  }
}
