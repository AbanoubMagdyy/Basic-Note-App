abstract class AddNotesStates {}

class InitState extends AddNotesStates {}

class CreateDBState extends AddNotesStates {}

class InsertDBWithImagesState extends AddNotesStates {}

class InsertDBWithoutImagesState extends AddNotesStates {}

class GetDBState extends AddNotesStates {}

class DeleteDBState extends AddNotesStates {}

class SuccessPutImages extends AddNotesStates {}

class ErrorPutImages extends AddNotesStates {}

class Remove extends AddNotesStates {}

class SuccessUpdateNoteWithImage extends AddNotesStates {}

class SuccessUpdateNoteWithoutImage extends AddNotesStates {}
