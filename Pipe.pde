class Pipe {

  int pipeWidth = 50;
  int pipeHeight;
  float x = gameWidth + pipeWidth;
  float topY, bottomY;
  
  boolean isTop;
  
  Pipe(boolean isTop, int pipeHeight) {
    this.pipeHeight = pipeHeight;
    this.isTop = isTop;
    if(isTop) {
      topY = 0;
      bottomY = this.pipeHeight;
    }else {
      topY = height - this.pipeHeight;
      bottomY = height;
    }
  }
  
  //Zeichne die Röhre
  void show() {
    stroke(0);
    rect(x, topY, pipeWidth, pipeHeight);
  }
  
  void update() {
    x -= scrollSpeed;
  }
  // Berührt der Vogel diese Röhre?
  boolean collide(Bird b) {
    if(b.x + birdSize > x && b.x - birdSize < x + pipeWidth) {
      if(!isTop && b.y + birdSize / 2 >= topY) {
        return true;
      }
      if(isTop && b.y - birdSize / 2 <= bottomY) {
        return true;
      }
    }
    return false;
  }
}
