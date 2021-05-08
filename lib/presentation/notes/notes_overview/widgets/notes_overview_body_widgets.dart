import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ddd/application/notes/note_watcher/note_watcher_bloc.dart';

class NotesOverviewBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteWatcherBloc, NoteWatcherState>(
        builder: (context, state) {
      return state.map(
        initial: (_) => Container(
          color: Colors.blue,
        ),
        loadInProgress: (_) => const Center(
          child: CircularProgressIndicator(),
        ),
        loadSuccess: (state) {
          return ListView.builder(itemBuilder: (context, index) {
            final note = state.notes[index];
            if (note.failureOption.isSome()) {
              return Container(
                color: Colors.redAccent,
              );
            } else {
              return Container(
                width: 200,
                height: 200,
                color: Colors.green,
              );
            }
          },
          itemCount:  state.notes.size,);
        },
        loadFailure: (state) {
          return Container(
            color: Colors.yellowAccent,
          );
        },
      );
    });
  }
}
