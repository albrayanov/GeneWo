import spout.*;
import rita.*;
import java.util.*;

static int BACKGROUND_COLOUR = 20; // 0 to 255
static int MAX_ROW = 7;
static int MIN_WORD_SIZE = 20;
static boolean RECORD = false;

Spout spout;
String senderName;
Map<String,Integer> displayWords = new HashMap<String,Integer>();
PFont mainFont;
PFont secondaryFont;

int currentX,currentRow,currentWordIndex,mostCommonWordAppearences;
float currentWordSize;
float noiseScale = 5;
int count;

void formatInput()
{
  HashMap<String,Boolean> arguments = new HashMap<String,Boolean>();
  arguments.put("ignoreCase", true);
  arguments.put("ignoreStopWords", true);
  arguments.put("ignorePunctuation", true);
  String inputText = join(loadStrings("generator-input.txt")," ");
  displayWords = RiTa.concordance(inputText, arguments);
  mostCommonWordAppearences = Collections.max(displayWords.values());
}

void setup() {
  size(1920,1080,P2D);
  textAlign(LEFT);
  background(BACKGROUND_COLOUR);
  fill(52, 112, 132);
  formatInput();

  mainFont = createFont("AllertaStencil-Regular.ttf", 150);
  secondaryFont = createFont("Miratrix-Normal.otf", 150);
  textFont(mainFont);
  
  count = 0;
  //Decoment the following lines to enable SPOUT
  spout = new Spout(this);
  senderName = "Genewo";
  spout.createSender(senderName, width, height); 

}


void draw() {
    background(BACKGROUND_COLOUR);
    
    currentRow = 0;
    currentX = 20;
    while(currentRow < MAX_ROW)
    {
      currentWordIndex = (int)random(0, displayWords.keySet().size());
      currentWordSize = (int) ((displayWords.get(displayWords.keySet().toArray(new String[0])[currentWordIndex])
                                  /(double) mostCommonWordAppearences ) * 100 
                                  + MIN_WORD_SIZE); 
      float  wordSize = displayWords.keySet().toArray(new String[0])[currentWordIndex].length() *  currentWordSize;
      if (currentX + wordSize > width) {
        currentRow++;
        if (currentRow >= MAX_ROW) 
        {
          break;
        }
        currentX = 20;
      }
      double displayProbability = random(0, 1);
      if (displayProbability > 0.1)
      {
          double fontProbability = random(0, 1);
          if (fontProbability > 0.7) 
          {
             textFont(secondaryFont);
          } 
          else 
          {
             textFont(mainFont);
          }
          textSize(currentWordSize);
          text(displayWords.keySet().toArray(new String[0])[currentWordIndex]
               , currentX, currentRow * 150 + 100);
      }
      currentX +=wordSize;
    }
    
    if (RECORD && count < 1800 )
    {
      saveFrame("frames/####.png");
      count++;
    } 
    else
    {
      delay(500); // get tempo
    }
    spout.sendTexture();
}
