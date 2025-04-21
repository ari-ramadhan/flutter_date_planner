import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

const presets = {0: 'Today', 1: 'Tomorrow', 3: 'In 3 days', 7: 'In a week'};

class PresetsDatePicker extends StatefulWidget {
  final DateTime oldDate;
  final String formattedDate;
  final ValueChanged<DateTime?>? onChanged;
  const PresetsDatePicker({
    super.key,
    required this.formattedDate,
    required this.oldDate,
    required this.onChanged,
  });

  @override
  State<PresetsDatePicker> createState() => _PresetsDatePickerState();
}

class _PresetsDatePickerState extends State<PresetsDatePicker> {
  final groupId = UniqueKey();
  final today = DateTime.now().startOfDay;
  DateTime? selected;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selected = widget.oldDate;
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    return ShadDatePicker(
      // Using the same groupId to keep the date picker popover open when the
      // select popover is closed.
      groupId: groupId,
      onChanged: widget.onChanged,
      allowDeselection: false,
      header: ShadSelect<int>(
        groupId: groupId,
        minWidth: 284,
        trailing: Icon(CupertinoIcons.chevron_down),
        placeholder: Column(children: [Text('Select')]),
        options:
            presets.entries
                .map((e) => ShadOption(value: e.key, child: Text(e.value)))
                .toList(),
        selectedOptionBuilder: (context, value) {
          return Text(presets[value]!);
        },
        onChanged: (value) {
          if (value == null) return;
          setState(() {
            selected = today.add(Duration(days: value));
          });
        },
      ),
      selected: selected,
      calendarDecoration: theme.calendarTheme.decoration,
      popoverPadding: const EdgeInsets.all(4),
      backgroundColor: CupertinoColors.systemGrey6,
    );
  }
}
