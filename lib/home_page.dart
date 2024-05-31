import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gradient_icon/gradient_icon.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media/create_post.dart';
import 'package:social_media/main.dart';
import 'package:social_media/services/auth_services.dart';
import 'package:social_media/services/storage_services.dart';
import 'package:social_media/signin_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = locator<AuthService>();
  final _store = locator<StorageServices>();
  List<Map<String, dynamic>> posts = [];

  // final String assetName = 'assets/image.svg';
  // final Widget comment = SvgPicture();

  uploadImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  }

  createPost(){
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create Post'),
          content: SizedBox(
            height: 200,
            child: Center(
              child: Column(
                children: [
                  const TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter Post Title'
                    ),
                  ),
                  const TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter Post Description'
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      uploadImage();
                    },
                    child: const Text('Upload Image'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Create Post'),
                  )
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  getPosts() async {
    posts = await _store.getPosts();
    setState(() {});
    print(posts);
  }

  @override
  void initState() {
    super.initState();
    getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 25),
          child: SvgPicture.asset('assets/icons/Camera.svg'),
        ),
        actions: [
          IconButton(
            icon: const Padding(
              padding: EdgeInsets.only(right: 25.0),
              child: Icon(Icons.search,size: 28),
            ),
            onPressed: () async {
                await _auth.signOut();
                if(!_auth.isloggedIn){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignInPage()));
                }
            },
          )
        ],
      ),
      body: Center(
        child: ListView.separated(
          itemCount: posts.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final post = posts[index];
            return Padding(
              padding: const EdgeInsets.fromLTRB(25, 15, 25, 15),
              child: Container(
                width: double.infinity,
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                child: Icon(Icons.person),
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
                                  border: Border.all(color: Colors.white, width: 2)
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(width: 16),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("User Name", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                            SizedBox(height: 5),
                            Text('52 minute ago', style: TextStyle(fontSize: 12,color: Color(0xff919191)))
                          ],
                        ),
                        const Spacer(),
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.white),
                            side: MaterialStateProperty.all(const BorderSide(color: Color(0xffEEEEEE))),
                          ),
                          onPressed: (){},
                          child: const Text("Following", style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600)), 
                        )
                        // ElevatedButton(
                        //   style: ButtonStyle(
                        //     backgroundColor: MaterialStateProperty.all(Colors.white),
                        //     // borderSide: MaterialStateProperty.all(BorderSide(color: Colors.black)),
                        //   ),
                        //   onPressed: (){}, 
                        //   child: const Text("Following", style: TextStyle(color: Colors.black)),
                        // )
                      ],
                    ),
                    const SizedBox(height: 25),
                    Container(
                      height: 271,
                      width: 345,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 22),
                    const Text("Description is describe the detials about the picture that the user has posted", style: TextStyle(fontSize: 12,color: Color(0xff919191))),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        const Icon(Icons.share_outlined,color: Color(0xff0F393A)),
                        const SizedBox(width: 8),
                        const Text('36'),
                        const Spacer(),
                        const Icon(Icons.favorite_border,color: Color(0xff0F393A)),
                        const SizedBox(width: 8),
                        const Text('85'),
                        const SizedBox(width: 20),
                        SvgPicture.asset('assets/icons/CommentIcon.svg',height: 19,),
                        const SizedBox(width: 8),
                        const Text('12'),
                      ],
                    ),
                  ],
                ),
              ),
              // Container(
              //   height: 400,
              //   // width: double.infinity,
              //   // decoration: BoxDecoration(
              //   //   color: Colors.grey,
              //   //   borderRadius: BorderRadius.circular(10),
              //   //   image: post['postImage'] != null ? DecorationImage(
              //   //     image: NetworkImage(post['postImage']),
              //   //     fit: BoxFit.cover
              //   //   ) : null,
              //   // ),
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       // post = post['postImage'] != null ? Image.network(post['postImage']) : null,
              //       post['postImage'] != null ? Image.network(post['postImage']) : const Text('No Image'),
              //       const SizedBox(height: 10,),
              //       Text(post['title'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              //       Text(post['description'], style: const TextStyle(fontSize: 15),)
              //     ],
              //   ),
              // ),
            );
          }
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const CreatePost()));
          // getPosts();
        },
        child: const Icon(Icons.add),
      )
    );
  }
}