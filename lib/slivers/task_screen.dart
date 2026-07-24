import 'package:flutter/material.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

import 'task_data.dart';

/// Task-management agenda screen.
///
/// The task list is rendered with `super_sliver_list`, following the package's
/// "Additional Learning Materials → Example": a [ListController] paired with a
/// [ScrollController] drives a [SuperListView.builder], and tapping a date pill
/// uses `listController.animateToItem(...)` to scroll a task into view.
class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  // --- Example wiring from the super_sliver_list docs -----------------------
  final ListController _listController = ListController();
  final ScrollController _scrollController = ScrollController();

  int _selectedDay = 1; // "13 Mon" selected by default

  @override
  void dispose() {
    _listController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Straight from the Example: animate a given item to the top of the viewport.
  void _animateToTask(int index) {
    if (index < 0 || index >= kTasks.length) return;
    _listController.animateToItem(
      index: index,
      scrollController: _scrollController,
      alignment: 0,
      duration: (estimatedDistance) => const Duration(milliseconds: 350),
      curve: (estimatedDistance) => Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.black,
      body: Column(
        children: [
          _DarkHeader(
            selectedDay: _selectedDay,
            onDaySelected: (i) {
              setState(() => _selectedDay = i);
              // Demonstrates the Example API: jump the agenda to a task.
              _animateToTask(i);
            },
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: TColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 24, 20, 12),
                    child: Text(
                      '9 Tasks today',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: TColors.black,
                      ),
                    ),
                  ),
                  // ---- super_sliver_list Example: SuperListView.builder ----
                  Expanded(
                    child: SuperListView.builder(
                      listController: _listController,
                      controller: _scrollController,
                      padding: const EdgeInsets.only(bottom: 32),
                      itemCount: kTasks.length,
                      itemBuilder: (context, index) =>
                          _TaskRow(task: kTasks[index]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Dark top area: month title, action icons and the horizontal date selector.
class _DarkHeader extends StatelessWidget {
  const _DarkHeader({required this.selectedDay, required this.onDaySelected});

  final int selectedDay;
  final ValueChanged<int> onDaySelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  '2023 October',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                _circleIcon(Icons.add),
                const SizedBox(width: 12),
                _circleIcon(Icons.search),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 74,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: kDays.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, index) => _DatePill(
                  day: kDays[index],
                  selected: index == selectedDay,
                  onTap: () => onDaySelected(index),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circleIcon(IconData icon) =>
      Icon(icon, color: Colors.white, size: 26);
}

class _DatePill extends StatelessWidget {
  const _DatePill({
    required this.day,
    required this.selected,
    required this.onTap,
  });

  final DayItem day;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 58,
        decoration: BoxDecoration(
          color: selected ? TColors.orange : const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${day.day}',
              style: TextStyle(
                color: selected ? Colors.white : Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              day.weekday,
              style: TextStyle(
                color: selected ? Colors.white : TColors.textMuted,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One agenda row: the pastel task card on the left and the timeline
/// (vertical line + colored dot + start time) on the right.
class _TaskRow extends StatelessWidget {
  const _TaskRow({required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Task card
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 12, 8),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: task.cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: TColors.black,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      task.description,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.35,
                        color: Color(0xFF5A5A5A),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      task.timeRange,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: TColors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Timeline gutter: colored dot + start time, centered beside the card
          SizedBox(
            width: 96,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: task.dotColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    task.startTime,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: TColors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
