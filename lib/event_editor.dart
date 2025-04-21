// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'event.dart';
import 'event_detail.dart';

class EventEditor extends StatefulWidget {
  final Event event;
  final bool isNew;
  const EventEditor({super.key, required this.event, required this.isNew});

  @override
  State<EventEditor> createState() => _EventEditorState();
}

class _EventEditorState extends State<EventEditor> {
  late Event event;
  late bool isNew;
  late bool isEditing;

  @override
  void initState() {
    isNew = widget.isNew;
    isEditing = isNew;
    event = widget.event;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.secondarySystemBackground,
      navigationBar: CupertinoNavigationBar(
        leading: isNew
            ? CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Text('Cancel'),
                onPressed: () => Navigator.pop(context, null),
              )
            : CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.pop(context, event);
                },
                child: const Row(
                  children: [Icon(CupertinoIcons.back), Text('Date Planner')],
                ),
              ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text(isNew ? 'Add' : (isEditing ? 'Done' : 'Edit')),
          onPressed: () {
            if (isNew) {
              Navigator.pop(context, event);
            } else {
              setState(() {
                isEditing = !isEditing;
              });
            }
          },
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    EventDetail(event: event, isEditing: isEditing),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            if (isEditing && !isNew)
              Column(
                children: [
                  Divider(
                    height: double.minPositive,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ColoredBox(

                      color: CupertinoColors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: CupertinoButton(
                          child: const Text('Delete Event'),
                          onPressed: () {
                            setState(() {
                              Navigator.pop(context, null);
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
