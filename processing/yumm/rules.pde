
void makeMapBase3(int[][][] map, String rule) {
  if (rule.length() == 27 && rule.matches("[012]*")) {
    for (int i = 26; i >= 0; i--) {
      int left = floor(i / 9);
      int mid = floor((i / 3)) % 3;
      int right = i % 3;
      map[left][mid][right] = int(rule.substring(i, i + 1));
    }
    println("\n" + mapString(map));
  } else {
    println("rule does not match [012]* and/or is not 27 digits long.");
  }
}

String mapString(int[][][] map) {
  String ret = "";
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      for (int k = 0; k < 3; k++) {
        ret += map[i][j][k];
      }
    }
  }
  return ret;
}
