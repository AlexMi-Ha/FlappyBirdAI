//Sigmoid activation function
float sigmoid(float x) {
  return 1 / (1 + (float)Math.exp(-x));
}

class NeuralNetwork {
  int inputNodes, hiddenNodes, outputNodes; //Anzahl der input, hidden & output Neuronen
  
  Matrix ihWeights, hoWeights, hBias, oBias, input, hidden, output; //Werte der Verbindungen der Neuronen
  
  //Netzwerk werte kopieren
  NeuralNetwork(NeuralNetwork copy) {
    inputNodes = copy.inputNodes;
    hiddenNodes = copy.hiddenNodes;
    outputNodes = copy.outputNodes;
    
    ihWeights = copy.ihWeights.copyMatrix();
    hoWeights = copy.hoWeights.copyMatrix();
    hBias = copy.hBias.copyMatrix();
    oBias = copy.oBias.copyMatrix();
  }
  
  //Neues Netzwerk
  NeuralNetwork(int input, int hidden, int output) {
    inputNodes = input;
    hiddenNodes = hidden;
    outputNodes = output;
    
    //Zufällige Verbindungen
    ihWeights = Matrix.Random(hiddenNodes, inputNodes);
    hoWeights = Matrix.Random(outputNodes, hiddenNodes);
    hBias = Matrix.Random(hiddenNodes, 1);
    oBias = Matrix.Random(outputNodes, 1);
  }
  
  //dieses Netzwerk kopieren
  NeuralNetwork copyBrain() {
    return new NeuralNetwork(this);
  }
  
  //Wert zufällig mutieren
  private float mut(float val, float mutationRate) {
    if((float) Math.random() < mutationRate) {
      float r = randomGaussian()*0.1;
      return val + r;
    }else
      return val;
  }
  
  //Werte der Verbindungen mutieren
  void mutate(float rate) {
    for (int i = 0; i < ihWeights.rows; i++){
      for (int j = 0; j < ihWeights.cols; j++){
        float val = ihWeights.values[i][j];
        ihWeights.values[i][j] = mut(val, rate);
      }
    }
    
    for (int i = 0; i < hoWeights.rows; i++){
      for (int j = 0; j < hoWeights.cols; j++){
        float val = hoWeights.values[i][j];
        hoWeights.values[i][j] = mut(val, rate);
      }
    }
    
    for (int i = 0; i < hBias.rows; i++){
      for (int j = 0; j < hBias.cols; j++){
        float val = hBias.values[i][j];
        hBias.values[i][j] = mut(val, rate);
      }
    }
    
    for (int i = 0; i < oBias.rows; i++){
      for (int j = 0; j < oBias.cols; j++){
        float val = oBias.values[i][j];
        oBias.values[i][j] = mut(val, rate);
      }
    }
  }
  
  //Ausgangswert berrechnen
  float[] predict(float[] inputArray) {
    input = Matrix.fromArray(inputArray); //Input array in Matrix umformen
    
    hidden = Matrix.Product(ihWeights, input); //Produkt aus den Gewichten zwischen input und hidden Neuronen und dem input
    hidden.mAdd(hBias); //Bias des Hidden Layers dazu addieren
    
    //Alle Werte des Ausgangs der Hidden Neuronen durch die Activation function (sigmoid) führen
    for(int i = 0; i < hidden.rows; i++) {
      for(int j = 0; j < hidden.cols; j++) {
        float val = hidden.values[i][j];
        hidden.values[i][j] = sigmoid(val);
      }
    }
    
    output = Matrix.Product(hoWeights, hidden); //Produkt aus den Gewichten zwischen hidden und output Neuronen und dem Ausgang der Hidden Neuronen
    output.mAdd(oBias); //Bias des output Layers dazu addieren
    
    //Alle Werte durch die Activation function führen
    for(int i = 0; i < output.rows; i++) {
      for(int j = 0; j < output.cols; j++) {
        float val = output.values[i][j];
        output.values[i][j] = sigmoid(val);
      }
    }
    //Array representation aus der Matrix zurückgeben
    return output.toArray();
  }
  
  
  //Neuronales Netzwerk visualisieren
  //(Kein schöner Code aber es funktioniert)
  void show(String[] inputText, String[] outputText) {
    pushMatrix(); // Koordinaten Ursprungs verschiebungen werden nicht gespeichert
    int xBoxSize = 250;
    int yBoxSize = 180;
    translate(width - xBoxSize + 10, 0); // Ursprung auf die rechte obere Ecke verschieben
    fill(30);
    int size = 10;
    
    float weightThreshold = 0; // Test only
    
    //Alle Weights zeichnen
    float dy = 30;
    int x = xBoxSize / 2 - 40;
    for(int yi = 0; yi < inputNodes; yi++) {
      for(int yh = 0; yh < hiddenNodes; yh++) {
        //Farbe & Transparenz der Verbindung der Stärke der Verbindung anpassen
        if(ihWeights.values[yh][yi] > weightThreshold)
          stroke(10, 17, 164, abs(ihWeights.values[yh][yi] * 255));
        else if(ihWeights.values[yh][yi] < -weightThreshold)
          stroke(245,60,60, abs(ihWeights.values[yh][yi] * 255));
        else
          continue;
        line(x,(yi + 1) * dy + (yBoxSize-(dy * (inputNodes - 1) + inputNodes * size)) / 2 - 5, x + 40, (yh + 1) * dy + (yBoxSize-(dy * (hiddenNodes - 1) + hiddenNodes * size)) / 2);
      }
    }
    x += 40;
    for(int yh = 0; yh < hiddenNodes; yh++) {
      for(int yo = 0; yo < outputNodes; yo++) {
        //Farbe & Transparenz der Verbindung der Stärke der Verbindung anpassen
        if(hoWeights.values[yo][yh] > weightThreshold)
          stroke(10, 17, 164, abs(hoWeights.values[yo][yh] * 255));
        else if(hoWeights.values[yo][yh] < -weightThreshold)
          stroke(245,60,60, abs(hoWeights.values[yo][yh] * 255));
        else
          continue;
        line(x,(yh + 1) * dy + (yBoxSize-(dy * (hiddenNodes - 1) + hiddenNodes * size)) / 2, x + 40,(yo + 1) * dy + (yBoxSize-(dy * (outputNodes - 1) + outputNodes * size)) / 4 + 12);
      }
    }
    
    stroke(25);
    
    //Input Neuronen Zeichnen
    
    x = xBoxSize / 2 - 40;
    textSize(10);
    textAlign(RIGHT);
    float dotScaling = 1;
    for(int y = 0; y < inputNodes; y++) {
      fill(240);
      ellipse(x, (y + 1) * dy + (yBoxSize-(dy * (inputNodes - 1) + inputNodes * size)) / 2 - 5, size * dotScaling, size * dotScaling);
      //fill(0);
      text(inputText[y] + "", x - 5, (y + 1) * dy + (yBoxSize-(dy * (inputNodes - 1) + inputNodes * size)) / 2 - 2);
    }
    
    //Hidden Neuronen Zeichnen
    x += 40;
    fill(240);
    for(int y = 0; y < hiddenNodes; y++) {
      ellipse(x, (y + 1) * dy + (yBoxSize-(dy * (hiddenNodes - 1) + hiddenNodes * size)) / 2, size * dotScaling, size * dotScaling);
    }
    
    //Output Neuronen Zeichnen
    textAlign(LEFT);
    x += 40;
    for(int y = 0; y < outputNodes; y++) {
      fill(240);
      ellipse(x,(y + 1) * dy + (yBoxSize-(dy * (outputNodes - 1) + outputNodes * size)) / 4 + 12, size* dotScaling, size * dotScaling);
     // fill(0);
      text(outputText[y] + "", x + 10,(y + 1) * dy + (yBoxSize-(dy * (outputNodes - 1) + outputNodes * size)) / 4 + 15);
    }
    popMatrix();  //Alten Ursprung (oben links) wiederherstellen
    textSize(20);
    
  }
  
}
