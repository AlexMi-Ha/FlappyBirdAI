class PipePair {
  int gap = 150;
  int topHeight;
  int bottomHeight;
  boolean red = false;
  
  Pipe bottomPipe, topPipe;
  
  PipePair() {
    topHeight = floor(random(20, height - 100 - gap));
    bottomHeight = height - topHeight - gap;
    bottomPipe = new Pipe(false, bottomHeight);
    topPipe = new Pipe(true, topHeight);
  }
  
  PipePair(float startX) {
    topHeight = floor(random(20, height - 100 - gap));
    bottomHeight = height - topHeight - gap;
    bottomPipe = new Pipe(false, bottomHeight);
    topPipe = new Pipe(true, topHeight);
    
    bottomPipe.x = startX;
    topPipe.x = startX;
  }

  //Zeichne das Röhren paar
  void show() {
    if(red)
      fill(255,1,6);
    else
      fill(0, 210, 0);
    bottomPipe.show();
    topPipe.show();
  }
  
  //Update das Röhren paar
  void update() {
    bottomPipe.update();
    topPipe.update();
    
    if(offScreen()) {
      topHeight = floor(random(20, height - 100 - gap));
      bottomHeight = height - topHeight - gap;
      bottomPipe = new Pipe(false, bottomHeight);
      topPipe = new Pipe(true, topHeight);
    }
  }
  
  boolean offScreen() {
    if(bottomPipe.x + bottomPipe.pipeWidth < 0) {
      return true;
    }
    return false;
  }
  
  boolean collide(Bird b) {
    return bottomPipe.collide(b) || topPipe.collide(b);
  }

}
