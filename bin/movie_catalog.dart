import 'package:movie_catalog/movie_catalog.dart';

/// Запускає консольний каталог фільмів.
void main() {
  print('КАТАЛОГ ФІЛЬМІВ');

  final movies = <Movie>[];
  var validCount = 0;
  var errorCount = 0;

  for (final line in movieData) {
    final movie = parseMovie(line);

    if (movie == null) {
      print('Помилка в записі: $line');
      errorCount++;
    } else {
      final errors = validateMovie(movie);

      if (errors.isNotEmpty) {
        print('Некоректні дані: ${movie.title}');
        for (final error in errors) {
          print('  - $error');
        }
        errorCount++;
      } else {
        print('${movie.title} (${movie.year}) — ${movie.rating}/10');
        validCount++;
        movies.add(movie);
      }
    }
  }

  print('\nРЕЗУЛЬТАТ');
  print('Усього записів: ${movieData.length}');
  print('Успішно оброблено: $validCount');
  print('Помилок: $errorCount');

  print('\nСТАТИСТИКА');
  print('Середній рейтинг: ${averageRating(movies).toStringAsFixed(2)}');
  print('Загальна тривалість: ${totalDuration(movies)} хвилин');
  print('Фільмів із рейтингом від 8.5: ${filterByRating(movies, 8.5).length}');

  print('\nФІЛЬМИ ЗА ЖАНРАМИ');
  final genres = groupByGenre(movies);
  for (final entry in genres.entries) {
    print('${entry.key}: ${entry.value.length} фільмів');
  }

  print('\nСОРТУВАННЯ ЗА РЕЙТИНГОМ');
  final sortedMovies = sortMovies(movies);
  for (final movie in sortedMovies) {
    print('${movie.title} — ${movie.rating}/10 (${movie.year})');
  }

  print('\nВІК ФІЛЬМІВ');
  for (final movie in movies) {
    print('${movie.title}: ${movieAge(movie)} років');
  }

  print('\nМАСКУВАННЯ РОКУ');
  final example = 'Inception вийшов у 2010 році, а Avatar у 2009 році.';
  print('Початковий текст: $example');
  print('Після заміни: ${maskYears(example)}');

  print('\nЛІЧИЛЬНИК ФІЛЬМІВ');
  final nextMovie = createMovieCounter();
  for (final movie in movies.take(3)) {
    print('${nextMovie()}. ${movie.title}');
  }

  print('\nФОРМУВАННЯ ЗВІТУ');
  final report = buildMovieReport(
    movies,
    title: 'Статистика каталогу фільмів',
    showDetails: false,
  );
  print(report);
}
