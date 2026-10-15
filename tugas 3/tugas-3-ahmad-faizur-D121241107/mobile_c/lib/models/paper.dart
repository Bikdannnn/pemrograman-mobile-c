class Paper {
  final String title;
  final String authors;
  final String venue;
  final String releaseDate;
  final String doi;
  final String abstractText;

  const Paper({
    required this.title,
    required this.authors,
    required this.venue,
    required this.releaseDate,
    required this.doi,
    required this.abstractText,
  });

  String get launchableUrl {
    if (doi.startsWith('http://') || doi.startsWith('https://')) {
      return doi;
    }
    if (doi.startsWith('10.')) {
      return 'https://doi.org/$doi';
    }
    return doi;
  }

  factory Paper.fromJson(Map<String, dynamic> json) {
    // Title
    final title = json['title'] ?? json['display_name'] ?? 'Untitled Paper';

    // Authors
    String authors = 'Unknown Authors';
    final authorships = json['authorships'];
    if (authorships is List && authorships.isNotEmpty) {
      final names = authorships
          .map((a) => a['author']?['display_name'] ?? a['raw_author_name'])
          .where((name) => name != null && name.toString().trim().isNotEmpty)
          .cast<String>()
          .toList();
      if (names.isNotEmpty) {
        authors = names.join(', ');
      }
    }

    // Venue
    String venue = 'Unspecified Venue';
    final primaryLoc = json['primary_location'];
    if (primaryLoc != null && primaryLoc['source'] != null) {
      final sourceName = primaryLoc['source']['display_name'];
      if (sourceName != null && sourceName.toString().trim().isNotEmpty) {
        venue = sourceName.toString();
      }
    } else if (json['locations'] is List && (json['locations'] as List).isNotEmpty) {
      for (var loc in (json['locations'] as List)) {
        final name = loc['source']?['display_name'];
        if (name != null && name.toString().trim().isNotEmpty) {
          venue = name.toString();
          break;
        }
      }
    }

    // Release Date
    String releaseDate = 'Unknown Date';
    if (json['publication_date'] != null &&
        json['publication_date'].toString().isNotEmpty) {
      releaseDate = json['publication_date'].toString();
    } else if (json['publication_year'] != null) {
      releaseDate = json['publication_year'].toString();
    }

    // DOI
    String doi = 'No DOI available';
    if (json['doi'] != null && json['doi'].toString().isNotEmpty) {
      doi = json['doi'].toString();
    } else if (json['ids'] is Map && json['ids']['doi'] != null) {
      doi = json['ids']['doi'].toString();
    } else if (json['primary_location']?['landing_page_url'] != null) {
      doi = json['primary_location']['landing_page_url'].toString();
    } else if (json['id'] != null) {
      doi = json['id'].toString();
    }

    // Abstract
    String abstractText = 'No abstract available for this publication.';
    final invertedIndex = json['abstract_inverted_index'];
    if (invertedIndex is Map && invertedIndex.isNotEmpty) {
      final Map<int, String> positionToWord = {};
      invertedIndex.forEach((word, positions) {
        if (positions is List) {
          for (var pos in positions) {
            if (pos is int) {
              positionToWord[pos] = word.toString();
            }
          }
        }
      });
      final sortedKeys = positionToWord.keys.toList()..sort();
      if (sortedKeys.isNotEmpty) {
        abstractText = sortedKeys.map((k) => positionToWord[k]!).join(' ');
      }
    }

    return Paper(
      title: title,
      authors: authors,
      venue: venue,
      releaseDate: releaseDate,
      doi: doi,
      abstractText: abstractText,
    );
  }
}
