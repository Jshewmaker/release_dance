import 'package:flutter_event_calendar/flutter_event_calendar.dart';

class Pt {
  static Map<String, Map<CalendarType, List<String>>> fullMonthNames = const {
    'pt': {
      CalendarType.JALALI: [
        'Farvardin',
        'Ordibehesht',
        'Khordad',
        'Tir',
        'Mordad',
        'Shahrivar',
        'Mehr',
        'Aban',
        'Azar',
        'Dey',
        'Bahman',
        'Esfand',
      ],
      CalendarType.GREGORIAN: [
        'Janeiro',
        'Fevereiro',
        'Março',
        'Abril',
        'Maio',
        'Junho',
        'Julho',
        'Agosto',
        'Setembro',
        'Outubro',
        'Novembro',
        'Dezembro',
      ],
    },
  };
  static Map<String, Map<CalendarType, List<String>>> shortMonthNames = const {
    'pt': {
      CalendarType.JALALI: [
        'Far',
        'Ord',
        'Kho',
        'Tir',
        'Mor',
        'Sha',
        'Mehr',
        'Aban',
        'Azar',
        'Dey',
        'Bah',
        'Esf',
      ],
      CalendarType.GREGORIAN: [
        'Jan',
        'Fev',
        'Mar',
        'Abr',
        'Maio',
        'Jun',
        'Jul',
        'Ago',
        'Set',
        'Out',
        'Nov',
        'Dez',
      ],
    },
  };

  static Map<String, Map<CalendarType, List<String>>> fullDayNames = const {
    'pt': {
      CalendarType.JALALI: [
        'Sábado',
        'Domingo',
        'Segunda',
        'Terça',
        'Quarta',
        'Quinta',
        'Sexta',
      ],
      CalendarType.GREGORIAN: [
        'Domingo',
        'Segunda',
        'Terça',
        'Quarta',
        'Quinta',
        'Sexta',
        'Sábado',
      ],
    },
  };
  static Map<String, Map<CalendarType, List<String>>> shortDayNames = const {
    'pt': {
      CalendarType.JALALI: ['Sab', 'Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex'],
      CalendarType.GREGORIAN: ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sab'],
    },
  };
  static Map<String, Map<String, String>> titles = const {
    'pt': {
      'empty': 'Vazio',
      'month_selector': 'Escolha um mês',
      'year_selector': 'Escolha um ano',
    },
  };

  static Map<String, bool> directionIsRTL = {'pt': false};
}
