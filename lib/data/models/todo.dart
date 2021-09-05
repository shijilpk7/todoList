import 'package:equatable/equatable.dart';

class Todo extends Equatable {
  String message;
  String status;

  Todo({required this.message, required this.status});
  get getMessage => this.message;

  get getStatus => this.status;

  @override
  String toString() {
    return '{ ${this.message}, ${this.status} }';
  }

  @override
  List<Object?> get props => [this.message, this.status];

  void setMessage(String message) {
    this.message = message;
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        'status': status,
      };

  void setStatus(String status) {
    this.status = status;
  }
}
