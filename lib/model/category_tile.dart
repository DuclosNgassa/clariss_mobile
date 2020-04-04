class CategoryTile {
  String title;
  String icon;
  int id;
  int parentid;
  List<CategoryTile> children;

  CategoryTile(this.title, this.id);
}
