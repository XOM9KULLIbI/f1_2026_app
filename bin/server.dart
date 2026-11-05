import 'dart:convert';
import 'dart:io';

/// Standalone REST API Server for F1 2026 App (Lab 4 & 5).
/// Runs on http://127.0.0.1:8080 and provides:
///  - GET /v1/calendar/2026 or /v1/calendar
///  - GET /v1/grands-prix/:id
///  - GET /v1/health
void main(List<String> args) async {
  final port = args.isNotEmpty ? int.tryParse(args[0]) ?? 8080 : 8080;
  final address = InternetAddress.anyIPv4;

  final server = await HttpServer.bind(address, port, shared: true);
  print('================================================================');
  print('рџЏЋпёЏ  F1 2026 REST API Server is up and running!');
  print('рџ“Ў Listening on:');
  print('   - http://127.0.0.1:$port');
  print('   - http://localhost:$port');
  print('рџ“‹ Endpoints:');
  print('   GET  /v1/calendar/2026  (or /v1/calendar)');
  print('   GET  /v1/grands-prix/:id (e.g. /v1/grands-prix/round-1)');
  print('   GET  /v1/health');
  print('================================================================');

  await for (HttpRequest request in server) {
    _handleRequest(request);
  }
}

void _handleRequest(HttpRequest request) async {
  final res = request.response;
  final path = request.uri.path;
  final method = request.method;
  final stopwatch = Stopwatch()..start();

  // CORS headers
  res.headers.set('Access-Control-Allow-Origin', '*');
  res.headers.set('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.headers.set('Access-Control-Allow-Headers', 'Origin, Content-Type, Accept, X-Client');
  res.headers.set('Content-Type', 'application/json; charset=utf-8');

  if (method == 'OPTIONS') {
    res.statusCode = HttpStatus.ok;
    await res.close();
    return;
  }

  try {
    if (path == '/v1/calendar/2026' || path == '/v1/calendar' || path == '/calendar/2026' || path == '/calendar') {
      res.statusCode = HttpStatus.ok;
      res.write(jsonEncode(_kCalendarData));
    } else if (path.startsWith('/v1/grands-prix/') || path.startsWith('/grands-prix/')) {
      final id = path.split('/').last;
      final match = _kCalendarData.cast<Map<String, dynamic>?>().firstWhere(
            (e) => e?['id'] == id,
            orElse: () => null,
          );
      if (match != null) {
        res.statusCode = HttpStatus.ok;
        res.write(jsonEncode(match));
      } else {
        res.statusCode = HttpStatus.notFound;
        res.write(jsonEncode({'error': 'Grand Prix not found', 'id': id}));
      }
    } else if (path == '/' || path == '/v1/health') {
      res.statusCode = HttpStatus.ok;
      res.write(jsonEncode({
        'status': 'OK',
        'service': 'F1 2026 Local REST API',
        'version': '1.0.0',
        'totalRounds': _kCalendarData.length,
        'endpoints': [
          'GET /v1/calendar/2026',
          'GET /v1/grands-prix/:id',
          'GET /v1/health',
        ]
      }));
    } else {
      res.statusCode = HttpStatus.notFound;
      res.write(jsonEncode({'error': 'Not found', 'path': path}));
    }
  } catch (e) {
    res.statusCode = HttpStatus.internalServerError;
    res.write(jsonEncode({'error': e.toString()}));
  } finally {
    stopwatch.stop();
    await res.close();
    final now = DateTime.now().toIso8601String().substring(11, 19);
    print('[$now] $method $path -> ${res.statusCode} (${stopwatch.elapsedMilliseconds} ms)');
  }
}

final List<Map<String, dynamic>> _kCalendarData = [
  {
    'id': 'round-1',
    'round': 1,
    'title': 'FORMULA 1 QATAR AIRWAYS AUSTRALIAN GRAND PRIX 2026',
    'place': 'Australia',
    'date': '06 - 08 Mar',
    'status': 'Р—Р°РІРµСЂС€РµРЅ',
    'p1Name': 'Russell',
    'p1Code': 'RUS',
    'p1Time': '1:23:06.801',
    'p2Name': 'Antonelli',
    'p2Code': 'ANT',
    'p2Time': '+2.974',
    'p3Name': 'Leclerc',
    'p3Code': 'LEC',
    'p3Time': '+15.519',
  },
  {
    'id': 'round-2',
    'round': 2,
    'title': 'FORMULA 1 HEINEKEN CHINESE GRAND PRIX 2026',
    'place': 'China',
    'date': '13 - 15 Mar',
    'status': 'Р—Р°РІРµСЂС€РµРЅ',
    'p1Name': 'Antonelli',
    'p1Code': 'ANT',
    'p1Time': '1:33:15.607',
    'p2Name': 'Russell',
    'p2Code': 'RUS',
    'p2Time': '+5.515',
    'p3Name': 'Hamilton',
    'p3Code': 'HAM',
    'p3Time': '+25.267',
  },
  {
    'id': 'round-3',
    'round': 3,
    'title': 'FORMULA 1 ARAMCO JAPANESE GRAND PRIX 2026',
    'place': 'Japan',
    'date': '27 - 29 Mar',
    'status': 'Р—Р°РІРµСЂС€РµРЅ',
    'p1Name': 'Antonelli',
    'p1Code': 'ANT',
    'p1Time': '1:28:03.403',
    'p2Name': 'Piastri',
    'p2Code': 'PIA',
    'p2Time': '+13.722',
    'p3Name': 'Leclerc',
    'p3Code': 'LEC',
    'p3Time': '+15.27',
  },
  {
    'id': 'round-4',
    'round': 4,
    'title': 'FORMULA 1 CRYPTO.COM MIAMI GRAND PRIX 2026',
    'place': 'Miami',
    'date': '01 - 03 May',
    'status': 'Р—Р°РІРµСЂС€РµРЅ',
    'p1Name': 'Antonelli',
    'p1Code': 'ANT',
    'p1Time': '1:33:19.273',
    'p2Name': 'Norris',
    'p2Code': 'NOR',
    'p2Time': '+3.264',
    'p3Name': 'Piastri',
    'p3Code': 'PIA',
    'p3Time': '+27.092',
  },
  {
    'id': 'round-5',
    'round': 5,
    'title': 'FORMULA 1 LENOVO GRAND PRIX DU CANADA 2026',
    'place': 'Canada',
    'date': '22 - 24 May',
    'status': 'Р—Р°РІРµСЂС€РµРЅ',
    'p1Name': 'Antonelli',
    'p1Code': 'ANT',
    'p1Time': '1:28:15.758',
    'p2Name': 'Hamilton',
    'p2Code': 'HAM',
    'p2Time': '+10.768',
    'p3Name': 'Verstappen',
    'p3Code': 'VER',
    'p3Time': '+11.276',
  },
  {
    'id': 'round-6',
    'round': 6,
    'title': 'FORMULA 1 LOUIS VUITTON GRAND PRIX DE MONACO 2026',
    'place': 'Monaco',
    'date': '05 - 07 Jun',
    'status': 'Р—Р°РІРµСЂС€РµРЅ',
    'p1Name': 'Antonelli',
    'p1Code': 'ANT',
    'p1Time': '2:23:31.243',
    'p2Name': 'Hamilton',
    'p2Code': 'HAM',
    'p2Time': '+6.271',
    'p3Name': 'Hadjar',
    'p3Code': 'HAD',
    'p3Time': '+23.394',
  },
  {
    'id': 'round-7',
    'round': 7,
    'title': 'FORMULA 1 MSC CRUISES GRAN PREMIO DE BARCELONA-CATALUNYA 2026',
    'place': 'Barcelona-Catalunya',
    'date': '12 - 14 Jun',
    'status': 'Р—Р°РІРµСЂС€РµРЅ',
    'p1Name': 'Hamilton',
    'p1Code': 'HAM',
    'p1Time': '1:32:28.105',
    'p2Name': 'Russell',
    'p2Code': 'RUS',
    'p2Time': '+19.561',
    'p3Name': 'Norris',
    'p3Code': 'NOR',
    'p3Time': '+23.719',
  },
  {
    'id': 'round-8',
    'round': 8,
    'title': 'FORMULA 1 LENOVO AUSTRIAN GRAND PRIX 2026',
    'place': 'Austria',
    'date': '26 - 28 Jun',
    'status': 'Р—Р°РІРµСЂС€РµРЅ',
    'p1Name': 'Russell',
    'p1Code': 'RUS',
    'p1Time': '1:26:37.979',
    'p2Name': 'Verstappen',
    'p2Code': 'VER',
    'p2Time': '+1.611',
    'p3Name': 'Antonelli',
    'p3Code': 'ANT',
    'p3Time': '+1.986',
  },
  {
    'id': 'round-9',
    'round': 9,
    'title': 'FORMULA 1 PIRELLI BRITISH GRAND PRIX 2026',
    'place': 'Great Britain',
    'date': '03 - 05 Jul',
    'status': 'Р—Р°РІРµСЂС€РµРЅ',
    'p1Name': 'Leclerc',
    'p1Code': 'LEC',
    'p1Time': '1:27:11.335',
    'p2Name': 'Russell',
    'p2Code': 'RUS',
    'p2Time': '+0.427',
    'p3Name': 'Hamilton',
    'p3Code': 'HAM',
    'p3Time': '+0.772',
  },
  {
    'id': 'round-10',
    'round': 10,
    'title': 'FORMULA 1 MOГ‹T & CHANDON BELGIAN GRAND PRIX 2026',
    'place': 'Belgium',
    'date': '17 - 19 Jul',
    'status': 'Р—Р°РІРµСЂС€РµРЅ',
    'p1Name': 'Antonelli',
    'p1Code': 'ANT',
    'p1Time': '1:24:42.479',
    'p2Name': 'Leclerc',
    'p2Code': 'LEC',
    'p2Time': '+1.952',
    'p3Name': 'Verstappen',
    'p3Code': 'VER',
    'p3Time': '+11.586',
  },
  {
    'id': 'round-11',
    'round': 11,
    'title': 'FORMULA 1 AWS HUNGARIAN GRAND PRIX 2026',
    'place': 'Hungary',
    'date': '24 - 26 Jul',
    'status': 'Р—Р°РІРµСЂС€РµРЅ',
    'p1Name': 'Norris',
    'p1Code': 'NOR',
    'p1Time': '1:39:56.180',
    'p2Name': 'Verstappen',
    'p2Code': 'VER',
    'p2Time': '+15.08',
    'p3Name': 'Antonelli',
    'p3Code': 'ANT',
    'p3Time': '+18.728',
  },
  {
    'id': 'round-12',
    'round': 12,
    'title': 'FORMULA 1 HEINEKEN DUTCH GRAND PRIX 2026',
    'place': 'Netherlands',
    'date': '21 - 23 Aug',
    'status': 'Р—Р°РІРµСЂС€РµРЅ',
    'p1Name': 'Norris',
    'p1Code': 'NOR',
    'p1Time': '2:04:44.859',
    'p2Name': 'Antonelli',
    'p2Code': 'ANT',
    'p2Time': '+11.536',
    'p3Name': 'Russell',
    'p3Code': 'RUS',
    'p3Time': '+15.906',
  },
  {
    'id': 'round-13',
    'round': 13,
    'title': 'FORMULA 1 PIRELLI GRAN PREMIO DвЂ™ITALIA 2026',
    'place': 'Italy',
    'date': '04 - 06 Sep',
    'status': 'Р—Р°РІРµСЂС€РµРЅ',
    'p1Name': 'Antonelli',
    'p1Code': 'ANT',
    'p1Time': '1:51:15.281',
    'p2Name': 'Russell',
    'p2Code': 'RUS',
    'p2Time': '+3.857',
    'p3Name': 'Verstappen',
    'p3Code': 'VER',
    'p3Time': '+14.718',
  },
  {
    'id': 'round-14',
    'round': 14,
    'title': 'FORMULA 1 TAG HEUER GRAN PREMIO DE ESPAГ‘A 2026',
    'place': 'Spain',
    'date': '11 - 13 Sep',
    'status': 'Р—Р°РІРµСЂС€РµРЅ',
    'p1Name': 'Antonelli',
    'p1Code': 'ANT',
    'p1Time': '1:34:23.754',
    'p2Name': 'Verstappen',
    'p2Code': 'VER',
    'p2Time': '+4.351',
    'p3Name': 'Norris',
    'p3Code': 'NOR',
    'p3Time': '+5.089',
  },
  {
    'id': 'round-15',
    'round': 15,
    'title': 'FORMULA 1 QATAR AIRWAYS AZERBAIJAN GRAND PRIX 2026',
    'place': 'Azerbaijan',
    'date': '24 - 26 Sep',
    'status': 'Р—Р°РІРµСЂС€РµРЅ',
    'p1Name': 'Russell',
    'p1Code': 'RUS',
    'p1Time': '1:38:02.143',
    'p2Name': 'Verstappen',
    'p2Code': 'VER',
    'p2Time': '+0.196',
    'p3Name': 'Hadjar',
    'p3Code': 'HAD',
    'p3Time': '+10.704',
  },
  {
    'id': 'round-16',
    'round': 16,
    'title': 'FORMULA 1 GULF AIR BAHRAIN GRAND PRIX IN MALAYSIA 2026',
    'place': 'РњР°Р»Р°Р№Р·РёСЏ',
    'date': '02 - 04 Oct',
    'status': 'Р—Р°РІРµСЂС€РµРЅ',
    'p1Name': 'Verstappen',
    'p1Code': 'VER',
    'p1Time': '1:47:14.808',
    'p2Name': 'Antonelli',
    'p2Code': 'ANT',
    'p2Time': '+2.307',
    'p3Name': 'Hamilton',
    'p3Code': 'HAM',
    'p3Time': '+4.919',
  },
  {
    'id': 'round-17',
    'round': 17,
    'title': 'FORMULA 1 SINGAPORE AIRLINES SINGAPORE GRAND PRIX 2026',
    'place': 'Singapore',
    'date': '09 - 11 Oct',
    'status': 'Р—Р°РІРµСЂС€РµРЅ',
    'p1Name': 'Verstappen',
    'p1Code': 'VER',
    'p1Time': '1:42:00.785',
    'p2Name': 'Leclerc',
    'p2Code': 'LEC',
    'p2Time': '+7.335',
    'p3Name': 'Antonelli',
    'p3Code': 'ANT',
    'p3Time': '+24.573',
  },
  {
    'id': 'round-18',
    'round': 18,
    'title': 'FORMULA 1 MSC CRUISES UNITED STATES GRAND PRIX 2026',
    'place': 'United States',
    'date': '23 - 25 Oct',
    'status': 'Р—Р°РІРµСЂС€РµРЅ',
    'p1Name': 'Antonelli',
    'p1Code': 'ANT',
    'p1Time': '1:35:16.650',
    'p2Name': 'Leclerc',
    'p2Code': 'LEC',
    'p2Time': '+13.078',
    'p3Name': 'Verstappen',
    'p3Code': 'VER',
    'p3Time': '+17.485',
  },
  {
    'id': 'round-19',
    'round': 19,
    'title': 'FORMULA 1 GRAN PREMIO DE LA CIUDAD DE MГ‰XICO 2026',
    'place': 'Mexico',
    'date': '30 Oct - 01 Nov',
    'status': 'РќРµРёР·РІРµСЃС‚РЅРѕ',
    'p1Name': null,
    'p1Code': null,
    'p1Time': null,
    'p2Name': null,
    'p2Code': null,
    'p2Time': null,
    'p3Name': null,
    'p3Code': null,
    'p3Time': null,
  },
  {
    'id': 'round-20',
    'round': 20,
    'title': 'FORMULA 1 MSC CRUISES GRANDE PRГЉMIO DE SГѓO PAULO 2026',
    'place': 'Brazil',
    'date': '06 - 08 Nov',
    'status': 'РџСЂРµРґСЃС‚РѕСЏС‰РёР№ СЌС‚Р°Рї',
    'p1Name': null,
    'p1Code': null,
    'p1Time': null,
    'p2Name': null,
    'p2Code': null,
    'p2Time': null,
    'p3Name': null,
    'p3Code': null,
    'p3Time': null,
  },
  {
    'id': 'round-21',
    'round': 21,
    'title': 'FORMULA 1 HEINEKEN LAS VEGAS GRAND PRIX 2026',
    'place': 'Las Vegas',
    'date': '19 - 21 Nov',
    'status': 'РџСЂРµРґСЃС‚РѕСЏС‰РёР№ СЌС‚Р°Рї',
    'p1Name': null,
    'p1Code': null,
    'p1Time': null,
    'p2Name': null,
    'p2Code': null,
    'p2Time': null,
    'p3Name': null,
    'p3Code': null,
    'p3Time': null,
  },
  {
    'id': 'round-22',
    'round': 22,
    'title': 'FORMULA 1 QATAR AIRWAYS QATAR GRAND PRIX 2026',
    'place': 'Qatar',
    'date': '27 - 29 Nov',
    'status': 'РџСЂРµРґСЃС‚РѕСЏС‰РёР№ СЌС‚Р°Рї',
    'p1Name': null,
    'p1Code': null,
    'p1Time': null,
    'p2Name': null,
    'p2Code': null,
    'p2Time': null,
    'p3Name': null,
    'p3Code': null,
    'p3Time': null,
  },
  {
    'id': 'round-23',
    'round': 23,
    'title': 'FORMULA 1 ETIHAD AIRWAYS ABU DHABI GRAND PRIX 2026',
    'place': 'Abu Dhabi',
    'date': '04 - 06 Dec',
    'status': 'РџСЂРµРґСЃС‚РѕСЏС‰РёР№ СЌС‚Р°Рї',
    'p1Name': null,
    'p1Code': null,
    'p1Time': null,
    'p2Name': null,
    'p2Code': null,
    'p2Time': null,
    'p3Name': null,
    'p3Code': null,
    'p3Time': null,
  },
];
