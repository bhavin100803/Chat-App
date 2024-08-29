class UnbordingContent {
  String image, title, desc;
  UnbordingContent({
    required this.image,
    required this.title,
    required this.desc,
  });
}

List<UnbordingContent> contents = [
  UnbordingContent(
    image: "assets/phone.png",
    title: "Cloud based\n messaging ",
    desc:
        "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable.",
  ),
  UnbordingContent(
    image: "assets/phone.png",
    title: "High Performance",
    desc:
        "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable.",
  ),
  UnbordingContent(
    image: "assets/phone.png",
    title: "Top-notch Security",
    desc:
        "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable.",
  ),
];
