// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'event.dart';
import 'event_data.dart';
import 'event_editor.dart';
import 'event_row.dart';

class EventList extends StatelessWidget {
  const EventList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EventData>(
      builder: (BuildContext context, EventData events, Widget? child) {
        return CupertinoPageScaffold(
          // TODO(mit-mit): Avoid having to pass nav bar manually.
          //
          // Would like to pass nav bar and body to CupertinoPageScaffold
          // directly, similar to the Material Scaffold's `appBar` and `body`
          // args.
          // https://github.com/flutter/flutter/issues/149625
          child: CustomScrollView(
            slivers: <Widget>[
              CupertinoSliverNavigationBar(
                largeTitle: const Text('Date Planner'),
                trailing: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Icon(CupertinoIcons.plus),
                  onPressed: () async {
                    // Issue: Should go to a sheet, not a a full-screen page.
                    // Blocked on https://github.com/flutter/flutter/issues/42560.
                    Event? newEvent = await Navigator.of(context).push(
                      CupertinoPageRoute<Event>(
                        builder:
                            (_) => EventEditor(
                              event: Event(title: 'New event'),
                              isNew: true,
                            ),
                      ),
                    );

                    if (newEvent != null) {
                      events.add(newEvent);
                    }
                  },
                ),
              ),
              SliverList.list(
                children: [
                  for (Period p in Period.values)
                    // events.sorted(p).isEmpty
                    //     ? Center(
                    //       child: Text(
                    //         'No events for ${p.name.toUpperCase()}',
                    //         style: const TextStyle(
                    //           fontSize: 16,
                    //           fontStyle: FontStyle.italic,
                    //         ),
                    //       ),
                    //     )
                    //     :
                    CupertinoListSection(
                      header: Text(
                        p.name.toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      children:
                          events.sorted(p).isEmpty
                              ? [
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  alignment: Alignment.center,
                                  child: Text('No event ${p.name}'),
                                ),
                              ]
                              : [
                                for (Event e in events.sorted(p))
                                  EventRow(
                                    event: e,
                                    onTap: () async {
                                      Event? updatedEvent = await Navigator.of(
                                        context,
                                      ).push(
                                        CupertinoPageRoute<Event>(
                                          builder:
                                              (_) => EventEditor(
                                                event: e.copy(),
                                                isNew: false,
                                              ),
                                        ),
                                      );
                                      if (updatedEvent == null) {
                                        events.delete(e);
                                      } else {
                                        events.update(e, updatedEvent);
                                      }
                                    },
                                  ),
                              ],
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
