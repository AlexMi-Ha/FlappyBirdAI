//Variablen für das Spiel
float Gravity = 1;
float boostSpeed = -10;
float birdSize = 16;
float scrollSpeed = 5;
final int gameWidth = 550;

PipePair[] pipePairs;

//Variablen für die KI und Genetic Algorithm
int fitnessDisplay = 0; //Score display für den Fitness-score

boolean DEV = false;  //dev infos anzeigen
boolean showBestOnly = false;  //nur den besten Zeigen
int cycles = 1;  //Geschw. des Spiels

int Generation = 0;  //Generation der Entwicklung
GeneticAlg ga;  //Genetic Algorithm
final int Population = 1000;

Bird[] birds;  //alle vögel

//setup wird beim Start des programms aufgerufen 
void setup() {
  size(750, 600);
  
  ga = new GeneticAlg();
  
  birds = new Bird[Population];
  for(int i = 0; i < Population; i++)
    birds[i] = new Bird(100, height / 2);
  
  reset();
  
  ellipseMode(CENTER);
}

void reset() {
  pipePairs = new PipePair[2];
  pipePairs[0] = new PipePair();
  pipePairs[1] = new PipePair(gameWidth + gameWidth / 2 + pipePairs[0].topPipe.pipeWidth * 2);
}


//draw wird jeden Tick aufgerufen
void draw() {
  background(135, 206, 250);
  
  for(int n = 0; n < cycles; n++) { // <cycles> aufrufe pro Tick
    //Physik berechnung für alle lebenden Vögel der Population  
    for(Bird bird : birds) {
      if(!bird.dead)
        bird.update();
      for(PipePair p : pipePairs) {
        if(p.collide(bird))
          bird.dead = true;
      }
    }
  
    //sind alle Vögel tot?
    boolean allDead = true;
    for(Bird bird : birds) {
      if(!bird.dead) {
        allDead = false;
        break;
      }
    }
    //wenn ja: Starte die nächste Generation 
    if(allDead) 
      ga.nextGeneration();
 
    //update alle Röhren
    for(PipePair p : pipePairs)
      p.update();
  }
  
  //Update Grafik (nur jeden Tick)
 
  //pipes
  for(PipePair p : pipePairs) {
    p.show();
    p.red = false;
  }
  
  //info panel
  stroke(0);
  fill(80);
  rect(gameWidth - 70, 0, width - gameWidth + 70, 180);
  fill(50);
  rect(gameWidth - 70, 180, width - gameWidth + 70, height - 181);
  
  //zeichne alle Vögel
  for(Bird bird : birds) {
    if(showBestOnly && (bird.isBest || bird.aliveRep)) {  //zeige nur den besten
      if(!bird.dead)
        bird.show();
    }
    if(bird.isBest || bird.aliveRep) {  //zeige den Fitness score des besten
      if(bird.score >= fitnessDisplay && !bird.dead)
        fitnessDisplay = (int)bird.score;
    }
    if(!showBestOnly) { //zeige alle anderen Vögel
      if(!bird.dead)
        bird.show();
    }
  }
  
  //Info texte
  textSize(12);
  fill(255);
  text("Steuerungen:", gameWidth - 50, height / 3 + 10);
  text("Geschwindigkeit: " + cycles + "  ( P -> +  |  M -> - )", gameWidth - 50, height / 3 + 10 + 30);
  text("D -> Erweiterte Informationen (AN / AUS)", gameWidth - 50, height / 3 + 40 + 30);
  text("B -> Zeige nur besten der Generation \n(AN / AUS)", gameWidth - 50, height / 3 + 70 + 30);
  text("S -> Beste KI speichern", gameWidth - 50, height / 3 + 120 + 30);
  text("L -> Gespeicherte KI laden", gameWidth - 50, height / 3 + 150 + 30);
  text("Beste Fitness: " + fitnessDisplay, gameWidth - 50, height / 3 + 200 + 30);
  
  textAlign(RIGHT);
  text("Generation: " + Generation, width - 10, 170);
  textAlign(LEFT);
  textSize(20);
  boolean allDead = true;
  for(Bird bird : birds) {
    if(!bird.dead) {
      allDead = false;
      fill(255);
      bird.aliveRep = true;
      text("Fitness: " + bird.score, 10, 40);
      break;
    }
  }
}

//Speichere das Gehirn des besten Vogels
void saveBest() {
  int res = javax.swing.JOptionPane.showConfirmDialog(null, "Besten speichern und alten besten überschreiben?");
  if(res == 0) {
    for(Bird bird : birds) {
      if(bird.isBest || bird.aliveRep) {
        Matrix.Save(bird.brain.ihWeights, "ihWeights");
        Matrix.Save(bird.brain.hoWeights, "hoWeights");
        Matrix.Save(bird.brain.hBias, "hBias");
        Matrix.Save(bird.brain.oBias, "oBias");
      }
    }
  }
}

//Lade das Gehirn des gespeicherten Besten
void loadBest() {
  ga = new GeneticAlg();
  
  birds = new Bird[Population];
  for(int i = 0; i < Population; i++) {
    birds[i] = new Bird(100, height / 2);
  }
  
  Bird bird = birds[0];

  bird.brain.ihWeights = Matrix.Load("ihWeights", bird.brain.ihWeights.rows, bird.brain.ihWeights.cols);
  bird.brain.hoWeights = Matrix.Load("hoWeights", bird.brain.hoWeights.rows, bird.brain.hoWeights.cols);
  bird.brain.hBias = Matrix.Load("hBias", bird.brain.hBias.rows, bird.brain.hBias.cols);
  bird.brain.oBias = Matrix.Load("oBias", bird.brain.oBias.rows, bird.brain.oBias.cols);
  
  reset();
}

//Überprüfe alle Key-presses
void keyPressed() {
  switch(key) {
    case 'p':
      if(cycles < 200)
        cycles += 1;
      if(cycles <= 0)
        cycles = 1;
      break;
    case 'm':
      cycles -= 1;
      break;
    case 'd':
      DEV = !DEV;
      break;
    case 'b':
      showBestOnly = !showBestOnly;
      break;
    case 's':
      saveBest();
      break;
    case 'l':
      loadBest();
      break;
  }
  
  if(cycles <= 0) 
    noLoop(); //pause
  else
    loop(); //keine pause
}
