import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/categoria_fb.dart';

class CategoriaService {
  static final _ref = FirebaseFirestore.instance.collection('categorias');

  static Stream<CategoriaFb?> watchCategoriaById(String id) {
    return _ref.doc(id).snapshots().map((doc) {
      if (doc.exists) {
        return CategoriaFb.fromMap(doc.id, doc.data()!);
      }
      return null;
    });
  }

  /// Obtiene todas las categorías
  static Future<List<CategoriaFb>> getCategorias() async {
    final snapshot = await _ref.get();
    return snapshot.docs
        .map((doc) => CategoriaFb.fromMap(doc.id, doc.data()))
        .toList();
  }

  /// Agrega una nueva categoría
  static Future<void> addCategoria(CategoriaFb categoria) async {
    await _ref.add(categoria.toMap());
  }

  /// Actualiza una categoría existente
  static Future<void> updateCategoria(CategoriaFb categoria) async {
    await _ref.doc(categoria.id).update(categoria.toMap());
  }

  /// Obtiene una categoría por su ID
  static Future<CategoriaFb?> getCategoriaById(String id) async {
    final doc = await _ref.doc(id).get();
    if (doc.exists) {
      return CategoriaFb.fromMap(doc.id, doc.data()!);
    }
    return null;
  }

  /// Elimina una categoría
  static Future<void> deleteCategoria(String id) async {
    await _ref.doc(id).delete();
  }

  //!/ Observa los cambios en la colección de categorías
  /// y devuelve una lista de categorías actualizada
  static Stream<List<CategoriaFb>> watchCategorias() {
    return _ref.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => CategoriaFb.fromMap(doc.id, doc.data()))
          .toList();
    });
  }
}
