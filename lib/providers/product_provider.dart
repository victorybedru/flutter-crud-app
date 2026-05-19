import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_api_service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductApiService _apiService = ProductApiService();
  
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  List<String> _categories = [];
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isLoading = false;
  bool _isGridView = true;
  String? _errorMessage;
  
  List<Product> get products => _filteredProducts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<String> get categories => _categories;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get isGridView => _isGridView;

  // Fetch all products
  Future<void> fetchProducts() async {
    _setLoading(true);
    _clearError();
    
    try {
      _allProducts = await _apiService.getProducts();
      _categories = await _apiService.getCategories();
      _categories.insert(0, 'All');
      _applyFilters();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Create product
  Future<bool> createProduct(Product product) async {
    _setLoading(true);
    _clearError();
    
    try {
      final newProduct = await _apiService.createProduct(product);
      _allProducts.insert(0, newProduct);
      _applyFilters();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update product
  Future<bool> updateProduct(int id, Product product) async {
    _setLoading(true);
    _clearError();
    
    try {
      final updatedProduct = await _apiService.updateProduct(id, product);
      final index = _allProducts.indexWhere((p) => p.id == id);
      if (index != -1) {
        _allProducts[index] = updatedProduct;
        _applyFilters();
      }
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Delete product
  Future<bool> deleteProduct(int id) async {
    _setLoading(true);
    _clearError();
    
    try {
      await _apiService.deleteProduct(id);
      _allProducts.removeWhere((product) => product.id == id);
      _applyFilters();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Search products
  void searchProducts(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  // Filter by category
  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  // Toggle view mode
  void toggleViewMode() {
    _isGridView = !_isGridView;
    notifyListeners();
  }

  // Apply both search and filter
  void _applyFilters() {
    _filteredProducts = _allProducts.where((product) {
      // Apply category filter
      if (_selectedCategory != 'All' && product.category != _selectedCategory) {
        return false;
      }
      
      // Apply search filter
      if (_searchQuery.isNotEmpty) {
        return product.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               product.description.toLowerCase().contains(_searchQuery.toLowerCase());
      }
      
      return true;
    }).toList();
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}