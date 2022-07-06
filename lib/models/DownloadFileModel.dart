class DownloadFileModel {
  int? fileKey;
  String? fileType;
  String? fileName;
  String? content;
  DownloadFileModel();

  DownloadFileModel.fromJson(Map<String, dynamic> json) {
    this.fileKey = json['fileKey'];
    this.fileType = json['fileType'];
    this.fileName = json['fileName'];
    this.content = json['Content'];
  }
}
