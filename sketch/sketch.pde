import processing.opengl.*;
import codeanticode.glgraphics.*;
import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.utils.*;
import de.fhpotsdam.unfolding.marker.*;

UnfoldingMap map;
Location herentLocation = new Location(50.88, 4.69);
List<Location> locationList = new ArrayList<Location>();
int locationCounter = 0;
List<Integer> timeList = new ArrayList<Integer>();

void setup() {
    size(800, 600, GLConstants.GLGRAPHICS);
    smooth();
    map = new UnfoldingMap(this);
    
    
    noStroke();
    fill(255,0,0,200);
    frameRate(25);
    
    map.zoomAndPanTo(new Location(herentLocation.getLat(), herentLocation.getLon()), 12);
    loadData();
    MapUtils.createDefaultEventDispatcher(this, map);    
}

void draw() {
    map.draw();
    
    Integer opacity = 50;
    for (int i = max(locationCounter - 5,0); i <= locationCounter; i++ ) {
      SimplePointMarker m = new SimplePointMarker(locationList.get(i));
      ScreenPosition markerPos = m.getScreenPosition(map);
      
      fill(255,0,0,opacity);
      ellipse(markerPos.x, markerPos.y, 10, 10);
      opacity = opacity + 25;
    }
    
    // Draw timeline
    Float remappedTime = map(timeList.get(locationCounter), 0, 1440, 0, 200);
    fill(200,200,200);
    rect(0, 500, 200,20);
    strokeWeight(3);
    stroke(0,0,0);
    line(remappedTime, 500, remappedTime, 520);
    noStroke();
    
    locationCounter = locationCounter + 1;
    
    if ( locationCounter >= locationList.size() ) { exit(); };
}

void loadData() {
  String lines[] = loadStrings("data.csv");
  println("there are " + lines.length + " lines");
  for (int i = 0 ; i < lines.length; i++) {
    String[] fields = lines[i].split(",");
    locationList.add(new Location(float(fields[1]),float(fields[2])));
    String[] timeFields = fields[0].split("T")[1].split(":");
    Integer minutesAfterMidnight = 60*int(timeFields[0]) + int(timeFields[1]);
    timeList.add(minutesAfterMidnight);
  }
}
