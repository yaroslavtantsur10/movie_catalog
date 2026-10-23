
import 'package:movie_catalog/movie_catalog.dart';
import 'package:test/test.dart';

void main() {
  final movies = movieData
      .map(parseMovie)
      .whereType<Movie>()
      .where((movie) => validateMovie(movie).isEmpty)
      .toList();

  test('Кількість початкових записів', () {
    expect(movieData.length, 15);
  });

  test('Кількість коректних фільмів', () {
    expect(movies.length, 12);
  });

  test('Правильне зчитування фільму', () {
    final movie = parseMovie(movieData[0]);

    expect(movie?.title, 'Inception');
    expect(movie?.year, 2010);
  });

  test('Некоректний запис повертає null', () {
    expect(parseMovie(movieData[12]), isNull);
  });

  test('Перевірка некоректного рейтингу', () {
    final movie = parseMovie('Test;Director;2020;120;Drama;15.0');

    expect(movie, isNotNull);
    expect(validateMovie(movie!), isNotEmpty);
  });

  test('Фільтрація за рейтингом', () {
    final filtered = filterByRating(movies, 8.5);

    expect(filtered.length, 6);
  });

  test('Групування за жанрами', () {
    final groups = groupByGenre(movies);

    expect(groups.length, 4);
    expect(groups['Sci-Fi']?.length, 3);
  });

  test('Сортування за рейтингом', () {
    final sorted = sortMovies(movies);

    expect(sorted.first.title, 'The Dark Knight');
    expect(sorted.last.title, 'Avatar');
  });

  test('Заміна років регулярним виразом', () {
    expect(maskYears('Фільми 2010 і 2009'), 'Фільми XXXX і XXXX');
  });

  test('Формування звіту', () {
    final report = buildMovieReport(
      movies,
      title: 'Тестовий звіт',
      showDetails: false,
    );

    expect(report, contains('Тестовий звіт'));
    expect(report, contains('Кількість фільмів: 12'));
  });
}

