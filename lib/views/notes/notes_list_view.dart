import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../services/cloud/cloud_note.dart';
import '../../utilities/dialogs/delete_dialog.dart';

typedef NoteCallback = void Function(CloudNote note);

class NotesListView extends StatelessWidget {
  final Iterable<CloudNote> notes;
  final NoteCallback onDeleteNote;
  final NoteCallback onTap;
  const NotesListView({
    Key? key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(15.0),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes.elementAt(index);
        return Card(
          elevation: 0,
          child: ListTile(
            leading: const Icon(Icons.sticky_note_2_rounded),
            onTap: () {
              onTap(note);
            },
            title: Text(
              note.text,
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
              onPressed: () async {
                final shouldDelete = await showDeleteDialog(context);
                if (shouldDelete) {
                  onDeleteNote(note);
                }
              },
              icon: const Icon(Icons.delete),
            ),
            minLeadingWidth: 20,
            minVerticalPadding: 20,
            focusColor: Colors.grey,
            hoverColor: Colors.black26,
            tileColor: Colors.lightBlue[50],
            selectedTileColor: Colors.white,
            iconColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
      },
    );
  }
}
