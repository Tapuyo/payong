class AgriAdvModel {
  final String title;
  final String content;
  final List<AgriAdImgvModel> img;

  AgriAdvModel(
      this.title,
      this.content,
      this.img);
}

class AgriAdImgvModel {
  final String img;

  AgriAdImgvModel(
      this.img);
}
