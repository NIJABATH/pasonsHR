import 'package:localstorage/localstorage.dart';
import 'package:pasons_HR/services/i_local_storage_repository.dart';

class LocalStorageRepository implements ILocalStorageRepository {
  final LocalStorage _storage;

  LocalStorageRepository(String storageKey)
      : _storage = LocalStorage(storageKey);

  @override
  Future getAll(String key) async {
    await _storage.ready;

    return _storage.getItem(key);
  }

  @override
  Future<void> save(String key, dynamic value) async {
    await _storage.ready;

    return _storage.setItem(key, value);
  }
}