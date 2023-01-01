import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import 'add_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Our Memories'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Colors.red,
                Colors.blue,
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.pink,
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddImage()));
        },
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('imageURLs').snapshots(),
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/love1.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  padding: EdgeInsets.all(4),
                  child: GridView.builder(
                      itemCount: snapshot.data!.docs.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                boxShadow: [BoxShadow(blurRadius: 2)],
                                border: Border.all(
                                  color: Color.fromARGB(255, 97, 204, 136),
                                  width: 0.5,
                                )),
                            margin: const EdgeInsets.all(3),
                            child: FadeInImage.memoryNetwork(
                              fit: BoxFit.cover,
                              placeholder: kTransparentImage,
                              image: snapshot.data!.docs[index].get('url'),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) {
                                  return FullScreenImage();
                                },
                              ),
                            );
                          },
                        );
                      }),
                );
        },
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection('imageURLs').snapshots(),
          builder: (context, snapshot) {
            int index = 1;
            return GestureDetector(
              child: Center(
                child: Hero(
                  tag: 'imageHero',
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: snapshot.data!.docs[index].get('url'),
                    ),
                  ),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            );
          }),
    );
  }
}
