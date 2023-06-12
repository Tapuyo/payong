class AgriAdvModel {
  final String title;
  final String content;
  final List<AgriAdImgvModel> img;
  final List<String> linkImg;

  AgriAdvModel(
      this.title,
      this.content,
      this.img,
      this.linkImg);
}

class AgriAdImgvModel {
  final String img;

  AgriAdImgvModel(
      this.img);
}
