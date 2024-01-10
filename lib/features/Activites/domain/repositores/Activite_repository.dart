import 'package:dartz/dartz.dart';
import 'package:SunShine/core/error/failures.dart';
import 'package:SunShine/features/Activites/domain/entites/activite.dart';

abstract class ActiviteRepository {
  Future<Either<Failure, List<Activite>>> getAllActivites();
  Future<Either<Failure, Unit>> deletActivite(String id);
  Future<Either<Failure, Unit>> updateActivites(Activite activitie);
  Future<Either<Failure, Unit>> addActivites(Activite activitie);
}
