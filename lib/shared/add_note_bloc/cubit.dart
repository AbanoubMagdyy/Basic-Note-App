import 'dart:io';
import 'package:basic_fivver_note_app/shared/add_note_bloc/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class AddNoteCubit extends Cubit<AddNotesStates> {
  AddNoteCubit() : super(InitState());

  static AddNoteCubit get(context) => BlocProvider.of(context);

  Database? dataBase;
  List<Map> notes = [];

  Future createDB() {
    return openDatabase(
      'notes.db',
      version: 1,
      onCreate: (database, version) {
        database.execute(
            'CREATE TABLE note(id INTEGER PRIMARY KEY , title TEXT, date TEXT, time TEXT, note TEXT, image_paths TEXT)');
      },
      onOpen: (database) {
        getDateFromDB(database);
      },
    ).then((value) {
      dataBase = value;
      emit(CreateDBState());
    });
  }

  Future<void> insertNoteToDB({
    required String title,
    required String time,
    required String date,
    required String note,
  }) async {
    if (imageFiles.isNotEmpty) {
      final directory = await getExternalStorageDirectory();
      if (directory != null) {
        final path = directory.path;
        final imagePaths = <String>[];
        for (final imageFile in imageFiles) {
          final file =
              File('$path/.${DateTime.now().millisecondsSinceEpoch}.jpg');
          await file.writeAsBytes(await imageFile.readAsBytes());
          imagePaths.add(file.path);
        }
        await dataBase?.transaction(
          (txn) {
            txn
                .rawInsert(
                    'INSERT INTO note(title,time,date,note,image_paths) VALUES ("$title","$time","$date","$note","${imagePaths.join(',')}")')
                .then(
              (value) {
                emit(InsertDBWithImagesState());
                getDateFromDB(dataBase);
              },
            );
            return Future(() => null);
          },
        );
      }
    }

    if (imageFiles.isEmpty) {
      await dataBase?.transaction(
        (txn) {
          txn
              .rawInsert(
                  'INSERT INTO note(title,time,date,note,image_paths) VALUES ("$title","$time","$date","$note","null") ')
              .then(
            (value) {
              emit(InsertDBWithoutImagesState());
              getDateFromDB(dataBase);
              removeImages();
            },
          );
          return Future(() => null);
        },
      );
    }
  }

  Future<List<Map>> getDateFromDB(database) async {
    notes = [];

    return await database.rawQuery('SELECT * FROM note').then((value) {
      value.forEach((element) {
        notes.add(element);
      });
      emit(GetDBState());
    });
  }

  Future<void> updateNote({
    required String title,
    required int id,
    required String time,
    required String date,
    required String note,
  }) async {
    if (imageFiles.isNotEmpty) {
      final directory = await getExternalStorageDirectory();
      if (directory != null) {
        final path = directory.path;
        final imagePaths = <String>[];
        for (final imageFile in imageFiles) {
          final file =
              File('$path/.${DateTime.now().millisecondsSinceEpoch}.jpg');
          await file.writeAsBytes(await imageFile.readAsBytes());
          imagePaths.add(file.path);
        }
        dataBase?.rawUpdate(
            'UPDATE note SET note = ? ,title = ?, date = ?, time = ?, image_paths = ? WHERE id = ? ',
            [note, title, date, time, imagePaths.join(','), id]).then(
          (value) async {
            emit(SuccessUpdateNoteWithImage());
            await getDateFromDB(dataBase);
          },
        );
      }
    }
    if (imageFiles.isEmpty) {
      dataBase?.rawUpdate(
          'UPDATE note SET note = ? ,title = ?, date = ?, time = ?, image_paths = ? WHERE id = ? ',
          [note, title, date, time, 'null', id]).then(
        (value) async {
          emit(SuccessUpdateNoteWithoutImage());
          await getDateFromDB(dataBase);
        },
      );
    }
  }

  void deleteDB({required int id}) {
    dataBase?.rawDelete('DELETE FROM note WHERE id =?', [id]).then((value) {
      getDateFromDB(dataBase);
      emit(DeleteDBState());
    });
  }

  List<File> imageFiles = [];

  Future<void> selectImages() async {

    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage(
      maxWidth: 800,
      maxHeight: 800,
    );
    imageFiles.addAll(
        pickedFiles.map((pickedFile) => File(pickedFile.path)).toList());
    emit(SuccessPutImages());
  }

  removeImages() {
    imageFiles = [];
    emit(Remove());
  }

  removeImage(file) {
    imageFiles.remove(file);
    emit(Remove());
  }
}
