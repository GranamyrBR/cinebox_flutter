import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

class Show {
  final String title;
  final String summary;
  final String imageUrl;
  final String about;
  final String runningTime;
  final String groupMinimum;
  final String ageAppropriateness;
  final String location;

  Show({
    required this.title,
    required this.summary,
    required this.imageUrl,
    required this.about,
    required this.runningTime,
    required this.groupMinimum,
    required this.ageAppropriateness,
    required this.location,
  });
}

Future<List<Show>> scrapeBroadwayShows() async {
  try {
    final response = await http.get(
      Uri.parse('https://www.broadwayinbound.com/shows/'),
    );
    print(response.body);

    final document = parser.parse(response.body);
    final elements = document.querySelectorAll('.card-grid-item, .show-card');

    final List<Show> shows = [];

    for (final element in elements) {
      final titleElement = element.querySelector(
        '.card-title h3, .show-card-title h3',
      );
      final title = titleElement?.text.trim() ?? '';

      final summaryElement = element.querySelector(
        '.card-blurb, .show-card-blurb',
      );
      final summary = summaryElement?.text.trim() ?? '';

      final imageElement = element.querySelector(
        '.card-image img, .show-card-image img',
      );
      final imageUrl = imageElement?.attributes['src'] ?? '';

      final showPageLink = element.querySelector('a')?.attributes['href'];

      if (showPageLink != null) {
        final showPageResponse = await http.get(
          Uri.parse('https://www.broadwayinbound.com$showPageLink'),
        );
        final showPageDocument = parser.parse(showPageResponse.body);

        final aboutElement = showPageDocument.querySelector(
          '.about-show-blurb, .show-details',
        );
        final about = aboutElement?.text.trim() ?? '';

        String runningTime = '';
        String groupMinimum = '';
        String ageAppropriateness = '';

        final pElements = showPageDocument.querySelectorAll(
          '.about-show-details p, .show-info p',
        );
        for (var p in pElements) {
          final text = p.text.toLowerCase();
          if (text.contains('running time')) {
            runningTime = p.text
                .replaceAll(RegExp(r'running time:?', caseSensitive: false), '')
                .trim();
          }
          if (text.contains('group minimum')) {
            groupMinimum = p.text
                .replaceAll(
                  RegExp(r'group minimum:?', caseSensitive: false),
                  '',
                )
                .trim();
          }
          if (text.contains('age appropriateness')) {
            ageAppropriateness = p.text
                .replaceAll(
                  RegExp(r'age appropriateness:?', caseSensitive: false),
                  '',
                )
                .trim();
          }
        }

        final locationElement = showPageDocument.querySelector(
          '.location-map-address, .venue-address',
        );
        final location = locationElement?.text.trim() ?? '';

        shows.add(
          Show(
            title: title,
            summary: summary,
            imageUrl: imageUrl.startsWith('http')
                ? imageUrl
                : 'https://www.broadwayinbound.com$imageUrl',
            about: about,
            runningTime: runningTime,
            groupMinimum: groupMinimum,
            ageAppropriateness: ageAppropriateness,
            location: location,
          ),
        );
      }
    }

    return shows;
  } catch (e, stackTrace) {
    print('Error scraping shows: $e');
    print('Stack trace: $stackTrace');
    return [];
  }
}
