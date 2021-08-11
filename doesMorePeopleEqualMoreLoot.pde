int MIN_ORIGINAL_PEOPLE = 20;
int MAX_ORIGINAL_PEOPLE = 30;
int MIN_EXTRA_PEOPLE = 0;
int MAX_EXTRA_PEOPLE = 8;

int LAYOUT_MEASUREMENT_MARGIN = 10; //pixels from edge
int LAYOUT_MEASUREMENT_SPACING = 10; //pixels between cells
int LAYOUT_TOP_PANEL_SIZE = 20; //pixels for top panel

int TEXT_SIZE = 10;

//calculated at start
int layoutMeasurementCellWidth; //how wide a cell can be
int layoutMeasurementCellHeight; //how tall a cell can be

//dynamic
float colorMagnification=0f;

int count;
Scenario[] scenarios;

class Player {
  public boolean extra;
  public int items;
  public boolean canReceiveItem;
  
  Player(boolean e){
    extra = e;
    items = 0;
    canReceiveItem = true;
  }
}

class Scenario{
  private float averagePayoff;
  private int originalPeople;
  private int extraPeople;
  private int totalPeople;
  private int extraAboveMin;
  private int originalAboveMin;
  private Player[] players;
  public int raidsCompleted = 0;
  
  Scenario (int original, int extra){
    originalPeople = original;
    extraPeople = extra;
    totalPeople = originalPeople + extraPeople;
    averagePayoff = 0f;
    originalAboveMin = originalPeople - MIN_ORIGINAL_PEOPLE;
    extraAboveMin = extraPeople - MIN_EXTRA_PEOPLE;
    raidsCompleted = 0;
  
    players = new Player[totalPeople];
    int index = 0;
    for (int i = 0; i < originalPeople; i++){
      players[index++] = new Player(false);
    }
    for (int i = 0; i < extraPeople; i++){
      players[index++] = new Player(true);
    }
  }
  
  void updateAverage(){
    int originalPlayerItems = 0;
    
    for (Player pla : players) {
      if (!pla.extra){
        originalPlayerItems += pla.items;
      }
    }   
    
    averagePayoff = (float) originalPlayerItems / (float) raidsCompleted / (float) originalPeople;
  }
  
  void simulateRaid(){
    for (Player pla : players) {
      pla.canReceiveItem = true;
    }

    //calculate actual items gained
    int itemsToDistribute = floor((float) totalPeople / 5f);
    int peopleAboveChance = totalPeople - itemsToDistribute * 5;
     if (random(0f,1f) <= (float)peopleAboveChance/5f) itemsToDistribute++;
     
    //distribute the items to random players
    for (int i = 0; i < itemsToDistribute; i++){
      int randomPlayerIndex = (int)floor(random(totalPeople));
      Player targetPlayer = players[randomPlayerIndex];
      while (!targetPlayer.canReceiveItem) {
        randomPlayerIndex = (int)floor(random(totalPeople));
        targetPlayer = players[randomPlayerIndex];
      }
      
      targetPlayer.items++;
      targetPlayer.canReceiveItem = false;
    }
        
    raidsCompleted++;
  };
  
  void update(){
    simulateRaid();
    updateAverage();  
  }
  
  void display(){
    color c1 = color(255,0,0);
    color c2 = color(0,255,0);
    color c = lerpColor(c1,c2, 0.5f+(averagePayoff-0.2f)*colorMagnification);
    
    fill(c);
    //layoutMeasurementCellWidth
    int x = LAYOUT_MEASUREMENT_MARGIN + extraAboveMin * layoutMeasurementCellWidth + extraAboveMin * LAYOUT_MEASUREMENT_SPACING;
    int y = LAYOUT_TOP_PANEL_SIZE + LAYOUT_MEASUREMENT_MARGIN + originalAboveMin * layoutMeasurementCellHeight + originalAboveMin * LAYOUT_MEASUREMENT_SPACING;
    int xsize = layoutMeasurementCellWidth;
    int ysize = layoutMeasurementCellHeight;
    rect(x,y,xsize,ysize);
    
    fill(0);
    textSize(TEXT_SIZE);
    String outputText = nf(averagePayoff, 0, 6);
    outputText += "\n" + originalPeople + "/" + extraPeople;
    text(outputText, x+layoutMeasurementCellWidth/2-textWidth(outputText)/2, y+layoutMeasurementCellHeight/2-(TEXT_SIZE)/2);
  }
}


void setup() {
  size(640,600);
  
  //setup all required scenarios
  int wideCount = MAX_EXTRA_PEOPLE - MIN_EXTRA_PEOPLE + 1;
  int highCount = MAX_ORIGINAL_PEOPLE - MIN_ORIGINAL_PEOPLE + 1;
  count = wideCount * highCount;
  scenarios = new Scenario[count];
  int index = 0;
  for (int y = 0; y < highCount; y++) {
    for (int x = 0; x < wideCount; x++) {
      scenarios[index++] = new Scenario(y + MIN_ORIGINAL_PEOPLE,x + MIN_EXTRA_PEOPLE);
    }
  }
  
  //setup layout
  layoutMeasurementCellWidth = (width - (2 * LAYOUT_MEASUREMENT_MARGIN) - ((MAX_EXTRA_PEOPLE-MIN_EXTRA_PEOPLE) * LAYOUT_MEASUREMENT_SPACING)) / (MAX_EXTRA_PEOPLE-MIN_EXTRA_PEOPLE+1);
  layoutMeasurementCellHeight = (height - LAYOUT_TOP_PANEL_SIZE - (2 * LAYOUT_MEASUREMENT_MARGIN) - ((MAX_ORIGINAL_PEOPLE-MIN_ORIGINAL_PEOPLE) * LAYOUT_MEASUREMENT_SPACING)) / (MAX_ORIGINAL_PEOPLE-MIN_ORIGINAL_PEOPLE+1);
}

void draw() {
  background(0);
  
  colorMagnification = pow(10,(int)(max(min((float)mouseX / (float)width,width),0)*20));
  
  for (Scenario sce : scenarios) {
    for (int i = 0; i < 3000; i++)
    sce.update();
    sce.display();
  }
  
  fill(255);
  textSize(TEXT_SIZE);
  String outputText =  "Raids done: " + (scenarios[0].raidsCompleted/1000) + "K. Expected vs measured difference color magnification: " + colorMagnification;
   text(outputText, LAYOUT_MEASUREMENT_MARGIN, LAYOUT_MEASUREMENT_MARGIN+(TEXT_SIZE)/2);
}

void mouseClicked(){
  setup();
}
