import 'package:zenify_app/features/profile/domain/entity/user.dart';
import 'package:zenify_app/features/profile/domain/repository/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:zenify_app/core/error/failures.dart';

class AddUserUseCase {
  final UserRepository userRepository;

  AddUserUseCase( this.userRepository);
  Future<Either<Failure, Unit>> call( User user) async {
    return await userRepository.addUser( user);
  }
}
