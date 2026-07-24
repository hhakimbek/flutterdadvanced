import 'package:flutter/material.dart';

/// ---------------------------------------------------------------------------
/// Palette (design reference: Gilroy font + these core colors)
/// ---------------------------------------------------------------------------
class TColors {
  static const black = Color(0xFF111111); // dark header + primary text
  static const grey = Color(0xFFEFF1F2); // idle date pill / dividers
  static const orange = Color(0xFFDF5529); // accent (selected date)
  static const white = Color(0xFFFCFCFC); // task sheet background
  static const textMuted = Color(0xFF8A8A8E); // secondary text
}

/// A day shown in the horizontal date selector.
class DayItem {
  final int day;
  final String weekday;
  const DayItem(this.day, this.weekday);
}

const List<DayItem> kDays = [
  DayItem(12, 'Sun'),
  DayItem(13, 'Mon'),
  DayItem(14, 'Tue'),
  DayItem(15, 'Wed'),
  DayItem(16, 'Thu'),
  DayItem(17, 'Fri'),
  DayItem(18, 'Sat'),
];

/// A single task card.
class Task {
  final String title;
  final String description;
  final String timeRange; // shown inside the card
  final String startTime; // shown in the right-hand timeline gutter
  final Color cardColor; // pastel card background
  final Color dotColor; // timeline dot + start-time accent

  const Task({
    required this.title,
    required this.description,
    required this.timeRange,
    required this.startTime,
    required this.cardColor,
    required this.dotColor,
  });
}

/// Sample agenda for the selected day (long enough that the list truly scrolls,
/// so the SuperSliverList jump/animate behaviour is visible).
const List<Task> kTasks = [
  Task(
    title: 'Daily sync',
    description: 'To discuss with team all work processes for the day',
    timeRange: '9:00 AM – 10:30 AM',
    startTime: '9:00 AM',
    cardColor: Color(0xFFF7E4C9),
    dotColor: Color(0xFFE9A23B),
  ),
  Task(
    title: 'UX Wireframes design',
    description:
        'Make 10 Wireframes for a mobile fitness app. Need to show the basic '
        'functionality of the screens and the layout of the elements',
    timeRange: '10:30 AM – 13:30 AM',
    startTime: '10:30 AM',
    cardColor: Color(0xFFD8EFC4),
    dotColor: Color(0xFF5FB868),
  ),
  Task(
    title: 'Dribbble shots',
    description: 'Make 2 shots for Dribbble on any topic',
    timeRange: '13:30 AM – 18:00 AM',
    startTime: '1:30 PM',
    cardColor: Color(0xFFEBD6F3),
    dotColor: Color(0xFFC451D8),
  ),
  Task(
    title: 'Logo design',
    description: 'Create 4 versions of a logo for TBD task management app',
    timeRange: '18:00 PM – 19:30 PM',
    startTime: '4:00 PM',
    cardColor: Color(0xFFCFE6F2),
    dotColor: Color(0xFF3B82E9),
  ),
  Task(
    title: 'Team retro',
    description: 'Review what went well this week and plan improvements',
    timeRange: '19:30 PM – 20:15 PM',
    startTime: '7:30 PM',
    cardColor: Color(0xFFF7E4C9),
    dotColor: Color(0xFFE9A23B),
  ),
  Task(
    title: 'Read design articles',
    description: 'Catch up on the latest mobile UX patterns and case studies',
    timeRange: '20:15 PM – 21:00 PM',
    startTime: '8:15 PM',
    cardColor: Color(0xFFD8EFC4),
    dotColor: Color(0xFF5FB868),
  ),
  Task(
    title: 'Plan tomorrow',
    description: 'Sketch the task list and priorities for the next day',
    timeRange: '21:00 PM – 21:30 PM',
    startTime: '9:00 PM',
    cardColor: Color(0xFFEBD6F3),
    dotColor: Color(0xFFC451D8),
  ),
  Task(
    title: 'Inbox zero',
    description: 'Clear pending emails and reply to client feedback',
    timeRange: '21:30 PM – 22:00 PM',
    startTime: '9:30 PM',
    cardColor: Color(0xFFCFE6F2),
    dotColor: Color(0xFF3B82E9),
  ),
  Task(
    title: 'Wind down',
    description: 'Journal, stretch and prepare for a good night of sleep',
    timeRange: '22:00 PM – 22:30 PM',
    startTime: '10:00 PM',
    cardColor: Color(0xFFF7E4C9),
    dotColor: Color(0xFFE9A23B),
  ),
];
