int minX, minY, maxX, maxY, oldMinX, oldMinY, oldMaxX,oldMaxY;
int startGridX, startGridY, minSize, maxSize;
int[][] letterSizeGrid = new int[7][13];
int[][] letterValueGrid = new int[7][13];
int[][] letterXPosition = new int[7][13];
int[][] letterYPosition = new int[7][13];
float noiseScale = 5;
int count;
PFont latinLettersFont;
PFont cyrilicLettersFont;
static int  BACKGROUND_COLOUR = 20; // 0 to 255

import spout.*;
Spout spout;
String senderName;
String[] letters = {"А", "Б", "В", "Г", "Д", "Е", "Ж", "З"
                    , "И", "Й", "К", "Л", "М", "Н", "О", "П"
                    , "Р", "С", "Т", "У", "Ф", "Ц", "Ч", "Ш"
                    , "Щ", "Ъ", "Ь","Ю", "Я","A","B","C", "D"
                    , "E","F", "G", "H", "I" ,"J" ,"K", "L"
                    , "M","N","O","P", "Q", "R","S", "T", "U"
                    , "V", "W", "X", "Y", "Z"};

void setup() {
  size(1920,1080,P2D);
  textAlign(CENTER);
  background(BACKGROUND_COLOUR);
  fill(52, 112, 132);
  latinLettersFont = createFont("AllertaStencil-Regular.ttf",150);
  cyrilicLettersFont = createFont("Miratrix-Normal.otf",150);
  textFont(latinLettersFont);
  
  //initalize start point of the grid and min/max size of a letter 
  startGridX = 65;
  startGridY = 140;
  minSize = 50;
  maxSize = 150;
  
  //assign inital min and max elements (may use another random function)
  minX = (int) random(0, 6);
  minY = (int) random(0, 12);
  maxX = (minX + (int) random(0,6)) % 7;
  maxY = (minY + (int) random(0,12)) % 13;
  oldMinX = minX;
  oldMinY = minY;
  oldMaxX = maxX;
  oldMaxY = maxY;
  
  //intialize lettter position coordinates and values
  for (int i = 0; i < 7; i++) 
  {
     for (int j = 0; j < 13; j++) 
     {
       // set position coordinates
         letterXPosition[i][j] = startGridX + 148 * j;
         letterYPosition[i][j] = startGridY + 150 * i;
         
        // set letter values
         letterValueGrid[i][j] = (int) random(0, letters.length - 1);
       // set letter sizes
         if (j == minX && i == minY) {
            letterSizeGrid[i][j] = minSize;
         }
         else if (j == maxX && i == maxY) 
         {
           letterSizeGrid[i][j] = maxSize;
         }
         else 
         {
           letterSizeGrid[i][j] = ((minSize - j ) * (i + maxSize)) % (maxSize - minSize) + minSize;
           if (letterSizeGrid[i][j] == minSize) letterSizeGrid[i][j]++;
           else if (letterSizeGrid[i][j] == maxSize ) letterSizeGrid[i][j]--;
         }
     }
  }
  count = 0;
  //Decoment the following lines to enable SPOUT
  spout = new Spout(this);
  senderName = "Le gene";
  spout.createSender(senderName, width, height); 

}
void update() 
{
  //update random seed 
  //update min and max
  minX = (int) ((oldMinX + oldMaxX)/ 2.0) % 7;
  minY = (int) ((oldMinY + oldMaxY)/ 2.0) % 13;
  maxX = (minX + (int) random(0,6)) % 7;
  maxY = (minY + (int) random(0,12)) % 13;
  oldMinX = minX;
  oldMinY = minY;
  oldMaxX = maxX;
  oldMaxY = maxY;
  
  for (int i = 0; i < 7; i++) 
  {
     for (int j = 0; j < 13; j++)
     {
       
        //update letter values 
        letterValueGrid[i][j] = (int)random(0, letters.length);
         
        //update letter sizes
         if (j == minX && i == minY) {
            letterSizeGrid[i][j] = minSize;
         }
         else if (j == maxX && i == maxY) 
         {
           letterSizeGrid[i][j] = maxSize;
         }
         else 
         {
           int oldSize =  letterSizeGrid[i][j];
           letterSizeGrid[i][j] = (abs(oldSize*j - i*minSize ) * (j*maxSize + i*oldSize)) % (maxSize - minSize) + minSize;
           if (letterSizeGrid[i][j] == minSize) letterSizeGrid[i][j]++;
           else if (letterSizeGrid[i][j] == maxSize ) letterSizeGrid[i][j]--;
         }
     }
  }
}

void draw() {
  //if (count < 1800)
  //{
    update();
    background(BACKGROUND_COLOUR);
    
    for (int i = 0; i < 7; i++) 
    {
       for (int j = 0; j < 13; j++)
       {
           double displayProbability = random(0,1);
           if (displayProbability > 0.33)
           {
             if (letterValueGrid[i][j] < 30) 
             {
               textFont(cyrilicLettersFont);
             }
             else 
             {
                textFont(latinLettersFont);
             }
             textSize(letterSizeGrid[i][j]);
             text(letters[letterValueGrid[i][j]], letterXPosition[i][j]
                 , letterYPosition[i][j]);
           }
       }
    }
    //saveFrame("frames/####.png");
    delay(70); // get tempo
 //}
 //count++;
 spout.sendTexture();
 
}
