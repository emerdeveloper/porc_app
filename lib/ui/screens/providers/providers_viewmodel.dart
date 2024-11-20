import 'dart:developer';

import 'package:porc_app/core/enums/enums.dart';
import 'package:porc_app/core/models/providers_model.dart';
import 'package:porc_app/core/models/user_model.dart';
import 'package:porc_app/core/other/base_viewmodel.dart';
import 'package:porc_app/core/services/database_providers_service.dart';

class ProvidersViewmodel extends BaseViewmodel {
  final DatabaseProvidersService _db;

  ProvidersViewmodel(this._db) {
    fetchAllProvidersWithPigFeed();
  }

  List<ProviderModel> _providers = [];
  List<String> _providersName = [];
  List<String> _pigFeeds = [];
  String? _selectedProvider;

  List<ProviderModel> get providers => _providers;
  List<String> get providersName => _providersName;
  List<String> get pigFeeds => _pigFeeds;
  String? get selectedProvider => _selectedProvider;

  List<bool> _expanded = [];
  List<bool> get expanded => _expanded;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  fetchAllProvidersWithPigFeed() async {
    try {
      _isLoading = true;
      setstate(ViewState.loading);

      final res = await _db.fetchAllProvidersWithPigFeed();

      if (res != null) {
        log("Sucessfully providers");
        _providers = res.map((e) => ProviderModel.fromMap(e)).toList();
        _expanded = List.generate(_providers.length, (_) => false);
        _providersName = _providers.map((e) => e.name).toList();
        selectProvider(providersName.first);
        //notifyListeners();
      }
      //setstate(ViewState.idle);
    } catch (e) {
      //setstate(ViewState.idle);
      log("Error Fetching providers: $e");
    } finally {
      _isLoading = false;
      setstate(ViewState.idle);
      notifyListeners();
    }
  }
  void selectProvider(String? providerName) {
    _selectedProvider = providerName;
    // Buscar el proveedor seleccionado
    final provider = _providers.firstWhere(
      (p) => p.name == providerName,
      orElse: () => ProviderModel(
      id: '',
      name: 'Desconocido',
      owner: 'Desconocido',
      pigFeed: [],
    ),
    );
    // Actualizar los alimentos según el proveedor seleccionado
    _pigFeeds = provider.pigFeed.map((feed) => "${feed.name} - ${feed.price}").toList();
    notifyListeners();
  }


  void toggleExpanded(int index) {
    _expanded[index] = !_expanded[index];
    notifyListeners();
  }
}