import 'package:clean_architecture_demo/data/network/failure.dart';
import 'package:clean_architecture_demo/domain/entity/todo_entity.dart';
import 'package:clean_architecture_demo/domain/repository/todo_repository.dart';
import 'package:clean_architecture_demo/domain/usecase/usecase.dart';
import 'package:either_dart/either.dart';

class DeleteTodoUseCase implements UseCase<bool, TodoEntity> {
  final TodoRepository _todoRepository;

  DeleteTodoUseCase(this._todoRepository);

  @override
  Future<Either<Failure, bool>> execute(TodoEntity todoEntity) {
    return _todoRepository.deleteTodo(todoEntity);
  }
}
