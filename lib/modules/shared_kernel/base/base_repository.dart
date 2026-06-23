/// Contrato base para repositórios.
abstract class BaseRepository<T> {
  /// Salva a entidade [T].
  Future<void> save(T entity);
}