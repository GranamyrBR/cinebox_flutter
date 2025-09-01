import 'package:flutter/material.dart';
import './scraper.dart';

class ShowsPage extends StatefulWidget {
  const ShowsPage({super.key});

  @override
  State<ShowsPage> createState() => _ShowsPageState();
}

class _ShowsPageState extends State<ShowsPage> {
  late Future<List<Show>> _shows;

  @override
  void initState() {
    super.initState();
    _shows = scrapeBroadwayShows();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Broadway Shows')),
      body: FutureBuilder<List<Show>>(
        future: _shows,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No shows found.'));
          } else {
            final shows = snapshot.data!;
            return ListView.builder(
              itemCount: shows.length,
              itemBuilder: (context, index) {
                final show = shows[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  elevation: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        show.imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200,
                        errorBuilder: (context, error, stackTrace) {
                          return const SizedBox(
                            height: 200,
                            child: Center(child: Text('Image not available')),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              show.title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(show.summary),
                            const SizedBox(height: 8),
                            Text("About: ${show.about}"),
                            const SizedBox(height: 8),
                            Text("Running Time: ${show.runningTime}"),
                            const SizedBox(height: 8),
                            Text("Group Minimum: ${show.groupMinimum}"),
                            const SizedBox(height: 8),
                            Text(
                              "Age Appropriateness: ${show.ageAppropriateness}",
                            ),
                            const SizedBox(height: 8),
                            Text("Location: ${show.location}"),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
