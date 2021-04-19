import oscP5.*;
import netP5.*;
import controlP5.*;
import java.util.Map;


import uibooster.*;
import uibooster.model.*;

ControlP5 gui;
NetAddress myRemoteLocation;
OscP5 oscP5;
OscMessage positionMessageX, positionMessageY, positionMessageZ,
           colorMessageR, colorMessageG, colorMessageB,
           scaleMessageX, scaleMessageY, scaleMessageZ,
           levelMessage, intensityMessage, cameraMessage;
           
           
float lightIntensity = 1.0;


int waitTime = 2000, objectPositionIndex = 0,cameraId = 0;
float[] lightColor = new float[3];
PVector scale3D = new PVector(1.0, 1.0, 1.0);
ArrayList<PVector> objectPositions = new ArrayList<PVector>();

void createGUI(){
 /* gui = new ControlP5(this);
  gui.addSlider("Message Frequency")
          .setPosition(10,10)
          .setRange(1000,10000)
          .setValue(2000)
          .setNumberOfTickMarks(20)
          .setSliderMode(Slider.FLEXIBLE); ]
          */

  new UiBooster()
    .createForm("Untopia DynaMod")
    .addSlider("Message Frequency", 0, 10000, 2000, 2000, 100)
    .addColorPicker("Light Colour")
    .addSlider("Light Intensity", 0, 100, 1, 10, 1)
    .addSlider("Object Scale", 1, 100, 1, 9, 1)
    .addSlider("Object Position", 0, 9, 1, 3, 1)
    .addSlider("Camera Id", 0, 4, 1, 2, 1)
    .setChangeListener(new FormElementChangeListener() {
        public void onChange(FormElement element, Object value) {
           if(element.getLabel().equals("Message Frequency")) {
              waitTime = element.asInt();
           }
           if(element.getLabel().equals("Object Position")) {
              objectPositionIndex = element.asInt();
              
              positionMessageX.add(objectPositions.get(objectPositionIndex).x);
              positionMessageY.add(objectPositions.get(objectPositionIndex).y);
              positionMessageZ.add(objectPositions.get(objectPositionIndex).z);
              oscP5.send(positionMessageX,myRemoteLocation);
              oscP5.send(positionMessageY,myRemoteLocation);
              oscP5.send(positionMessageZ,myRemoteLocation);
              positionMessageX.clearArguments();
              positionMessageY.clearArguments();
              positionMessageZ.clearArguments();
           }
           if(element.getLabel().equals("Object Scale")) {
              float scaleValue = element.asInt() / 10.0;
              scale3D.set(scaleValue, scaleValue, scaleValue);
              
              scaleMessageX.add(scale3D.x);
              scaleMessageY.add(scale3D.y);
              scaleMessageZ.add(scale3D.z);
              oscP5.send(scaleMessageX,myRemoteLocation);
              oscP5.send(scaleMessageY,myRemoteLocation);
              oscP5.send(scaleMessageZ,myRemoteLocation);
              scaleMessageX.clearArguments();
              scaleMessageY.clearArguments();
              scaleMessageZ.clearArguments();
           }
           if(element.getLabel().equals("Light Colour")) {
              element.asColor().getColorComponents(lightColor);
              
              colorMessageR.add(lightColor[0]);
              colorMessageG.add(lightColor[1]);
              colorMessageB.add(lightColor[2]);
              oscP5.send(colorMessageR,myRemoteLocation);
              oscP5.send(colorMessageG,myRemoteLocation);
              oscP5.send(colorMessageB,myRemoteLocation);
              colorMessageR.clearArguments();
              colorMessageG.clearArguments();
              colorMessageB.clearArguments();
              
           }
           if(element.getLabel().equals("Light Intensity")) {
              lightIntensity = element.asFloat() / 10.0;
              intensityMessage.add(lightIntensity);
              oscP5.send(intensityMessage,myRemoteLocation);
              intensityMessage.clearArguments();
           }
           if(element.getLabel().equals("Camera Id")) {
              cameraId = element.asInt();
              cameraMessage.add(cameraId);
              oscP5.send(cameraMessage,myRemoteLocation);
              cameraMessage.clearArguments();
           }
           // To Do add cameraId and buildingLocation slider
           
        }
    })
    .show();
}
void initOSCMessages(){
 
  colorMessageR =  new OscMessage("untopia/light/color/r");
  colorMessageG =  new OscMessage("untopia/light/color/g");
  colorMessageB =  new OscMessage("untopia/light/color/b");
  
  scaleMessageX =  new OscMessage("untopia/object/scale/x");
  scaleMessageY =  new OscMessage("untopia/object/scale/y");
  scaleMessageZ =  new OscMessage("untopia/object/scale/z");
  
  positionMessageX =  new OscMessage("untopia/object/postion/x");
  positionMessageY =  new OscMessage("untopia/object/postion/y");
  positionMessageZ =  new OscMessage("untopia/object/postion/z");
  
  levelMessage =  new OscMessage("untopia/level");
  cameraMessage =  new OscMessage("untopia/camera");
  intensityMessage =  new OscMessage("untopia/light/intensity");
}

// TO-DO: select Untopia locations
void setMapPositions()
{
  for (int i = 0; i < 10; i++) {
    objectPositions.add(new PVector(random(1,100),random(1,100),random(1,100)));
  }
}

public void setup() {

  rectMode(CENTER);
  textAlign(CENTER, CENTER);

  oscP5 = new OscP5(this, 7001);
  //oscP5 = new OscP5(this, 7000);
  myRemoteLocation = new NetAddress("127.0.0.1", 7000);
  initOSCMessages();
  setMapPositions();
  createGUI();
}


public void draw() {

}
