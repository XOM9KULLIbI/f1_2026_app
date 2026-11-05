import 'package:equatable/equatable.dart';

class GrandPrix extends Equatable {
  final String id;
  final int round;
  final String title;
  final String place;
  final String date;
  final String status;
  final String? p1Name;
  final String? p1Code;
  final String? p1Time;
  final String? p2Name;
  final String? p2Code;
  final String? p2Time;
  final String? p3Name;
  final String? p3Code;
  final String? p3Time;

  const GrandPrix({
    required this.id,
    required this.round,
    required this.title,
    required this.place,
    required this.date,
    required this.status,
    this.p1Name,
    this.p1Code,
    this.p1Time,
    this.p2Name,
    this.p2Code,
    this.p2Time,
    this.p3Name,
    this.p3Code,
    this.p3Time,
  });

  bool get isCompleted => status == 'Завершен';
  bool get isUnknown => status == 'Неизвестно';
  bool get isUpcoming => status == 'Предстоящий этап';

  factory GrandPrix.fromJson(Map<String, dynamic> json) {
    final roundNum = (json['round'] as num?)?.toInt() ?? 1;
    return GrandPrix(
      id: (json['id'] as String?) ?? 'round-$roundNum',
      round: roundNum,
      title: (json['title'] as String?) ?? 'Grand Prix $roundNum',
      place: (json['place'] as String?) ?? 'Circuit',
      date: (json['date'] as String?) ?? 'TBA',
      status: (json['status'] as String?) ?? 'Предстоящий этап',
      p1Name: json['p1Name'] as String?,
      p1Code: json['p1Code'] as String?,
      p1Time: json['p1Time'] as String?,
      p2Name: json['p2Name'] as String?,
      p2Code: json['p2Code'] as String?,
      p2Time: json['p2Time'] as String?,
      p3Name: json['p3Name'] as String?,
      p3Code: json['p3Code'] as String?,
      p3Time: json['p3Time'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'round': round,
      'title': title,
      'place': place,
      'date': date,
      'status': status,
      'p1Name': p1Name,
      'p1Code': p1Code,
      'p1Time': p1Time,
      'p2Name': p2Name,
      'p2Code': p2Code,
      'p2Time': p2Time,
      'p3Name': p3Name,
      'p3Code': p3Code,
      'p3Time': p3Time,
    };
  }

  @override
  List<Object?> get props => [
        id,
        round,
        title,
        place,
        date,
        status,
        p1Name,
        p1Code,
        p1Time,
        p2Name,
        p2Code,
        p2Time,
        p3Name,
        p3Code,
        p3Time,
      ];
}
