int MIN_ORIGINAL_PEOPLE = 15;
int MAX_ORIGINAL_PEOPLE = 35;
int MIN_EXTRA_PEOPLE = 0;
int MAX_EXTRA_PEOPLE = 5;

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
  private int raidsCompleted = 0;
  
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
    
    //averagePayoff += random(-0.1f, +0.1f); //placeholder for visualization
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
    color c = lerpColor(c1,c2, 0.5f+(averagePayoff-0.2f)*1000f);
    
    fill(c);
    int x = 20 + extraAboveMin * 100;
    int y = 20 + originalAboveMin * 25;
    int xsize = 90;
    int ysize = 15;
    rect(x,y,xsize,ysize);
    
    fill(0);
    text(nf(averagePayoff, 0, 6), x+5, y+12);
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
}

void draw() {
  background(0);
  for (Scenario sce : scenarios) {
    for (int i = 0; i < 1000; i++)
    sce.update();
    sce.display();
  }
}
