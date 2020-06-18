
/*																												*
 * 																												*
 * this macro will slice nucleus into 5 equodistant slices and measure the average intensity of each area semi-automatically 	*
 * 																												*
 * 																												*
 */
 
 
// must have two folders in the same path: concentric slice & intensityAuto

// save Dapi-stack as: C1-01.tif, C1-02.tif, etc in "concentric slice"

// save protein-of-interest-stack as: C2-01.tif, C2-02.tif, etc in "concentric slice"


path = "/Users/gokce/Desktop/line scan analysis/";
list = getFileList(path + "concentric slice/");
N=list.length/2;

//for (h=1; h<=N; h++) {
h=35


TableName="[My Table]";
TableNameWindow="My Table";
run("Table...", "name="+TableName+" width=650 height=250");
print(TableName,"\\Headings:nucleus\tROI1\tROI2\tROI3\tROI4\tROI5");


	for (h=1; h<=N; h++) {
	if (h <= 9) nb = "0" + h;
	else nb = "" + h;
	
	open(path + "concentric slice/C1-" + nb + ".tif");
	setAutoThreshold("Otsu dark");
setOption("BlackBackground", false);
run("Convert to Mask");

run("Options...", "iterations=5 count=4 do=Erode");

run("ROI Manager...");

waitForUser("apply wand on dapi image and add ROI");

open(path + "concentric slice/C2-" + nb + ".tif");

roiManager("Select", 0);
run("Scale... ", "x=0.80 y=0.80 centered");
roiManager("Add");
roiManager("Deselect");

roiManager("Select", 0);
run("Scale... ", "x=0.60 y=0.60 centered");
roiManager("Add");
roiManager("Deselect");

roiManager("Select", 0);
run("Scale... ", "x=0.40 y=0.40 centered");
roiManager("Add");
roiManager("Deselect");

roiManager("Select", 0);
run("Scale... ", "x=0.20 y=0.20 centered");
roiManager("Add");
roiManager("Deselect");


roiManager("Select", 0);
roiManager("Rename", "slice 5");
roiManager("Select", 1);
roiManager("Rename", "slice 4");
roiManager("Select", 2);
roiManager("Rename", "slice 3");
roiManager("Select", 3);
roiManager("Rename", "slice 2");
roiManager("Select", 4);
roiManager("Rename", "slice 1 & area 1");

roiManager("Deselect");

open(path + "concentric slice/C2-" + nb + ".tif");
roiManager("Select", 4);
run("Make Inverse");
roiManager("Add");
roiManager("Select", 5);
roiManager("Rename", "slice 1 inverse");
roiManager("Deselect");
roiManager("Select", newArray(3, 5));
roiManager("AND");
roiManager("Add");
roiManager("Select", 6);
roiManager("Rename", "area 2");
roiManager("Deselect");

open(path + "concentric slice/C2-" + nb + ".tif");
roiManager("Select", 3);
run("Make Inverse");
roiManager("Add");
roiManager("Select", 7);
roiManager("Rename", "slice 2 inverse");
roiManager("Deselect");
roiManager("Select", newArray(2, 7));
roiManager("AND");
roiManager("Add");
roiManager("Select", 8);
roiManager("Rename", "area 3");
roiManager("Deselect");

open(path + "concentric slice/C2-" + nb + ".tif");
roiManager("Select", 2);
run("Make Inverse");
roiManager("Add");
roiManager("Select", 9);
roiManager("Rename", "slice 3 inverse");
roiManager("Deselect");
roiManager("Select", newArray(1, 9));
roiManager("AND");
roiManager("Add");
roiManager("Select", 10);
roiManager("Rename", "area 4");
roiManager("Deselect");

open(path + "concentric slice/C2-" + nb + ".tif");
roiManager("Select", 1);
run("Make Inverse");
roiManager("Add");
roiManager("Select", 11);
roiManager("Rename", "slice 4 inverse");
roiManager("Deselect");
roiManager("Select", newArray(0, 11));
roiManager("AND");
roiManager("Add");
roiManager("Select", 12);
roiManager("Rename", "area 5");
roiManager("Deselect");


roiManager("Select", newArray(4, 6, 8, 10, 12));
roiManager("Measure");


IntN=newArray(5);

//j is the ROI. There are 10 per cell.


for(j=0;j<5;j++)

{
	
	IntN[j]=getResult("Mean",j);
	
}

print(TableName,h+"\t"+IntN[0]+"\t"+IntN[1]+"\t"+IntN[2]+"\t"+IntN[3]+"\t"+IntN[4]);

	if (isOpen("Results")) {
	   selectWindow("Results"); 
	 saveAs("Text", path + "intensityAuto/area_"+nb+".csv");
	  run("Close");
	}
		
	  
waitForUser("confirm all steps are done correctly");

roiManager("Deselect");
roiManager("Delete");


while (nImages>0) { 
          selectImage(nImages); 
          close(); 

}

}


