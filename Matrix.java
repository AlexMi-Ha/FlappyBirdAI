import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Scanner;
import java.io.FileReader;
import java.io.BufferedReader;

public class Matrix {
  
  int rows, cols;
  float[][] values;
  
  // Neue Matrix mit der Größe rows * cols
  Matrix(int rows, int cols) {
    this.rows = rows;
    this.cols = cols;
    values = new float[this.rows][this.cols];
  }
  
  // Neue Matrix der Größe 1 * 1
  Matrix() {
    rows = 1;
    cols = 1;
    values = new float[rows][cols];
  }
  
  // vorhandene Matrix kopieren
  Matrix copyMatrix() {
     Matrix result = new Matrix(rows, cols);
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        result.values[i][j] = values[i][j];
      }
    }
    return result;
  }
  
  //Neue Zufällige Matrix
  static Matrix Random(int rows, int cols) {
    Matrix result = new Matrix(rows, cols);
    result.randomize();
    return result;
  }
  
  //Matrix in einen String umwandeln
  static String[] stringify(Matrix a) {
    String[] result = new String[a.rows];
    for(int i = 0; i < a.rows; i++) {
      result[i] = "";
      for(int j = 0; j < a.cols; j++) {
        result[i] += a.values[i][j] + ",";
      }
    }
    return result;
  }
  
  //Matrix speichern
  static void Save(Matrix a, String filename) {
    String[] arr = Matrix.stringify(a);

    try (FileWriter writer = new FileWriter(System.getProperty("user.dir") + "\\" + filename + ".data");
         BufferedWriter bw = new BufferedWriter(writer)) { 
      
      for(int i = 0; i < arr.length; i++) {
        bw.write(arr[i]);
        bw.newLine();
      }
    }catch(IOException e) {
      System.err.format("IOException: %s%n", e);
    }
  }
  
  //Matrix laden
  static Matrix Load(String filename, int rows, int cols) {
    Matrix a = new Matrix(rows, cols);
    a.randomize();
    
    try (FileReader reader = new FileReader(System.getProperty("user.dir") + "\\" + filename + ".data");
         BufferedReader br = new BufferedReader(reader);
         Scanner sc = new Scanner(br)) {
           
     while(sc.hasNextLine()) {
       for(int i = 0; i < rows; i++) {
         String[] data = sc.nextLine().trim().split(",");
         for(int j = 0; j < cols; j++) {
           a.values[i][j] = Float.valueOf(data[j]);
         }
       }
     }
     
   }catch(IOException e) {
     System.err.format("IOException: %s%n", e);
   }
   
   return a;
  }
  
  //Matrix mit einem float multiplizieren
  void multiply(float n) {
    for(int i = 0; i < rows; i++) {
      for(int j = 0; j < cols; j++) {
        values[i][j] *= n;
      }
    }
  }
  
  //Matrix mit einem float addieren
  void mAdd(float n) {
    for(int i = 0; i < rows; i++) {
      for(int j = 0; j < cols; j++) {
        values[i][j] += n;
      }
    }
  }
  
  //Alle Werte der Matrix zufällig 
  void randomize() {
    for(int i = 0; i < rows; i++) {
      for(int j = 0; j < cols; j++) {
        values[i][j] = (float) Math.random() * 2 - 1;
      }
    }
  }
  
  //Eine Matrix a von einer Matrix b subtrahieren
  static Matrix subtract(Matrix a, Matrix b) {
    Matrix result = new Matrix(a.rows, a.cols);
    for(int i = 0; i < a.rows; i++) {
      for(int j = 0; j < a.cols; j++) {
        result.values[i][j] = a.values[i][j] - b.values[i][j];   
      }
    }
    return result;
  }
  
  //Matrix aus einem float[] erstellen
  static Matrix fromArray(float[] arr) {
    Matrix result = new Matrix(arr.length, 1);

    for(int i = 0; i < result.rows; i++) {
      result.values[i][0] = arr[i];
    }
    return result;
  }
  
  //Matrix in ein float[] umwandeln
  float[] toArray() {
    float[] arr = new float[rows + cols];
    for(int i = 0; i < rows; i++) {
      for(int j = 0; j < cols; j++) {
        arr[i] = values[i][j];  
      }
    }
    return arr;
  }
  
  //Zu der Matrix eine Matrix addieren
  void mAdd(Matrix b) {
    for(int i = 0; i < rows; i++) {
      for(int j = 0; j < cols; j++) {
        values[i][j] += b.values[i][j];  
      }
    }
  }
  
  //Zu der Matrix eine Matrix multiplizieren
  void multiply(Matrix b) {
    for(int i = 0; i < rows; i++) {
      for(int j = 0; j < cols; j++) {
        values[i][j] *= b.values[i][j];
      }
    }
  }
  
  //Matrix transponieren
  static Matrix transpose(Matrix a) {
    Matrix result = new Matrix(a.cols, a.rows);
    for(int i = 0; i < a.rows; i++) {
      for(int j = 0; j < a.cols; j++) {
        result.values[j][i] = a.values[i][j];
      }
    }
    return result;
  }
  
  //Produkt aus Matrix a und Matrix b
  static Matrix Product(Matrix first, Matrix second) {
    if(first.cols != second.rows)
      return null;
    else {
      Matrix a = first;
      Matrix b = second;
      Matrix result = new Matrix(a.rows, b.cols);
      for(int i = 0; i < result.rows; i++) {
        for(int j = 0; j < result.cols; j++) {
          float sum = 0;
          for(int k = 0; k < a.cols; k++) {
            sum += a.values[i][k] * b.values[k][j];
          }
          result.values[i][j] = sum;
        }
      }
      return result;
    }
  }
  
}
