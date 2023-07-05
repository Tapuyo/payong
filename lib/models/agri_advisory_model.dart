class AgriAdvModel {
  final String title;
  final String content;
  final List<AgriAdImgvModel> img;
  final List<String> linkImg;
  final String datePublish;
  final String dateValid;

  AgriAdvModel(
      this.title,
      this.content,
      this.img,
      this.linkImg,
      this.datePublish,
      this.dateValid);
}

class AgriAdImgvModel {
  final String img;

  AgriAdImgvModel(
      this.img);
}
