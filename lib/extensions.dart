extension ExactUserNameFromEmail on String {
  String toUsername() {
    List<String> parts = this.split('@');
    String username = parts[0];
    if (username.length > 10) {
      return username.substring(0, 10);
    }
    return username;
  }
}
