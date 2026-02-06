import '../../../../data/datasources/mock_http_client.dart';
import '../../domain/entities/beneficiary.dart';
import '../../domain/repositories/beneficiary_repository.dart';
import '../datasources/beneficiary_local_data_source.dart';

class BeneficiaryRepositoryImpl implements BeneficiaryRepository {
  final MockHttpClient httpClient;
  final BeneficiaryLocalDataSource localDataSource;

  BeneficiaryRepositoryImpl({required this.httpClient, required this.localDataSource});

  @override
  Future<List<Beneficiary>> getBeneficiaries() async {
    final cachedBeneficiaries = localDataSource.getCachedBeneficiaries();
    if (cachedBeneficiaries != null && cachedBeneficiaries.isNotEmpty) {
      return cachedBeneficiaries;
    }

    try {
      final response = await httpClient.get('/api/beneficiaries');
      final data = response['data'];
      final List<Map<String, dynamic>> list = data is List
          ? (data).map<Map<String, dynamic>>((e) => e as Map<String, dynamic>).toList()
          : <Map<String, dynamic>>[];

      final beneficiaries = list.map(Beneficiary.fromJson).toList();

      if (beneficiaries.isNotEmpty) {
        await localDataSource.cacheBeneficiaries(beneficiaries);
      }
      return beneficiaries;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Beneficiary> addBeneficiary(Beneficiary beneficiary) async {
    try {
      final response = await httpClient.post('/api/beneficiaries', beneficiary.toJson());
      final newBeneficiary = Beneficiary.fromJson(response);
      await _addToCache(newBeneficiary);
      return newBeneficiary;
    } catch (e) {
      await _addToCache(beneficiary);
      return beneficiary;
    }
  }

  Future<void> _addToCache(Beneficiary beneficiary) async {
    final currentBeneficiaries = localDataSource.getCachedBeneficiaries() ?? [];
    await localDataSource.cacheBeneficiaries([...currentBeneficiaries, beneficiary]);
  }

  @override
  Future<void> deleteBeneficiary(String id) async {
    try {
      await httpClient.delete('/api/beneficiaries/$id');
    } catch (e) {
      // Continue to update cache even if remote fails
    } finally {
      await _removeFromCache(id);
    }
  }

  Future<void> _removeFromCache(String id) async {
    final currentBeneficiaries = localDataSource.getCachedBeneficiaries() ?? [];
    final updatedBeneficiaries = currentBeneficiaries.where((b) => b.id != id).toList();
    await localDataSource.cacheBeneficiaries(updatedBeneficiaries);
  }

  @override
  Future<void> cacheBeneficiaries(List<Beneficiary> beneficiaries) async {
    await localDataSource.cacheBeneficiaries(beneficiaries);
  }

  @override
  Future<Beneficiary> updateBeneficiary(Beneficiary beneficiary) async {
    try {
      final response = await httpClient.put('/api/beneficiaries/${beneficiary.id}', beneficiary.toJson());
      final updatedBeneficiary = Beneficiary.fromJson(response);
      await _updateInCache(updatedBeneficiary);
      return updatedBeneficiary;
    } catch (e) {
      await _updateInCache(beneficiary); // Update cache even if remote fails
      return beneficiary;
    }
  }

  Future<void> _updateInCache(Beneficiary beneficiary) async {
    final currentBeneficiaries = localDataSource.getCachedBeneficiaries() ?? [];
    final updatedBeneficiaries = currentBeneficiaries.map((b) {
      return b.id == beneficiary.id ? beneficiary : b;
    }).toList();
    await localDataSource.cacheBeneficiaries(updatedBeneficiaries);
  }

  @override
  Future<Beneficiary> updateBeneficiaryMonthlyAmount(String id, double amount) async {
    final beneficiaries = localDataSource.getCachedBeneficiaries() ?? [];
    final beneficiary = beneficiaries.firstWhere((b) => b.id == id);
    final updatedBeneficiary = beneficiary.copyWith(monthlyTopupAmount: beneficiary.monthlyTopupAmount + amount);

    await _updateInCache(updatedBeneficiary);

    try {
      final response = await httpClient.put('/api/beneficiaries/${updatedBeneficiary.id}', updatedBeneficiary.toJson());
      final apiUpdatedBeneficiary = Beneficiary.fromJson(response);
      await _updateInCache(apiUpdatedBeneficiary);
      return apiUpdatedBeneficiary;
    } catch (e) {
      return updatedBeneficiary;
    }
  }
}
