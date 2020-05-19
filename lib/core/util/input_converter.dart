import 'package:Reso_venue/core/errors/failures.dart';
import 'package:Reso_venue/core/localizations/messages.dart';
import 'package:dartz/dartz.dart';
import 'package:validators/sanitizers.dart';
import 'package:validators/validators.dart';

class InputConverter {

  bool isValidId(String uuid) {
    return isUUID(uuid);
  }

  Either<Failure, String> parseEmail(String input) {
    if (isNull(input)) {
      return Left(InvalidInputFailure(message: Messages.NULL_EMAIL_INPUT));
    }
    var email = trim(input);
    if (isEmail(email)) {
      if (isLength(email, 5, 149)) {
        return Right(normalizeEmail(email));
      } else {
        return Left(InvalidInputFailure(message: Messages.INVALID_LENGTH_EMAIL));
      }
    } else {
      return Left(InvalidInputFailure(message: Messages.INVALID_EMAIL_INPUT));
    }
  }

  Either<Failure, String> parsePassword(String input) {
    if (isNull(input)) {
      return Left(InvalidInputFailure(message: Messages.NULL_PASSWORD_INPUT));
    }
    if (isLength(input, 8, 150)) {
      return Right(input);
    }
    return Left(InvalidInputFailure(message: Messages.INVALID_LENGTH_PASSWORD_INPUT));
  }

  Map<String, String> validateLoginForm(String email, String password) {
    final emailMessage = parseEmail(email);
    final passwordMessage = parsePassword(password);
    final Map<String, String> messages = Map<String, String>.from({});
    emailMessage.fold((failure) => {
      messages["email"] = failure.message
    }, (r) => {});
    passwordMessage.fold((failure) => {
      messages["password"] = failure.message
    }, (r) => {});
    return messages;
  }

  Either<Failure, bool> validateTimeSlotForm(DateTime start, DateTime stop) {
    if (stop.compareTo(start) > 0 && start.compareTo(DateTime.now()) > 0){
      return Right(true);
    } else {
      return Left(InvalidInputFailure(message: Messages.INVALID_ORDER));
    }
  }
  
}
