// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:date_planner/custom_date_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'color_options.dart';
import 'event.dart';
import 'event_task.dart';
import 'symbol_editor.dart';
import 'task_row.dart';

class EventDetail extends StatefulWidget {
  final Event event;
  final bool isEditing;

  const EventDetail({super.key, required this.event, required this.isEditing});

  @override
  State<EventDetail> createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  final _eventText = TextEditingController();
  late ShadTimePickerController _timePickerController;
  late DateTime currentDate;
  DateTime newDate = DateTime.now();

  @override
  void initState() {
    _eventText.text = widget.event.title;
    _timePickerController = ShadTimePickerController(
      hour: widget.event.date.hour,
      minute: widget.event.date.minute,
      second: widget.event.date.second,
    );
    currentDate =  widget.event.date;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const titleStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 22);
    final event = widget.event;

    // TODO(mit-mit): Investigate manual overriding of colors and padding.
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 0, 0),
            color: CupertinoColors.systemBackground,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (widget.isEditing)
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        // minimumSize: Size.zero,
                        onPressed: () {
                          Navigator.of(context)
                              .push(
                                CupertinoPageRoute<(IconData, ColorOptions)?>(
                                  builder:
                                      (_) =>
                                          SymbolEditor(event.icon, event.color),
                                ),
                              )
                              .then(((IconData, ColorOptions)? data) {
                                if (data != null) {
                                  setState(() {
                                    var (icon, color) = data;
                                    event.icon = icon;
                                    event.color = color;
                                  });
                                }
                              });
                        },
                        child: Icon(
                          event.icon,
                          size: 28,
                          color: event.color.color,
                        ),
                      ),
                    if (!widget.isEditing)
                      Icon(event.icon, size: 28, color: event.color.color),
                    const SizedBox(width: 12),
                    if (widget.isEditing)
                      Expanded(
                        child: CupertinoTextField(
                          decoration: null,
                          padding: EdgeInsets.zero,
                          style: titleStyle,
                          controller: _eventText,
                          onChanged: (value) => event.title = value,
                        ),
                      ),
                    if (!widget.isEditing) Text(event.title, style: titleStyle),
                  ],
                ),
                const SizedBox(height: 12),
                // TODO(mit-mit): Use a widget for picking a date.
                // Issue: Blocked on not having the right calendar widget:
                // https://github.com/flutter/flutter/issues/63693
                widget.isEditing
                    ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Date & Time',
                          style: TextStyle(
                            color: CupertinoColors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        PresetsDatePicker(
                          formattedDate: event.dateFormated,
                          oldDate: event.date,
                          onChanged: (value) {
                            newDate = DateTime(
                              value!.year,
                              value!.month,
                              value!.day,
                              event.date.hour,
                              event.date.minute,
                              event.date.second,
                            );
                            event.date = newDate;
                          },
                        ),
                        SizedBox(height: 10),
                        ShadTimePicker(
                          controller: _timePickerController,
                          onChanged: (value) {
                            // Assign the selected time to the newTime variable
                            newDate = DateTime(
                              newDate.year,
                              newDate.month,
                              newDate.day,
                              value.hour,
                              value.minute,
                              value.second,
                            );

                            event.date = newDate;
                          },
                        ),
                        SizedBox(height: 10),
                        // Text(event.dateFormated),
                        // Text(event.dateFormated),
                      ],
                    )
                    : Text(event.dateFormated),
                CupertinoListSection(
                  // TODO(mit-mit): The list of tasks should be left-flush with the date above.
                  margin: EdgeInsets.zero,
                  backgroundColor: CupertinoColors.systemBackground,
                  decoration: null,
                  header: const Text(
                    'Tasks',
                    style: TextStyle(
                      color: CupertinoColors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  children: [
                    for (EventTask t in event.tasks)
                      TaskRow(task: t, isEditing: widget.isEditing),
                    if (widget.isEditing)
                      // TODO(mit-mit): CupertinoButton with icon support?
                      // Consider if CupertinoButton could support setting
                      // both a label and an icon directly:
                      // https://www.kodeco.com/books/swiftui-cookbook/v1.0/chapters/8-add-an-icon-to-a-button-in-swiftui
                      CupertinoButton(
                        child: const Row(
                          children: [
                            Icon(CupertinoIcons.plus),
                            Text('Add task'),
                          ],
                        ),
                        onPressed: () {
                          setState(() {
                            event.tasks.add(EventTask(text: ''));
                          });
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
