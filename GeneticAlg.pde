class GeneticAlg {
  
  NeuralNetwork bestBird = null;  //Gehirn des besten Vogel
  float bestFitness = 0;  //Bester Fitness wert

//Nächste Generation starten
void nextGeneration() {
  reset();  //Spiel resetten
  
  calcFitness();  //Fitness scores der Vögel berrechnen
  
  Generation++;
  //Neue Generation mit Vögeln füllen
  Bird[] tempBirds = new Bird[Population];
  //Wenn ein bester Vogel existiert, diesen Vogel unverändert der neuen Generation übergeben
  if(bestBird != null) {
    tempBirds[0] = new Bird(bestBird);
    tempBirds[0].isBest = true;  
  }else { //Wenn nicht: einen neuen Vogel erstellen
    tempBirds[0] = pickOne();
  }
  //Den Rest des Arrays mit Vögeln füllen
  for(int i = 1; i < Population; i++) {
    tempBirds[i] = pickOne();
  }
  birds = null;
  birds = tempBirds;
}

//Fitness berrechnen  (Wie viel Prozent ist der Score eines Vogels von der Summe aller erreichten Scores)
void calcFitness() {
  int sum = 0;
  for(Bird bird : birds) {
    sum += bird.score;
  }
  float currentBestFitness = 0;
  Bird currentBestBird = null;
  for(Bird bird : birds) {
    bird.fitness = (float)bird.score / (float)sum;
    if(bird.fitness > currentBestFitness) {
      currentBestFitness = bird.fitness;
      currentBestBird = bird;
    }
  }
  if(currentBestFitness > bestFitness) {
    bestFitness = currentBestFitness;
    
    bestBird = currentBestBird.brain.copyBrain();
  }
}

//Neuen Vogel züchten
Bird pickOne() {
  int index = 0;
  float ran = random(1);
  //einen Zufälligen Vogel der Generation wählen (Wahrscheinlichkeiten = fitness der Vögel)
  while(ran > 0 && index < birds.length) {
    ran = ran - birds[index].fitness;
    index++;
  }
  index--;
  
  Bird child = new Bird(birds[index].brain); //neuen Vogel mit dem Gehirn des Elternvogels erstellen
  child.mutate(0.1); //Gehirn des Kindes mutieren
  return child;
}
}
