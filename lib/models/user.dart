class User {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final String alpacaId;
  final String alpacaKey;
  final String image;

  User(
      {this.image,
      this.uid,
      this.firstName,
      this.lastName,
      this.alpacaId,
      this.alpacaKey,
      this.email});
}
