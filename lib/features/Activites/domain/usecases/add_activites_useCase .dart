import 'package:dartz/dartz.dart';
import 'package:SunShine/core/error/failures.dart';
import 'package:SunShine/features/Activites/domain/entites/activite.dart';
import 'package:SunShine/features/Activites/domain/repositores/Activite_repository.dart';
import 'package:SunShine/features/notification/domain/entites/notification.dart';
import 'package:SunShine/features/notification/domain/repositores/notification_repostory.dart';

class AddActiviteUseCase {
  final ActiviteRepository activiteRepository;

  AddActiviteUseCase(this.activiteRepository);
  Future<Either<Failure, Unit>> call(Activite activite) async {
    return await activiteRepository.addActivites(activite);
  }
}
