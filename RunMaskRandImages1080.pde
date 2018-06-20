import processing.video.*;
import java.net.HttpURLConnection;    // required for HTML download
import java.net.URL;
import java.net.URLEncoder;
import java.io.InputStreamReader;     // used to get our raw HTML source   
import rita.*;


String syns="", word = "";
RiLexicon lexicon;

String searchTerm = "noise";   // term to search for (use spaces to separate terms)
int offset = 20;                      // we can only 20 results at a time - use this to offset and get more!
String fileSize = "xga&tbm=isch";             // specify file size in mexapixels (S/M/L not figured out yet)
String source = null;  
String gURL1 = null;  


PImage img1;
Movie imgMask1;



void setup() {
//size(768, 1024);
  fullScreen(2);

  frameRate(24);
  imageMode(CENTER);
  img1 = loadImage("background.png"); // 226x227 pixel image
  img1.resize(768,1024);
  imgMask1 = new Movie(this, "1.mov");
  imgMask1.loop();

  getURL();
  getIMG();

  lexicon = new RiLexicon();
   RiTa.timer(this, 2); // every 2 sec
  


imgMask1 = new Movie(this, "1.mov");
imgMask1.loop();

}

void draw() {
// image(img, width/2, height/2);
background(255);

img1.resize(768,1024);

if(img1.width == 768 && img1.height ==1024){
img1.mask(imgMask1);
scale(2);
image(img1, width/2-275, height/2-500);

getIMG();
}
}
void getURL() {
  searchTerm = searchTerm.replaceAll(" ", "%20");

  try {
    URL query = new URL("http://images.google.com/images?gbv=1&start=" + offset + "&q=" + searchTerm + "&tbs=isz:lt,islt:" + fileSize);
    println("http://images.google.com/images?gbv=1&start=" + offset + "&q=" + searchTerm + "&tbs=isz:lt,islt:" + fileSize);
    HttpURLConnection urlc = (HttpURLConnection) query.openConnection();                                // start connection...
    urlc.setInstanceFollowRedirects(true);
    urlc.setRequestProperty("User-Agent", "");
    urlc.connect();
    BufferedReader in = new BufferedReader(new InputStreamReader(urlc.getInputStream()));               // stream in HTTP source to file
    StringBuffer response = new StringBuffer();
    char[] buffer = new char[1024];
    while (true) {
      int charsRead = in.read(buffer);
      if (charsRead == -1) {
        break;
      }
      response.append(buffer, 0, charsRead);
    }
    in.close();                                                                                          // close input stream (also closes network connection)
    source = response.toString();
  }
  // any problems connecting? let us know
  catch (Exception e) {
    e.printStackTrace();
  }

   //print full source code (for debugging)
   //println(source);

  // extract image URLs only, starting with 'imgurl'
  if (source != null) {
    String[][] m = matchAll(source, "img height=\"\\d+\" src=\"([^\"]+)\"");

    // older regex, no longer working but left for posterity
    // built partially from: http://www.mkyong.com/regular-expressions/how-to-validate-image-file-extension-with-regular-expression
    // String[][] m = matchAll(source, "imgurl=(.*?\\.(?i)(jpg|jpeg|png|gif|bmp|tif|tiff))");    // (?i) means case-insensitive
    for (int i=0; i<m.length; i++) {                                                          // iterate all results of the match
      gURL1 = m[(int)random(0, 20)][1];
     



      /// println(i + ":\t" + m[i][1]);     // print (or store them)**
    }
    println(gURL1);
    
  }

  // ** here we get the 2nd item from each match - this is our 'group' containing just the file URL and extension

  // all done!
  ///exit();
  getIMG();
}

void getIMG(){

  img1 = loadImage(gURL1, "jpg");
  img1.resize(768,1024);
}

void onRiTaEvent(RiTaEvent re) { // called by timer

  searchTerm = lexicon.randomWord();
  getURL();
  
  
}
void movieEvent(Movie m) {
  m.read();
}