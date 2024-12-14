import '../models/financial_models.dart'; // Pastikan ini mengarah ke model yang benar

class ExpenseCategoryGraph {
  // Struktur data untuk menyimpan hubungan antar kategori
  final Map<String, List<String>> _connections = {};

  // Menambahkan koneksi antara dua kategori
  void addConnection(String category1, String category2) {
    _connections.putIfAbsent(category1, () => []).add(category2);
    _connections.putIfAbsent(category2, () => []).add(category1);
  }

  // Mendapatkan koneksi untuk kategori tertentu
  List<String> getConnections(String category) {
    return _connections[category] ?? [];
  }

  // Mencari area pengurangan biaya berdasarkan transaksi
  List<String> findCostReductionAreas(List<TransactionModel> transactions) {
    // Menghitung total pengeluaran per kategori
    Map<String, double> categorySpending = {};

    for (var transaction in transactions) {
      categorySpending[transaction.category] = 
          (categorySpending[transaction.category] ?? 0) + transaction.amount;
    }

    // Mengidentifikasi kategori dengan pengeluaran tertinggi
    var sortedCategories = categorySpending.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Mengembalikan kategori dengan pengeluaran tertinggi sebagai area pengurangan biaya
    return sortedCategories.map((entry) => entry.key).toList();
  }
}