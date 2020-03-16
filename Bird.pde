class Bird {
  
  float dy; // y Geschw
  float x, y; //x & y position
  boolean dead = false;
  
  boolean isBest = false;  //bester Vogel der Generation
  boolean aliveRep = false;  //überlebender wenn der beste schon tot ist
  
  NeuralNetwork brain; //Gehirn
  
  int score; //spiel-score
  float fitness; //fitness wert zum rechnen
  
  Bird(float x, float y) {
    this.x = x;
    this.y = y;
    //inputs: yVel, y, xOffsetNextPipe, yOffsetTopPipe, yOffsetBottomPipe
    brain = new NeuralNetwork(5, 6, 2);
  }
  
  Bird(NeuralNetwork brain) {
    this.x = 100;
    this.y = height / 2;
    //inputs: yVel, y, xOffsetNextPipe, yOffsetTopPipe, yOffsetBottomPipe
    this.brain = brain.copyBrain();
  }
  
  // nächste Bewegung berrechnen
  void think() {
    //nächste Röhre berrechnen
    PipePair closest = null;
    float closestDx = gameWidth * 2;
    for(PipePair p : pipePairs) {
      if(p.topPipe.x + p.topPipe.pipeWidth - x < closestDx) {
        closestDx = p.topPipe.x + p.topPipe.pipeWidth - x;
        closest = p;
      }
    }
    
    //zeige Dev informationen 
    if(DEV) {
    closest.red = true;
    if(isBest || aliveRep) {
      fill(100,0,0);
      line(x,y,closest.topPipe.x,y);
      text("Y:" + (y / height), x, y - 50);
      text("VY:" + (dy / 10), x, y - 20);
      line(x,y,x,closest.topPipe.bottomY);
      line(x,y,x,closest.bottomPipe.topY);
      text("DYT:" + ((closest.topPipe.bottomY - y) / height), x, y + 50);
      text("DYB:" + ((closest.bottomPipe.topY - y) / height), x, y + 20);
      text("DXC:" + ((closest.bottomPipe.x - x) / gameWidth), x, y + 80);
    }
    }
    
    //Inputs für das Neuronale Netzwerk erstellen
    float[] inputs = new float[5];
    inputs[0] = dy / 10;
    inputs[1] = y / height;
    inputs[2] = (closest.topPipe.x - x) / gameWidth;
    inputs[3] = (closest.topPipe.bottomY - y) / height;
    inputs[4] = (closest.bottomPipe.topY - y) / height;
    
    //das Netzwerk fragen
    float[] output = brain.predict(inputs);
    //wenn das Netwerk springen sagt (output[0]) hochfliegen
    if(output[0] > output[1]) {
      up();
    }
  }
  
  //Zeichne den Vogel
  void show() {
    stroke(255);
    if(isBest)
      fill(74,255,0);
    else
      fill(255, 255, 0, 100);
    ellipse(x, y, birdSize, birdSize);
    
    //Zeichne das Gehirn des Vogels
    if(isBest || aliveRep) {
      String[] in = {"Y Geschw", "Y Pos", "Dist zur nächsten Pipe", "Dist zur oberen Pipe", "Dist zur unteren Pipe"};
      String[] out = {"Springen", "Fallen"};
      brain.show(in, out);
    }
  }
  
  //Physik
  void update() {
    score++;
    
    dy += Gravity;
    y += dy;
    y = constrain(y, 0, height);
    think();
  }
  
  void up() {
    dy = boostSpeed;
  }
  
  //Gehirn mutieren
  void mutate(float rate) {
    brain.mutate(rate);
  }
}
