class FailMessage {
  final String message;

  FailMessage([this.message = "une erreur inattendue s'est produite"]);

  @override
  String toString() {
    return 'FailMessage(message: $message)';
  }
}

class SuccessMessage {
  final String message;

  SuccessMessage(this.message);
}
