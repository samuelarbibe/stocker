class TimeSpan {
  final int value;
  final int days;
  final String name;
  final String shortname;
  final String resolution;

  TimeSpan(this.value, this.days, this.name, this.shortname, this.resolution);

  static List<TimeSpan> timeSpans = [
    TimeSpan(1, 1, 'day', '1D', '60'),
    TimeSpan(1, 7, 'week', '1W', '60'),
    TimeSpan(1, 30, 'month', '1M', 'D'),
    TimeSpan(1, 356, 'year', '1Y', 'W'),
    TimeSpan(5, 356 * 5, 'year', '5Y', 'W'),
  ];

  get asReadableString =>
      '${this.value} ${this.name}' + ((this.value > 1) ? 's' : '');
}
