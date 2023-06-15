


class StringUtils{

  static String getOrdinal(int number) {
    String suffix;
    int mod10 = number % 10;
    int mod100 = number % 100;

    if (mod10 == 1 && mod100 != 11) {
      suffix = 'ˢᵗ';
    } else if (mod10 == 2 && mod100 != 12) {
      suffix = 'ⁿᵈ';
    } else if (mod10 == 3 && mod100 != 13) {
      suffix = 'ʳᵈ';
    } else {
      suffix = 'ᵗʰ';
    }

    return '$number$suffix';
  }


}