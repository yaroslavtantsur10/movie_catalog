/// Список фільмів для лабораторної роботи №1.
const List<String> movieData = [
  'Inception;Christopher Nolan;2010;148;Sci-Fi;8.8',
  'Titanic;James Cameron;1997;195;Drama;7.9',
  'Avatar;James Cameron;2009;162;Sci-Fi;7.8',
  'Interstellar;Christopher Nolan;2014;169;Sci-Fi;8.7',
  'The Matrix;Lana Wachowski;1999;136;Action;8.7',
  'Gladiator;Ridley Scott;2000;155;Action;8.5',
  'Joker;Todd Phillips;2019;122;Drama;8.4',
  'The Dark Knight;Christopher Nolan;2008;152;Action;9.0',
  'Forrest Gump;Robert Zemeckis;1994;142;Drama;8.8',
  'Shrek;Andrew Adamson;2001;90;Animation;7.9',
  'Up;Pete Docter;2009;96;Animation;8.3',
  'Coco;Lee Unkrich;2017;105;Animation;8.4',

  // Три некоректні записи.
  'Frozen;Chris Buck;2013;102;Animation',
  'Dune;Denis Villeneuve;unknown;155;Sci-Fi;8.0',
  'Cars;John Lasseter;2006;abc;Animation;7.2',
];

/// Дані фільму у вигляді запису Dart.
typedef Movie = ({
  String title,
  String director,
  int year,
  int duration,
  String genre,
  double rating,
});

/// Перетворює рядок на запис про фільм.
Movie? parseMovie(String line) {
  final parts = line.split(';');

  if (parts.length != 6) return null;

  final title = parts[0].trim();
  final director = parts[1].trim();
  final year = int.tryParse(parts[2].trim());
  final duration = int.tryParse(parts[3].trim());
  final genre = parts[4].trim();
  final rating = double.tryParse(parts[5].trim());

  if (title.isEmpty ||
      director.isEmpty ||
      year == null ||
      duration == null ||
      genre.isEmpty ||
      rating == null) {
    return null;
  }

  return (
    title: title,
    director: director,
    year: year,
    duration: duration,
    genre: genre,
    rating: rating,
  );
}

/// Перевіряє коректність даних фільму.
List<String> validateMovie(Movie movie) {
  final errors = <String>[];

  if (movie.year < 1888 || movie.year > DateTime.now().year) {
    errors.add('Некоректний рік випуску');
  }

  if (movie.duration <= 0 || movie.duration > 600) {
    errors.add('Некоректна тривалість');
  }

  if (movie.rating < 0 || movie.rating > 10) {
    errors.add('Рейтинг має бути від 0 до 10');
  }

  return errors;
}

/// Обчислює середній рейтинг.
double averageRating(List<Movie> movies) {
  if (movies.isEmpty) return 0;

  final total = movies
      .map((movie) => movie.rating)
      .fold<double>(0, (sum, rating) => sum + rating);

  return total / movies.length;
}

/// Обчислює загальну тривалість.
int totalDuration(List<Movie> movies) {
  return movies
      .map((movie) => movie.duration)
      .fold<int>(0, (sum, duration) => sum + duration);
}

/// Фільтрує фільми за мінімальним рейтингом.
List<Movie> filterByRating(List<Movie> movies, double minRating) {
  return movies.where((movie) => movie.rating >= minRating).toList();
}

/// Групує фільми за жанрами.
Map<String, List<Movie>> groupByGenre(List<Movie> movies) {
  final groups = <String, List<Movie>>{};

  for (final movie in movies) {
    groups.putIfAbsent(movie.genre, () => <Movie>[]);
    groups[movie.genre]!.add(movie);
  }

  return groups;
}

/// Сортує фільми за рейтингом, а потім за роком випуску.
List<Movie> sortMovies(List<Movie> movies, {bool ascending = false}) {
  final sorted = [...movies];

  sorted.sort((a, b) {
    final ratingComparison = a.rating.compareTo(b.rating);

    if (ratingComparison != 0) {
      return ascending ? ratingComparison : -ratingComparison;
    }

    final yearComparison = a.year.compareTo(b.year);
    return ascending ? yearComparison : -yearComparison;
  });

  return sorted;
}

/// Обчислює кількість повних років від виходу фільму.
int movieAge(Movie movie) {
  final releaseDate = DateTime(movie.year, 1, 1);
  final today = DateTime.now();

  final Duration difference = today.difference(releaseDate);

  if (difference.isNegative) return 0;

  var years = today.year - releaseDate.year;

  if (today.month < releaseDate.month ||
      (today.month == releaseDate.month && today.day < releaseDate.day)) {
    years--;
  }

  return years;
}

/// Замінює роки в тексті на XXXX.
String maskYears(String text) {
  final pattern = RegExp(r'(?<year>\b(?:19|20)\d{2}\b)');

  return text.replaceAllMapped(pattern, (match) {
    final year = (match as RegExpMatch).namedGroup('year');

    if (year == null) {
      return match.group(0)!;
    }

    return 'XXXX';
  });
}

/// Створює лічильник фільмів за допомогою замикання.
int Function() createMovieCounter() {
  var count = 0;

  return () {
    count++;
    return count;
  };
}

/// Формує текстовий звіт про каталог фільмів.
String buildMovieReport(
  List<Movie> movies, {
  String title = 'Статистика каталогу фільмів',
  bool showDetails = true,
}) {
  final buffer = StringBuffer();

  buffer.writeln(title);
  buffer.writeln('Кількість фільмів: ${movies.length}');
  buffer.writeln(
    'Середній рейтинг: ${averageRating(movies).toStringAsFixed(2)}',
  );
  buffer.writeln('Загальна тривалість: ${totalDuration(movies)} хвилин');

  if (showDetails) {
    for (final movie in movies) {
      buffer.writeln('${movie.title} (${movie.year})');
    }
  }

  return buffer.toString();
}
